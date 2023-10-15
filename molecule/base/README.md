# `base` - yviel's FSA v0.3.0
This test scenario is for the `base` key.

## Table of Contents
  - [Setup](#setup)
  - [Testing](#testing)
  - [Roles Used](#roles-used)

#### Setup
A machine is created with the following configurations:
- Sound is enabled
- A user with sudo privileges is created
- SSHGuard is enabled
- A cronjob is created for the user
- System updates are enabled

#### Testing
Tests are not written yet

## Roles Used
- [base](../../roles/base)
- [net](../../roles/net)
- [cron](../../roles/cron)
- [sshd](../../roles/sshd)
