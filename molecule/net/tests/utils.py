# Helper Functions
def _addr_reachable(host, address, port):
    addr = host.addr(address).port(port)
    return addr.is_reachable

def _assert_equals(value1, value2, error_message):
    if value1 != value2:
        raise AssertionError(error_message)

def _server_resolvable(host, server):
    return host.run(f"dig {server} | grep 'status: NOERROR'")

def _server_ping(host, server, MAX_ITER=5):
    # Looping through because ping might fail sometimes because of packet loss
    for _ in range(MAX_ITER):
        p = host.run(f"timeout 10 ping -c 1 {server}")
        if p.rc == 0:
            return p
    return p
