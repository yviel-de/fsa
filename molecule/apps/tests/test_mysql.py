import sys, os, time
sys.path.append(os.path.join(os.path.dirname(__file__)))
from utils import _install_program, _assert_equals, _assert_in
import pytest

# Global Variables
HOSTNAME = 'webdav-mpd-' + os.environ['boxname'] + '-' + os.environ['commitid']
DB_ADDR = '172.16.123.16'
DB_PORT = 3306
DB_DB = 'mydatabase'
DB_USER = 'mysqluser'
DB_PASS = 'mysqlpass'
DB_TABL = 'mydatabase'

# Test Function
def _all_tests_mysql(host):

    # Step 1: Install Programs

    _install_program(host, 'mariadb-client', 'mariadb-client', 'mariadb-client')

    # Step 2: Run all tests

    # Test 1: Check if USER/PASSWORD/DB/TABLE exists

    com = host.run(f"mysql -h{DB_ADDR} -u{DB_USER} -p{DB_PASS} {DB_DB} --connect-timeout=10 -e 'SHOW TABLES;'");
    _assert_equals(com.rc, 0, "MYSQL USER/PASSWORD/DATABASE DOES NOT EXIST")
    _assert_in(DB_TABL, com.stdout.strip(), "MYSQL TABLE DOES NOT EXIST")

# Main Function
def test_mysql(host):
    if host.run("hostname").stdout.strip() == HOSTNAME:
        _all_tests_mysql(host)
    else:
        pytest.skip("Skipping  MYSQL test for {}".format(host.backend.get_hostname()))

