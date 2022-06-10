# yviel's FSA - **F**ull **S**erver **A**utomation
No more following random blogposts, wandering around filesystems doing things you already forgot. Declare your configuration in a simple tree format, press the button and watch it happen.

Special thanks to Mischa Peters of [obsd.ams](https://openbsd.amsterdam) for his gracious support.

You are viewing the documentation for v0.2.0 - use the branch list on the top left to switch.

**This software is provided as-is, I take no responsibility for your misconfigurations, my bugs, etc etc.**

## Table of Contents
 - [Project Goals](#project-goals)
 - [Features](#features)
 - [Documentation](#documentation)

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
 * Under active development - [bug reports and feature requests](https://github.com/yviel-de/fsa/issues) welcome!


## Documentation
Documentation can be found in the `roles` folder and subfolders.

The following pages should help you on your way.

 - [Install & Quickstart](roles/docs/QUICKSTART.md)
 - [Config Docs](roles/)
 - [Full Config Reference](roles/docs/REFERENCE.md)
 - [fsa Command Docs](roles/docs/FSA_CMD.md)
 - [Changelog & Related Infos](roles/CHANGELOG.md)
