import sys, os, time
sys.path.append(os.path.join(os.path.dirname(__file__)))
from utils import _install_program, _assert_equals
import pytest

HOSTNAME = 'relayhost-' + os.environ['boxname'] + '-' + os.environ['commitid']
RELAYD_ADDR = '127.0.0.1'
RELAYD_PORT = 80

def _all_tests_httpd_relayd(host):

    #  Step 1: Install all necessary programs

    _install_program(host, 'curl', 'curl', 'curl')

    # Step 2: Run all tests

    # Test 1: Check if HTTP connections can be made to 127.0.0.1:80 from relayhost
    # If it can be made, then the web server is also working properly

    response_check = host.run(f"curl {RELAYD_ADDR}:{RELAYD_PORT} 2>&1 | grep -q 'bgplg'")
    _assert_equals(response_check.rc, 0, "relayd or httpd not running properly")

# Main Function
def test_httpd_relay(host):
    if host.run('hostname').stdout.strip() == HOSTNAME:
        _all_tests_httpd_relayd(host)
    else:
        pytest.skip("Skipping HTTPD and RELAYD test for {}".format(host.backend.get_hostname()))

