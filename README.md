# yviel's Full Server Automation
An extensive server configuration and administration system built with [ansible](https://docs.ansible.com).

In the age of Big Tech, self-hosting is as important as ever, and FSA makes it easy. No more following random blogposts, wandering around filesystems doing things you already forgot. Declare your configuration in a simple and easy tree format, press the button and watch it happen.

FSA aims to be an [easy system](EXAMPLES.md) for beginners to use, and a [simple and reliable base](CHANGELOG.md#contribute) for professionals to tailor to their needs.

[Bug reports and feature requests](https://github.com/yviel-de/fsa/issues) welcome!

Special thanks to Mischa Peters of [obsd.ams](https://openbsd.amsterdam) for his gracious support.

**This software is provided as-is, I take no responsibility for your screwups and misconfigurations, etc etc.**

You are viewing the documentation for `v0.1.0` - use the branch list to switch.

 - [Features](#features)
 - [Install](#install)
    - [Updates](#updates)
 - [Add a Target to FSA](#add-a-target-to-fsa)
    - [Target Prerequisites](#target-prerequisites)
    - [Inventory](#inventory)
    - [Required Config](#required-config)
        - [base](#required-base)
        - [net](#required-net)
 - [Apply Target Configuration](#apply-target-configuration)
    - [List of CLI Options](#list-of-fsa-command-line-options)
    - [Examples](#examples)
    - [Known Gotchas](#known-gotchas)
 - [Further Instructions](#further-instructions)
    - [Examples](EXAMPLES.md)
    - [Reference](REFERENCE.md)
    - [Changelog](CHANGELOG.md)
    - [HowTos](HOWTOS.md)

## Features
 * Full network automation, DHCP, DNS, VPN, Routing, Firewalling
 * Full web automation, Webserver + PHP, Relay/LB
 * Full automation of select applications, WebDAV
 * Scales to hundreds if not thousands of systems

Under active development - view the [Roadmap](CHANGELOG.md#roadmap).

## Install
See the [HowTos](HOWTOS.md#i-dont-have-linux-tooling) if you don't have Linux tooling installed.

 - Install `git` and `ansible`:
	 - Deb/Ubu: `sudo apt install git ansible`
	 - Fedora: `sudo yum install git ansible`
	 - OpenBSD: `doas pkg_add git ansible`
	 - Alpine: `sudo apk add git ansible`
     - MacOS: `brew install git ansible`
 - Clone and enter the repository:
	 - `git clone https://github.com/yviel-de/fsa.git && cd fsa`
 - Set up an alias:
     - `alias fsa="./fsa"`
 - Persist it in your shell startup file
    -  Run `ls -la ~/ | grep -E "$SHELL|profile"` - most of the time it will be `.profile` or `.bash_profile`.
    - `echo 'alias fsa="./fsa"' >> ~/myshellstartupfile`

#### Updates
If you find yourself using FSA over an extended period of time, you *really* should save and version your configs in a git repo of your own.

Create your own new git repository, then

##### From this repository you just cloned:
* `git remote rename origin fsa-upstream`
* `git remote add origin ssh://my_user@my_remote_server/my_bare_repository.git`
* `git push --set-upstream origin master`

##### From your own, *bare* repository:
* `git remote add fsa-upstream https://github.com/yviel-de/fsa.git`
* `git fetch fsa-upstream`
* `git merge fsa-upstream/<version>`
* `git push --set-upstream origin master`

##### You can now keep FSA up to date like this:
* `git fetch fsa-upstream`
* `git merge fsa-upstream/<version> -m "FSA Update"`

See the [Changelog](CHANGELOG.md) for information on releases.

## Add a Target to FSA

Be aware that *FSA assumes **exclusive** control* over the target host!

It is therefore recommended to start with a blank, freshly installed OS.

## Target Prerequisites
You must use a supported operating system, currently limited to OpenBSD, to be expanded to [Debian and Alpine](CHANGELOG.md#roadmap).

You must ssh with a key into a non-`root` user with full sudo/doas privileges, without having to specify user, domain/IP or port.

Most of this can be verified with the the following command:

`ssh myhostname 'doas which python3'`

If it doesn't return `/usr/local/bin/python3`, you have work to do before being able to add your host to FSA.

See the [HowTos](HOWTOS.md#fulfilling-the-target-prerequisites) for detailed instructions.

### Inventory
Every single target host must be present in your `inventory` file, without its domain suffix, so that FSA knows about it.

`echo myhostname >> inventory`


### Required Config
Every single target host also requires a configuration file of the same name inside the `config/` folder, e.g. `config/myhostname`.

Your own configuration aside, the following entries are *required* for FSA to function:

#### Required: `base`

Three keys in `base` *must* be defined:
```
base:
  name: myhost.mydomain.local
  user: myusername
# either one of these two
  nopass: true
  userpw: crypted value
```
These are:
* the host's Fully Qualified Domain Name
* the non-`root` admin's username on the host
* an admin password hash ***or*** enabled password-less sudo/doas

Use `fsa genpass [mypass]` to generate the crypted hash values required.

Note that if you do not set `userpw` and `rootpw`, any existing passwords for these will be unset! As mentioned [further above](#add-a-target-to-fsa), FSA assumes exclusive control over the target.

See the [Reference](REFERENCE.md#base) for implicit defaults.

#### Required: `net`

FSA communicates over SSH, which in turn requires networking and interfaces.

If you're shrugging right now, your host was most likely autoconfigured with DHCP, and the interface name alone suffices.
```
net:
  ifaces:
    - name: eth0
```
Use the fact-finder with `fsa -f -l myhostname` to determine the interface you're looking for. (see "Apply target Configuration" below)

A server almost always has a static IP, set it up by specifying address and netmask.
```
    - name: eth0
      addr: 192.168.0.123
      netmask 255.255.255.0
```

A minimal example containing this configuration can be found in `config/minimalhost`.

See the [Reference](REFERENCE.md#net) for routes, firewall and more.

## Apply Target Configuration
Running `fsa` without any arguments will apply all configuration to all hosts.
You *must* be within your FSA directory for it to detect your configuration.

#### List of `fsa` Command-LIne Options:
```
-l [--limit]: limits execution to specific hosts
-c [--config]: limits configuration to specific blocks
-u [--updates]: perform only updates
-f [--finder]: run the fact-finder
-h [--help]: display this information
genpass: generate passwords and hashes
```

#### Examples

Update VPN, mailbox and relay config on `host1` and `host2`:

`fsa -c vpn,boxes,relay -l host1,host2`

`-t [--tags]` is a valid replacement for `-c`:

`fsa -t ifaces,fw,dhcp -l host1`

(see the [Reference](REFERENCE.md) for all keys)

Run the finder on `host3`:

`fsa -f -l host3`

Generate a random password and its hashes:

`fsa genpass`

Run only updates on all hosts:

`fsa -u`

#### Known Gotchas

 - `fsa` will always prompt you for a sudo/doas password for your hosts. If they're `nopass`ed you can just press Enter.

 - When an `fsa` run fails, there is currently no way to replay triggers that would have run, things like service restarts, LetsEncrypt requests, etc.

   For now the workaround is to try changing things in the config to try and re-trigger things. If you can, best thing is to wipe and reinstall the target OS.

Quality of Life issues like these will be addressed in future versions.

## Further Instructions

Everything from this point forward is up to you.

Add your hosts, define their configuration, press the button and watch it happen :)

Use the [Examples](EXAMPLES.md) for simple, practical examples and inspiration.

Check out the [Reference](REFERENCE.md) to customize things to your own liking.

View the [Changelog](CHANGELOG.md) for release and version information.

Refer to the [HowTos](HOWTOS.md) for any issue you might encounter.

As FSA is in active development, you should [report any bug or missing feature](https://github.com/yviel-de/fsa/issues), including in this documentation.

