import sys, os, time
sys.path.append(os.path.join(os.path.dirname(__file__)))
from utils import _addr_reachable, _install_program, _assert_equals
import pytest

# Global Variables
HOSTNAME = 'webdav-mpd-' + os.environ['boxname'] + '-' + os.environ['commitid']
GITEA_ADDR = '172.16.123.16'
GITEA_PORT = 3000
MAX_ITER = 100

# Test Function
def _all_tests_gitea(host):

    # Step 1: Install all necessary programs

    _install_program(host, 'curl', 'curl', 'curl')

    # Step 2: Run all tests

    # Test 1 : Wait for a few iterations for gitea webserver to start
    s = 0
    while (s < MAX_ITER):
        gitea_reachable = _addr_reachable(host, GITEA_ADDR, GITEA_PORT)
        if gitea_reachable:
            break
        s += 1
        time.sleep(1)
    _assert_equals(gitea_reachable, True, "GITEA SERVER NOT REACHABLE")

    # Test 2: Check if HTTP connections can be made to the gitea server
    response_check_1 = host.run(f"curl {GITEA_ADDR}:{GITEA_PORT} 2>&1 | grep -q 'my-gitea.com'")
    _assert_equals(response_check_1.rc, 0, "'my-gitea.com' CONTENT NOT FOUND")

    response_check_2 = host.run(f"curl {GITEA_ADDR}:{GITEA_PORT} 2>&1 | grep -q 'my-beautiful-gitea'")
    _assert_equals(response_check_2.rc, 0, "'my-beautiful-gitea' CONTENT NOT FOUND")

# Main Function
def test_gitea(host):
    if host.run('hostname').stdout.strip() == HOSTNAME:
        _all_tests_gitea(host)
    else:
        pytest.skip("Skipping GITEA test for {}".format(host.backend.get_hostname()))
