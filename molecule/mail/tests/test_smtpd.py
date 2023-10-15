import sys, os, time
sys.path.append(os.path.join(os.path.dirname(__file__)))
from utils import _assert_equals
import pytest

HOSTNAME = 'mail-server-a-' + os.environ['boxname'] + '-' + os.environ['commitid']

RCPT = 'vagrant@mailserverb.local'

# Test Function
def _all_tests_smtpd(host):

    # Test 1: Check if host B can be pinged from host A
    # host_b_reachable = host.run("ping -c 3 mailserverb.local")
    # _assert_equals(host_b_reachable.rc, 0, "host B is unreachable from host A")

    # Step 1: Send mail to host B
    mail_send = host.run(f"echo 'Test Mail' | mail -s 'Test Subject' {RCPT}")
    _assert_equals(mail_send.rc, 0, "mail couldn't be sent successfully")

    # Test 1: Check if relayed mail from host B is denied
    mail_logs = host.run(f"sleep 15; grep -e '550' /var/log/maillog | grep -e '{RCPT}'")
    _assert_equals(mail_logs.rc, 0, "mail test failed")

def _show_logs(host):
    print(host.run("cat /var/log/maillog").stdout)

# Main Function
def test_httpd_relay(host):
    if host.run('hostname').stdout.strip() == HOSTNAME:
        _all_tests_smtpd(host)
        # _show_logs(host)
    else:
        pytest.skip("Skipping SMTPD test for {}".format(host.backend.get_hostname()))
        # _show_logs(host)
