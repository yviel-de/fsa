# `boxes` - yviel's FSA v0.3.0

## Table of Contents
 - [Description](#description)
 - [Dependencies](#dependencies)
 - [Example Usage](#example-usage)
 - [Reference](#reference)
 - [See Also](#see-also)

### Description
This role sets up mailboxes to use with email clients such as Thunderbird or K9-Mail.

They are made available via IMAP+STARTTLS on Port 587.

### Works Against
- OpenBSD

### Dependencies
When called, it activates the following roles:
 - [mail](../mail)

### Example Usage
The role lives under the `mail` key:
```yaml
mail:
  listen:
    - addr: all
  domains:
    - example.com
  boxes:
    - addr: user@example.com
      # use `fsa -g` to generate hashes
      pass: <crypted value>
    - addr: test@example.com
      pass: <crypted value>
```

([Full Reference here](../../docs/REFERENCE.md))

### Reference
|Key|Type|Required|Default Value|Action|
|--|--|--|--|--|--|
|`mail.boxes`|Dict|No|(none)|Mailboxes to set up|
|`mail.boxes.addr`|String|Yes|(none)|Email address to set up|
|`mail.boxes.pass`|String|Yes|(none)|Password hash, use `fsa -g` to generate|
