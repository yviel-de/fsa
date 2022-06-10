# Quickstart - yviel's FSA `v0.2.0`
This page contains a quickstart for the impatient ones.

## Table of Contents
 - [Install](#install)
 - [Git](#git)
    - [Save your Configs](#save-your-configs)
    - [Get FSA Updates](#get-fsa-updates)
 - [Manage a Host with FSA](#manage-a-host-with-fsa)
    - [Target Requirements](#target-requirements)
    - [Config File](#config-file)
    - [Apply Config](#apply-config)

## Install
*Note: These are commands to run in a Linux command line. If you don't already have linux tooling, see the [HowTos](HOWTOS.md)*.

 - Install `git` and `pipenv`:
	 - Deb/Ubu: `sudo apt install git pipenv`
	 - Fedora: `sudo yum install git pipenv`
	 - OpenBSD: `doas pkg_add git pipenv`
	 - Alpine: `sudo apk add git pipenv`
     - MacOS: `brew install git pipenv`

 - Clone and enter the repository:
	 - `git clone https://github.com/yviel-de/fsa.git && cd fsa`

 - Install the prerequisites:
     - `pipenv install -r utils/requirements.txt`

 - Set up an alias:
     - `alias fsa='sh utils/fsa.sh'`

 - Persist it in your shell startup file
    -  Run `ls -la ~/ | grep -E "$SHELL|profile"` - most of the time it will be `.profile` or `.bash_profile`.
    - `echo 'alias fsa="./fsa"' >> ~/myshellstartupfile`

## Git
If you find yourself using FSA over an extended period of time, you *really* should save and version your configs in a git repo of your own.

#### Save your Configs
Create your own new, bare, private git repository, then, from inside your existing FSA folder:

* `git remote del origin`
* `git remote add origin https://github.com/my-user/my-repo.git`
* `git add .; git commit . -m "first commit"`
* `git push --set-upstream origin master`

You've now saved the current FSA state into your own git repository.

#### Get FSA Updates

* `git remote add fsa-upstream https://github.com/yviel-de/fsa.git`
* `git fetch fsa-upstream`
* `git fetch fsa-upstream`
* `git merge fsa-upstream/<version> -m "FSA Update"`

You can then update FSA like this, pulling from its repo but saving to your own.

See the [Changelog](utils/docs/CHANGELOG.md) for information on releases.

## Manage a host with FSA
#### Target Requirements
The target must run a supported operating system:
 - OpenBSD
 - Alpine Linux (planned)
 - Debian Linux (planned)

Further, it must be reachable via SSH into a user with root privileges.

*Be aware that FSA assumes *exclusive* control over the target host!* Running an empty config will produce no changes, but you should expect any config to overwrite global files such as `/etc/crontab` and `/etc/syslog.conf`.

It is therefore recommended to start with a blank, freshly installed OS.

#### Config File
Every target has its own file in the `config/` folder. You might need to set some [connection parameters](../../roles/fsa_connect), if not an empty file will suffice.

That file will eventually hold the target's entire configuration.

#### Apply Config
From within the FSA root folder, simply run `fsa` to apply everything... and that's it!

Look at the [roles folder](../../roles/) for inspiration, or the [command reference](FSA_CMD.md) for `fsa` for more fine-grained execution.
