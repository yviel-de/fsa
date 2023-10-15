import sys, os, time
sys.path.append(os.path.join(os.path.dirname(__file__)))
from utils import _server_resolvable, _assert_equals
import pytest

# Global Variables
DNS_SERVER_HOST = 'dhcp-dns-fw-' + os.environ['boxname'] + '-' + os.environ['commitid']
DNS_CLIENT_HOST = 'client-vpn'

# Test Functions
def _tests_dns_server(host):

    # Test 1: Check if google.com can be resolved (SHOULD)
    google_resolvable = _server_resolvable(host, 'google.com')
    _assert_equals(google_resolvable.rc, 0, "google.com is not resolvable")

    # Test 2: Check if googleadservices.com can be resolved (SHOULD, since it's whitelisted)
    googleadservices_resolvable = _server_resolvable(host, 'googleadservices.com')
    _assert_equals(googleadservices_resolvable.rc, 0, "googleadservices.com is not resolvable")

    # Test 3: Check if any other ad server's domain name can be resolved (SHOULDN'T)
    ads_doubleclick_net_resolvable = _server_resolvable(host, 'ads.doubleclick.net')
    _assert_equals(ads_doubleclick_net_resolvable.rc, 1, "ads.doubleclick.net is resolvable (SHOULDN'T BE)")

def _tests_dns_client(host):

    # Test 1: Check if the server resolves any domain name (SHOULDN'T, since all queries from the client is denied)
    google_resolvable = _server_resolvable(host, 'google.com')
    _assert_equals(google_resolvable.rc, 1, "google.com is resolvable (SHOULDN'T BE)")

def test_dns(host):
    if host.run('hostname').stdout.strip() == DNS_SERVER_HOST:
        _tests_dns_server(host)
    elif host.run('hostname').stdout.strip() == DNS_CLIENT_HOST:
        _tests_dns_client(host)
    else:
        pytest.skip("Skipping DNS test for {}".format(host.backend.get_hostname()))
