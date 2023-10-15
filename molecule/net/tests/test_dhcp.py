import sys, os, time
sys.path.append(os.path.join(os.path.dirname(__file__)))
from utils import _server_ping, _assert_equals
import pytest

# Global Variables
HOSTNAME = 'dhcp-dns-fw-' + os.environ['boxname'] + '-' + os.environ['commitid']
DHCP_CLIENT_ADDR = '172.17.123.12'

# Test Function
def _all_tests_dhcp(host):

    # Test 1: Check if the DHCP client can be pinged from DHCP server.
    ping_dhcp_server = _server_ping(host, DHCP_CLIENT_ADDR)
    _assert_equals(ping_dhcp_server.rc, 0, "DHCP client is not reachable")

def test_dhcp(host):
    if host.run('hostname').stdout.strip() == HOSTNAME:
        _all_tests_dhcp(host)
    else:
        pytest.skip("Skipping DHCP test for {}".format(host.backend.get_hostname()))
