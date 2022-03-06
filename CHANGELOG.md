# Changelog - yviel's FSA `v0.1.0`
This page contains the changelog aswell as information pertaining to releases.

 - [Context](#)
    - [Release & Maintenance Policy](#release-maintenance-policy)
    - [Roadmap](#roadmap)
    - [Contribute](#contribute)
 - [v0.1.0](#v0.1.0)

#### Release & Maintenance Policy
Every new version is individually branched off of development, then bugfixed and changelogged separately.

The latest 2 versions are actively maintained and bugfixed, older versions *may* receive fixes at my sole discretion. You are therefore encouraged to stay up to date.

There is no fixed release schedule, new versions are published whenever I feel like it's appropriate.

#### Roadmap
 * Significant improvements to Web stack
 * Auto-backup and auto-monitoring
 * Port to Debian & Alpine w/ full feature parity
 * Implementation of a number of `apps`, including
    * Matrix
    * Gitea
    * k8s
    * DroneCI
 * and a bunch of secondary features, improvements and fixes like
    * VPN to non-`inventory` peers
    * VM OS autoinstall
    * More flexible user management
    * Proper handling of DNS records
    * Quality of Life improvements

#### Contribute

Extending `fsa` is fairly easy, under the hood is a plain `ansible` with a simple wrapper around it.

`fsa` development follows these conventions:
 - Any role cross-dependencies must be avoided. If they can't, they must be small and clean.
      (current cross-dependencies exist notably between `mail`, `web` and `base`)
 - Any ansible code must work with only `python3` on the target, no installing python3-foobar.
 - Any ansible code must fit into the existing variable format & be properly tagged
 - Any shell code must be portable and run on OpenBSD's `ksh` and Alpine's `ash`, eg no bashisms.

If you have code of your own you'd like merged, please open a [feature request](https://github.com/yviel-de/fsa/issues).

## v0.1.0
First public release, OpenBSD targets only.

The webserver is limited because of its OBSD nature.

VPN for the moment only possible between inventoried hosts.

