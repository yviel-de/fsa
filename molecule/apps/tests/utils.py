# Helper Functions
def _addr_reachable(host, address, port):
    addr = host.addr(address).port(port)
    return addr.is_reachable

def _install_program(host, obsd_pkg, alpine_pkg, deb_pkg):
     host.run(f"sudo pkg_add {obsd_pkg} || sudo apk add {alpine_pkg} || sudo apt install {deb_pkg}")

def _assert_equals(value1, value2, error_message):
    if value1 != value2:
        raise AssertionError(error_message)

def _assert_in(value, contained_in, error_message):
    if value not in contained_in.split():
        raise AssertionError(error_message)
