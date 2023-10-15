import sys, os, time
sys.path.append(os.path.join(os.path.dirname(__file__)))
from utils import _install_program, _assert_equals
import pytest

HOSTNAME = 'gitea-mysql-' + os.environ['boxname'] + '-' + os.environ['commitid']
WEBDAV_ADDR = '172.16.123.17'
WEBDAV_PORT = 5232
WEBDAV_USER, WEBDAV_PASS = 'user1', 'pass1'

def _all_tests_webdav(host):

    #  Step 1: Install all necessary programs

    _install_program(host, 'curl', 'curl', 'curl')

    # Step 2: Run all tests

    # Test 1: Check if webdav server can be accessed
    response_check = host.run(f"curl -vu {WEBDAV_USER}:{WEBDAV_PASS} http://{WEBDAV_ADDR}:{WEBDAV_PORT} 2>&1 | grep -q '302'")
    _assert_equals(response_check.rc, 0, "webdav server not running properly")

# Main Function
def test_webdav(host):
    if host.run('hostname').stdout.strip() == HOSTNAME:
        _all_tests_webdav(host)
    else:
        pytest.skip("Skipping HTTPD and RELAYD test for {}".format(host.backend.get_hostname()))

