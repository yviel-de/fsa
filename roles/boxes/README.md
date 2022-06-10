# `boxes` - yviel's FSA v0.2.0
This role configures dovecot for user mailboxes. Authentication is hardcoded.

## Table of Contents
 - [Dependencies](#dependencies)
 - [Example Usage](#example-usage)
 - [Reference](#reference)
 - [See Also](#see-also)

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

([Full Reference here](docs/REFERENCE.md))

### Reference
|Key|Type|Required|Example Value|Default Value|Action|
|--|--|--|--|--|--|
|`mail.boxes.addr`|String|Yes|`user@example.com`|(none)|Mailbox to create|
|`mail.boxes.pass`|String|Yes|(long hash)|(none)|Password, use `fsa -g`|
