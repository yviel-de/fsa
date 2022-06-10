# Changelog - yviel's FSA v0.2.0
This page contains changelog, release and other technical information.

## Table of Contents
 - [Meta](#meta)
    - [Release & Maintenance Policy](#release-and-maintenance-policy)
    - [Roadmap](#roadmap)
    - [Next Version Goals](#next-version-goals)
    - [Contribute](#contribute)
 - [v0.2.0](#v0.2.0)
    - [Description](#description)
    - [Changes](#changes)
 - [v0.1.0](#v0.1.0)
    - [Description](#description)

## Meta
#### Release and Maintenance Policy
Every new version is individually branched off of development, then bugfixed and changelogged separately.

The *latest 2 versions* are actively maintained and bugfixed, older versions *may* receive fixes at my sole discretion. You are therefore encouraged to stay up to date.

There is no fixed release schedule, new versions are published whenever I feel like it's appropriate.

#### Roadmap
 * Significant improvements to Web stack
 * Auto-backup and auto-monitoring
 * Proper teardown and cleanup of resources
 * Port to Debian & Alpine w/ full feature parity
 * Implementation of a number of `apps`, including
    * Matrix
    * k8s
    * DroneCI
 * and a bunch of secondary features, improvements and fixes

#### Next Version Goals
 * Implementation of full role tests covering almost-all bases
 * Port to alpine of [virt](virt/) and associated ([vms](vms/) et al)
 * Significant refactor and streamlining of VM autoinstalls and templates
 * Allow cleanly undoing any modifications made

#### Contribute

`fsa` is ansible code with a shellscript wrapper around it, as such extending it should be easy.

Development follows these guidelines:
 - Simplicity first - both under the hood and for the user.
 - Any ansible code must work with only `python3`, no installing python3-foobar.
 - Role cross-dependencies must be as sensible and clean as possible.
 - Any ansible code must fit into the existing variable format.
 - Any ansible code must do nothing if no variables are defined.
 - Any shell code must be portable enough to run on OpenBSD's `ksh` and Alpine's `ash`.

If you have code of your own you'd like merged, please open a [feature request](https://github.com/yviel-de/fsa/issues).

## v0.2.0
#### Description
Most of the work is under the hood.

In preparation for Debian and Alpine support, basic [unit tests](https://molecule.readthedocs.io/) have been introduced throughout the codebase, with a plan to greatly expand them in v0.3.

To this effect a [custom molecule driver](roles/fsa_molecule/) has been developed for OpenBSD's VMD, and the ansible codebase has been greatly refactored and linted and such.

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
    * *Breaking*: `dav` key globally renamed to `webdav` to be more descriptive
        * This command should auto-fix it: `sed -i 's/dav:/webdav:/g' config/*`
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
 * *New*: `-p|--playbook` argument added for manually testing things
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
