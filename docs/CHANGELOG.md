# Changelog - yviel's FSA v0.3.0
This page contains changelog, roadmap, and the next envisioned steps.

## Table of Contents
 - [Long-term Goals](#long-term-goals)
 - [Short-term Goals](#short-term-goals)
 - [Version History](#version-history)
 - [v0.3.0](#v0.3.0)
 - [v0.2.0](#v0.2.0)
 - [v0.1.0](#v0.1.0)

## Long-term goals
 * Significant improvements to Web stack
 * Auto-backup and auto-monitoring
 * Proper teardown and cleanup of resources
 * Port to Debian & Alpine w/ full feature parity
 * Addition of numerous other utilities
 * and a bunch of secondary features, improvements and fixes

## Short-term Goals
 * Better Kubernetes integration
 * Internal modularity improvements
 * Clean up of difficult parts of the code

## Version History

## v0.3.0
#### Description
Most of the work has again been under the hood.

Automated tests have been set up for almost everything, and lots of code refactored along the way. A couple of select features are implemented on Alpine, and a bunch of build and test scripts and configs were added to the repository.

`virt` has been hard-limited to x64 machines (sorry ARM) and Alpine support partially hacked in, in order to get the advantages of [Vagrant](https://developer.hashicorp.com/vagrant) as a backend for the testing framework.

The development workflow was revamped, and with it comes a new rolling-release scheme and new install instructions. Should you have installed FSA with the old method, you can simply update your installation as in the current docs.

Finally FSA can now also be installed as an ansible collection to complement an existing codebase.

#### Changes
*Note:* Any functionality introduced on Alpine Linux, or Kubernetes, is to be considered *Alpha and not ready for production use*!

###### Config
The following functionality has been introduced:
 * `web`:
    * *Breaking*: `relay.backends.type` added with default `http` analogue to `frontends.type`
    * *New*: `sites.port` added for non-default ports

 * `net`:
    * *Breaking*: `vpn` was significantly refactored. It now supports external connections through specifying pubkeys, but comes with changes to the config format.

 * `apps`:
    * *Breaking*: `webdav` fully replaced baikal with radicale
    * *Breaking*: `mysql.users.ondb` made mandatory
    * *New*: `gitea` added on OpenBSD and Alpine
    * *New*: `mpd` added on OpenBSD and Alpine
    * *New*: `k3s` added on Alpine
    * *New*: `mysql` added on Alpine

 * `fsa`:
    * *New*: `k8s` added for managing Kubernetes clusters

 * `k8s`:
    * *New*: `helm` added for management of helm repos and releases
    * *New*: `drone` CICD system added on K8S
    * *New*: `wikimd` wiki system added on K8S

###### Utilities
 * `fsa.sh` now requires an explicit `-l`imit, no longer implicitly selects `all`
 * `fsa.sh -p`laybook now requires playbooks to be in `playbooks` and have a `.yml` extension
 * `fsa.sh` extended with a `-t`erraform flag to exec custom terraform code
 * `*-fsa.sh` helper scripts introduced together with `drone.star` CICD config

## v0.2.0
#### Description
Most of the work is under the hood.

In preparation for Debian and Alpine support, basic [unit tests](https://molecule.readthedocs.io/) have been introduced throughout the codebase, with a plan to greatly expand them in v0.3.

To this effect a [custom molecule driver](../roles/fsa_molecule/) has been developed for OpenBSD's VMD, and the ansible codebase has been greatly refactored and linted and such.

`fsa` was pretty much completely rewritten and is now actually useful. Utilities have all been `pipenv`ed, and the directory structure is now more closely aligned with that of ansible.

Finally, the documentation has also seen some significant updates.

#### Changes
These are only some of the new functionality introduced.

###### Config
 * `web`:
    * *Breaking*: `relayd` key globally renamed to `relay`, since it also sets up / will set up haproxy
        * This command should auto-fix it: `sed -i 's/relayd:/relay:/g' config/*`
    * *Breaking:* `front` key globally renamed to `origin` to make it more intuitive
        * This command should auto-fix it: `sed -i 's/front:/origin:/g' config/*`

 * `apps`:
    * *Breaking*: `dav` removed, replaced by `webdav`
    * *New*: `mysql` added with optional auto-import feature

 * `mail`:
    * *Breaking*: `filter` intermediate value globally renamed from `true` to `conn`, to reflect its nature and prevent conflicts.
        * This command should auto-fix it: `sed -i 's/filter: true/filter: conn/g' config/*` (*Warning! see below*)
        * *Warning:* in the edge case that you explicitly set `net.dns.filter: true`, that setting will also be changed. Be aware and double-check things.

 * `virt`:
    * *Breaking*: *New*: `install` now actually autoinstall the VM's OS
        * Previous behavior subsumed into `iso`
    * `private` added for putting VMs behind NAT

 * `fsa`:
    * Added for setting connection and privilege parameters

###### Command
 * *Breaking*: `genpass` changed to `-g` (or `--genpass`) in line with the rest
 * *Breaking*: `-t|--tags` changed to `-r|--roles` since that's what it does in the context of fsa
 * *New*: `-p|--playbook` to execute playbooks from the playbook directory
 * *New*: `-v|--verbose` argument added for verbose output
 * *New*: can now be used in a classic non-fsa ansible directory
 * *New*: dynamically builds inventory file if it doesn't exist
 * *New*: dynamically builds playbooks on the basis of config keys and cli flags
 * *New*: dynamically sets parallel execution in proportion to available cpu cores

## v0.1.0
#### Description
First public release, OpenBSD targets only.

The webserver is limited because of its OBSD nature.

VPN for the moment only possible between inventoried hosts.
