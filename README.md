# yviel's FSA - **F**ull **S**erver **A**utomation
<img src="https://img.shields.io/badge/Ansible-informational.svg?logo=Ansible"> <img src="https://img.shields.io/badge/Bash-informational.svg?logo=Shell"> <img src="https://img.shields.io/badge/OpenBSD-success.svg?logo=OpenBSD">

No more following random blogposts, wandering around filesystems editing config files you already forgot about. Declare your setup in a simple tree format, press the button and watch it happen.

Special thanks to Mischa Peters of [obsd.ams](https://openbsd.amsterdam) for his gracious support.

You are reading the documentation for FSA v0.3.0. Use Releases, or Tags, to switch around.

**This software is provided as-is, I take no responsibility for your misconfigurations, my bugs, etc etc.**

## Table of Contents
 - [Project Goals](#project-goals)
 - [Features](#features)
 - [Contents](#contents)
 - [Releases](#releases)

## Project Goals
 - Provide full automation for any and all common services in small- to medium-sized setups.
 - Cover all common scenarios, and serve as a solid base to build upon.
 - Be simple and lean for maximum usability, robustness and extensibility.
 - Be easy both for newbies to use and for experts to customize.

## Features
 * Full network automation, DHCP, DNS, VPN, Routing, Firewalling
 * Full web automation, Webserver + PHP, Relay/LB
 * Full mail automation, DKIM, relay, spam filtering
 * Full automation of select applications, WebDAV, MySQL

## Contents
All folders have their own READMEs.
 - [config/](config/): home of your server configs
 - [docs/](docs/): home of most documentation
 - [molecule/](molecule/): home of automated tests for FSA
 - [playbooks/](playbooks/): home of custom extensions to FSA
 - [roles/](roles/): home and documentation of config options
 - [utils/](utils/): home of various scripts, helpers and config files

## Development
Under Active Development - Feature Requests and Bug Reports welcome!

Touch base with us directly [on Discord](https://discord.gg/hk7gMYDtN3). Matrix bridge will come in the future.
