import sys, os, time
sys.path.append(os.path.join(os.path.dirname(__file__)))
from utils import _server_ping, _assert_equals
import pytest

# Global Variables
HOSTNAME = 'client-vpn-' + os.environ['boxname'] + '-' + os.environ['commitid']
FW_BLOCKED_ADDR = '93.184.216.34'

# Test Function
def _all_tests_dns(host):

    # Test 1: Check if Blocked server can be pinged.
    ping_blocked_server = _server_ping(host, FW_BLOCKED_ADDR)
    _assert_equals(ping_blocked_server.rc, False, "Firewall rule is not set properly OR client-vpn is using a different default gateway")

    # Test 2: Check if other servers can be pinged
    ping_google = _server_ping(host, 'google.com')
    _assert_equals(ping_google.rc, 0, "Cannot ping google.com")

def test_dns(host):
    if host.run('hostname').stdout.strip() == HOSTNAME:
        _all_tests_dns(host)
    else:
        pytest.skip("Skipping Firewall test for {}".format(host.backend.get_hostname()))
