# `Mail` - yviel's FSA v0.3.0
This test scenario is for the `mail` key.

## Table of Contents
  - [SMTPD](#smtpd)
    - [Setup](#setup)
    - [Testing](#testing)
  - [Roles Used](#roles-used)

## General Setup
Two machines are created, and configured using `net` to be able to talk to each other. Their hostnames are changed to a convenient form for setting up MX records. Each machine's IP address is stored on other machine's resolver.

## SMTPD
#### Setup
Machine B's smtp server will relay all incoming mails to Machine A's smtp server.
Machine A's smtp server will store all incoming mails to inbox, if they satisfy the filter rules.

#### Testing
Testing if mail sent from A to B, which is relayed back to A is blocked.

## Roles Used
- [base](../../roles/base)
- [net](../../roles/net)
- [dns](../../roles/dns)
- [mail](../../roles/mail)
- [relay](../../roles/relay)
- [filter](../../roles/filter)
