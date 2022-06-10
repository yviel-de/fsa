# `dkim` - yviel's FSA v0.2.0
This role configures DKIM signing for outgoing mails.

If the machine has rspamd (see: [filter](../filter)) it uses that. If not, it uses the smtpd-dkimsign filter. Be aware that the latter adds all your domains' public keys to the outgoing mails.

## Table of Contents
 - [Dependencies](#dependencies)
 - [Example Usage](#example-usage)
 - [Reference](#reference)
 - [See Also](#see-also)

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
|`mail.setup`|Bool|No|`true`|`false`|Whether to display the DKIM pubkeys|
|`mail.listen.dkim`|Bool|Yes|`true`|`false`|Whether to sign messages accepted through this interface|

([Full Reference here](docs/REFERENCE.md))

### See Also
 - [mail](../mail/)
 - [filter](../filter/)
