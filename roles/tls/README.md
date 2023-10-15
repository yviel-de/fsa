# `tls` - yviel's FSA v0.3.0

## Table of Contents
 - [Description](#description)
 - [Dependencies](#dependencies)
 - [Example Usage](#example-usage)
 - [Reference](#reference)
 - [See Also](#see-also)

### Description
This role sets up SSL certificates via LetsEncrypt.

### Works Against
- OpenBSD

### Dependencies
When called, it activates the following roles:
 - [cron](../cron)

### Example Usage
`tls` has no configuration of its own: it gets called by various other roles.

### Reference
`tls` has no configuration of its own: it gets called by various other roles.

([Full Reference here](../../docs/REFERENCE.md))

### See Also
 - [httpd](../httpd)
 - [relay](../relay)
 - [mail](../mail)
