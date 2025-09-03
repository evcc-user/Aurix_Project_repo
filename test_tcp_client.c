#include "lwip/tcp.h"
#include "lwip/dhcp.h"
#include "lwip/netif.h"
#include "lwip/inet.h"
#include "lwip/ip_addr.h"
#include "lwip/err.h"
#include <string.h>
#include "Ifx_Lwip.h"
#include "Ifx_Types.h"
#include <stdbool.h>
extern struct netif g_Lwip_netif;  // You must declare your global netif here
#define TCP_CLIENT_RECONNECT_INTERVAL_MS 5000

static struct tcp_pcb *g_pcb_v4 = NULL;
static struct tcp_pcb *g_pcb_v6 = NULL;
static bool is_connected_v4 = false;
static bool is_connected_v6 = false;
static uint32_t lastReconnectAttempt_v4 = 0;
static uint32_t lastReconnectAttempt_v6 = 0;
#ifndef ip_addr_set_ip6
#define ip_addr_set_ip6(target, ip6addr) do { \
  (target)->type = IPADDR_TYPE_V6;           \
  ip6_addr_copy((target)->u_addr.ip6, *(ip6addr)); \
} while(0)
#endif
/* -------------------- Shared Callback Logic -------------------- */

static void close_tcp_connection(struct tcp_pcb **pcb_ptr, bool *is_connected)
{
    Ifx_Lwip_printf("[TCP_CLIENT] Closing connection.\n");

    if (*pcb_ptr != NULL) {
        tcp_recv(*pcb_ptr, NULL);
        tcp_sent(*pcb_ptr, NULL);
        tcp_err(*pcb_ptr, NULL);
        tcp_arg(*pcb_ptr, NULL);
        tcp_abort(*pcb_ptr);  // Use abort to ensure immediate cleanup
        tcp_close(*pcb_ptr);
    }

    *pcb_ptr = NULL;
    *is_connected = false;
}

static void on_tcp_error_v4(void *arg, err_t err)
{
    Ifx_Lwip_printf("[TCPv4] Error: %d\n", err);
    close_tcp_connection(&g_pcb_v4, &is_connected_v4);
}

static void on_tcp_error_v6(void *arg, err_t err)
{
    Ifx_Lwip_printf("[TCPv6] Error: %d\n", err);
    close_tcp_connection(&g_pcb_v6, &is_connected_v6);
}

static err_t on_tcp_recv_common(struct tcp_pcb *tpcb, struct pbuf *p, bool *is_connected)
{
    if (!p) {
        Ifx_Lwip_printf("[TCP_CLIENT] Server closed connection.\n");
        close_tcp_connection(&tpcb, is_connected);
        return ERR_OK;
    }

    char buffer[128] = {0};
    memcpy(buffer, p->payload, LWIP_MIN(p->tot_len, sizeof(buffer) - 1));
    Ifx_Lwip_printf("[TCP_CLIENT] Received: %s\n", buffer);

    tcp_recved(tpcb, p->tot_len);
    pbuf_free(p);
    return ERR_OK;
}

static err_t on_tcp_sent(void *arg, struct tcp_pcb *tpcb, u16_t len)
{
    Ifx_Lwip_printf("[TCP_CLIENT] Data sent (%d bytes acknowledged)\n", len);
    return ERR_OK;
}

/* -------------------- IPv4 Client -------------------- */

static err_t on_tcp_recv_v4(void *arg, struct tcp_pcb *tpcb, struct pbuf *p, err_t err)
{
    return on_tcp_recv_common(tpcb, p, &is_connected_v4);
}

static err_t on_tcp_connected_v4(void *arg, struct tcp_pcb *tpcb, err_t err)
{
    if (err != ERR_OK) {
        Ifx_Lwip_printf("[TCPv4] Connection failed: err=%d\n", err);
        close_tcp_connection(&g_pcb_v4, &is_connected_v4);
        return err;
    }

    Ifx_Lwip_printf("[TCPv4] Connected to server!\n");
    is_connected_v4 = true;

    tcp_recv(tpcb, on_tcp_recv_v4);
    tcp_sent(tpcb, on_tcp_sent);

    const char *msg = "Hello from AURIX (IPv4)!\r\n";
    err_t write_err = tcp_write(tpcb, msg, strlen(msg), TCP_WRITE_FLAG_COPY);
    if (write_err == ERR_OK) {
        tcp_output(tpcb);
    }

    return ERR_OK;
}

void start_tcp_client_ipv4(ip_addr_t *server_ip, uint16_t server_port)
{
    g_pcb_v4 = tcp_new();
    if (!g_pcb_v4) {
        Ifx_Lwip_printf("[TCPv4] Failed to create PCB\n");
        return;
    }

    tcp_err(g_pcb_v4, on_tcp_error_v4);
    err_t err = tcp_connect(g_pcb_v4, server_ip, server_port, on_tcp_connected_v4);

    if (err != ERR_OK) {
        Ifx_Lwip_printf("[TCPv4] tcp_connect() failed: err=%d\n", err);
        close_tcp_connection(&g_pcb_v4, &is_connected_v4);
    } else {
        Ifx_Lwip_printf("[TCPv4] Connecting to %s:%u\n", ipaddr_ntoa(server_ip), server_port);
    }
}

void tcp_client_poll_reconnect_ipv4(ip_addr_t *server_ip, uint16_t server_port)
{
    if (is_connected_v4) return;

    if (g_pcb_v4 == NULL) {
        uint32_t now = g_TickCount_1ms;

        if ((now - lastReconnectAttempt_v4) >= TCP_CLIENT_RECONNECT_INTERVAL_MS) {
            Ifx_Lwip_printf("[TCPv4] Attempting reconnect...\n");
            start_tcp_client_ipv4(server_ip, server_port);
            lastReconnectAttempt_v4 = now;
        }
    }
}

