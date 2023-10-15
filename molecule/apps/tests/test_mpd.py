import sys, os, time
sys.path.append(os.path.join(os.path.dirname(__file__)))
from utils import _install_program, _assert_equals
import pytest

# Global Variables
HOSTNAME = 'webdav-mpd-' + os.environ['boxname'] + '-' + os.environ['commitid']
MPD_ADDR = '127.0.0.1'
MPD_PORT = 6601

# Test Function
def _all_tests_mpd(host):

    # Step 1: Install necessary programs

    _install_program(host, 'mpc', 'mpc', 'mpc')

    # Step 2: Run all tests

    # Test 1: Check if MPD playlists can be listed out
    list_playlists_cmd = host.run(f"mpc -h {MPD_ADDR} -p {MPD_PORT} lsplaylists")
    _assert_equals(list_playlists_cmd.rc, 0, "mpc lsplaylists FAILED")

    # Test 2: Load the first playlist
    first_playlist = list_playlists_cmd.stdout.strip().split("\n")[0]
    load_first_song_cmd = host.run(f"mpc -h {MPD_ADDR} -p {MPD_PORT} load {first_playlist}")
    _assert_equals(load_first_song_cmd.rc, 0, "mpc load <playlist> FAILED")

    # Test 3: Play the loaded playlist
    play_playlist_cmd = host.run(f"mpc -h {MPD_ADDR} -p {MPD_PORT} play")
    _assert_equals(play_playlist_cmd.rc, 0, "mpc play FAILED")

    # Test 4: Check mpd status
    check_status_cmd = host.run(f"mpc -h {MPD_ADDR} -p {MPD_PORT} status | grep playing")
    _assert_equals(check_status_cmd.rc, 0, "mpc status FAILED")

# Main Function
def test_mpd(host):
    if host.run("hostname").stdout.strip() == HOSTNAME:
        _all_tests_mpd(host)
    else:
        pytest.skip(f"Skipping MPD test for {host.backend.get_hostname()}")
