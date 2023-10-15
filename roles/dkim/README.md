# `dkim` - yviel's FSA v0.3.0

## Table of Contents
 - [Description](#description)
 - [Dependencies](#dependencies)
 - [Example Usage](#example-usage)
 - [Reference](#reference)
 - [See Also](#see-also)

### Description
This role sets up DKIM signing for outgoing mails. If the machine has spam filtering it will use `rspamd`, otherwise `smtpd-dkimsign` is used. Be aware that the latter will add all your domains' signatures to your outgoing mail.

*Note*: In order for DKIM to work properly their DNS records need to be created. They are output at the end of the run when `setup: true`.

### Works Against
- OpenBSD

### Dependencies
When called, it activates the following roles:
 - [mail](../mail)

### Example Usage
The role lives under a `mail.listen` key:
```yaml
mail:
  # output the DNS records to create
  setup: true
  # domains to set up dkim for
  domains:
    - example.com
  listen:
    - addr: 10.0.0.1
      # need to enable for the listener
      dkim: true
```

### Reference
|Key|Type|Required|Example Value|Default Value|Action|
|--|--|--|--|--|--|
|`mail.setup`|Bool|No|`false`|Whether to display the DKIM pubkeys and other DNS information|
|`mail.listen.dkim`|Bool|No|`false`|Sign submitted messages with DKIM|

([Full Reference here](../../docs/REFERENCE.md))

### See Also
 - [mail](../mail/)
 - [filter](../filter/)