/* -------------------- IPv6 Client -------------------- */
#if LWIP_IPV6
static err_t on_tcp_recv_v6(void *arg, struct tcp_pcb *tpcb, struct pbuf *p, err_t err)
{
    return on_tcp_recv_common(tpcb, p, &is_connected_v6);
}

static err_t on_tcp_connected_v6(void *arg, struct tcp_pcb *tpcb, err_t err)
{
    if (err != ERR_OK) {
        Ifx_Lwip_printf("[TCPv6] Connection failed: err=%d\n", err);
        close_tcp_connection(&g_pcb_v6, &is_connected_v6);
        return err;
    }

    Ifx_Lwip_printf("[TCPv6] Connected to server!\n");
    is_connected_v6 = true;

    tcp_recv(tpcb, on_tcp_recv_v6);
    tcp_sent(tpcb, on_tcp_sent);

    const char *msg = "Hello from AURIX (IPv6)!\r\n";
    err_t write_err = tcp_write(tpcb, msg, strlen(msg), TCP_WRITE_FLAG_COPY);
    if (write_err == ERR_OK) {
        tcp_output(tpcb);
    }

    return ERR_OK;
}

void start_tcp_client_ipv6(const ip6_addr_t *server_ip, uint16_t server_port)
{
    Ifx_Lwip_printf("[TCPv6] Netif name: %c%c\n", g_Lwip.netif.name[0], g_Lwip.netif.name[1]);
    Ifx_Lwip_printf("[TCPv6] Link-local IP: %s\n", ip6addr_ntoa(netif_ip6_addr(&g_Lwip.netif, 0)));

    Ifx_Lwip_printf("[TCP_CLIENT_IPV6] Starting client...\n");
    Ifx_Lwip_printf("[TCPv6] Raw server_port = %u\n", (unsigned int)server_port);  // 👈 ADD HERE

    if (g_pcb_v6 != NULL) {
        Ifx_Lwip_printf("[TCP_CLIENT] Existing PCB state = %d, aborting\n", g_pcb_v6->state);
        tcp_abort(g_pcb_v6);
            g_pcb_v6 = NULL;
        }

    g_pcb_v6 = tcp_new_ip6();
    if (!g_pcb_v6) {
        Ifx_Lwip_printf("[TCPv6] Failed to create PCB\n");
        return;
    }

    tcp_bind_netif(g_pcb_v6, &g_Lwip.netif);  // ✅ REQUIRED for link-local

    err_t bind_err = tcp_bind(g_pcb_v6, netif_ip6_addr(&g_Lwip.netif, 0), 0);  // ✅ Safe bind with ANY


          if (bind_err != ERR_OK) {
              Ifx_Lwip_printf("[TCPv6] tcp_bind() failed: err=%d\n", bind_err);
              close_tcp_connection(&g_pcb_v6, &is_connected_v6);
              return;
          }
          // Assign scope to the link-local address
             ip6_addr_t scoped_server_ip = *server_ip;
             ip6_addr_assign_zone(&scoped_server_ip, IP6_UNICAST, &g_Lwip.netif);
             Ifx_Lwip_printf("Netif num: %d\n", g_Lwip.netif.num);

             Ifx_Lwip_printf("[CLIENT] Scoped server IP: [%s] ", ip6addr_ntoa(&scoped_server_ip));
                Ifx_Lwip_printf("[CLIENT] Scoped zone index: %d ", ip6_addr_zone(&scoped_server_ip));

                for (int i = 0; i < LWIP_IPV6_NUM_ADDRESSES; i++) {
                    const ip6_addr_t *addr = netif_ip6_addr(&g_Lwip.netif, i);
                            int state = g_Lwip.netif.ip6_addr_state[i];
                            const char *ip_str = ip6addr_ntoa(addr);

                            //Ifx_Lwip_printf("[DEBUG] netif_ip6_addr[%d] part1: %.16s\n", i, ip_str);
                           // Ifx_Lwip_printf("[DEBUG] netif_ip6_addr[%d] part2: %s (state = %d)\n", i, ip_str + 16, state);
                }

          tcp_err(g_pcb_v6, on_tcp_error_v6);

          g_pcb_v6->netif_idx = netif_get_index(&g_Lwip.netif);
    //err_t err = tcp_connect(g_pcb_v6, &scoped_server_ip, server_port, on_tcp_connected_v6);
          ip_addr_t dest_ip;
          ip_addr_set_ip6(&dest_ip, &scoped_server_ip);  // ✅ sets .type = IPADDR_TYPE_V6

          err_t err = tcp_connect(g_pcb_v6, &dest_ip, server_port, on_tcp_connected_v6);

    if (err != ERR_OK) {
        Ifx_Lwip_printf("[CLient] tcp_connect() failed: err=%d\n", err);
        close_tcp_connection(&g_pcb_v6, &is_connected_v6);
    } else {
        Ifx_Lwip_printf("[CLient] Connecting to [%s]:%u\n", ip6addr_ntoa(server_ip), server_port);
    }
}

void tcp_client_poll_reconnect_ipv6(const ip6_addr_t *server_ip, uint16_t server_port)
{
    if (is_connected_v6) return;

    if (g_pcb_v6 == NULL) {
        uint32_t now = g_TickCount_1ms;

        if ((now - lastReconnectAttempt_v6) >= TCP_CLIENT_RECONNECT_INTERVAL_MS) {
            Ifx_Lwip_printf("[TCPv6] Attempting reconnect...\n");
            start_tcp_client_ipv6(server_ip, server_port);
            lastReconnectAttempt_v6 = now;
        }
    }
}
#endif
