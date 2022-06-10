# `mail` - yviel's FSA v0.2.0
This role sets up an smtpd mail server.

## Table of Contents
 - [Dependencies](#dependencies)
 - [Example Usage](#example-usage)
    - [Minimal Example](#minimal-example)
    - [Relay Host](#relayhost)
    - [Full Mail Server](#full-mail-server)
 - [Reference](#reference)
 - [See Also](#see-also)

### Dependencies
When called, it activates the following roles:
 - [tls](../tls)

### Example Usage
#### Minimal Example
```yaml
mail:
  listen:
    - addr: all
      # addr & port to listen on
      port: 25
      # do connection-level filtering eg PTR check etc
      filter: conn
  # domains to accept mail for
  domains:
    - example.com
```

#### Relay Host
```yaml
mail:
  listen:
    - addr: all
      port: 25
      # we set up TLS and deny anyone not using it
      tls: force
      # we require authentication
      auth: true
      # dkim-sign messages accepted through here
      dkim: true
  users:
    - name: myrelayuser
      pass: $2b$08$tH5DkCLGPT2mProHcPR9KeseVgnN2L/oD83vpVUMkMMTrRaE0HPVO
```

#### Full Mail Server
```yaml
mail:
  listen:
      # one listener for receiving mail from servers
    - addr: all
      # this is auto-recognized as 25
      port: smtp
      # we want spam filtering
      filter: spam
      # and SSL
      tls: true
      # one listener for receiving mail from clients
    - addr: all
      # auto-mapped to 587
      port: submission
      # we want to force TLS
      tls: force
      # senders need to be authed
      auth: true
      # and we want to sign outgoing messages
      dkim: true
  # domains to accept mail for
  domains:
    - example.com
  # user mailboxes to set up
  boxes:
    - addr: myuser@example.com
      # use `fsa -g` to generate password hashes
      pass: $2b$08$tH5DkCLGPT2mProHcPR9KeseVgnN2L/oD83vpVUMkMMTrRaE0HPVO
```

### Reference
|Key|Type|Required|Default|Summary|
|--|--|--|--|--|
|`mail`|Parent|No|(none)|Activates `mail`|
|`mail.listen`|Dict|Yes|(none)|Listeners to set up|
|`mail.listen.addr`|String|Yes|(none)|Addresses to listen on|
|`mail.listen.port`|Int|Yes|(none)|Port to listen on|
|`mail.listen.filter`|String|Yes|(none)|Filtering, see [filter](../filter)|
|`mail.listen.tls`|String|No|`false`|Sets up LetsEncrypt, `dev` or `prod`|
|`mail.listen.auth`|Bool|No|`false`|Require authentication|
|`mail.listen.dkim`|Bool|No|`false`|DKIM-signing, see [dkim](../dkim)|
|`mail.listen.whitelist`|Bool|No|`false`|Whether to apply `mail.whitelist`|
|`mail.domains`|List|Yes|(none)|Domains to accept mail for|
|`mail.users`|Dict|No|(none)|Sender-only users to set up|
|`mail.users.name`|String|Yes|(none)|Username to set up|
|`mail.users.pass`|String|Yes|(none)|Password hash, use `fsa -g`|
|`mail.boxes`|Dict|No|(none)|Sets up mailboxes, see [boxes](../../roles/boxes)|
|`mail.boxes.name`|String|Yes|(none)|Username to set up|
|`mail.boxes.pass`|String|Yes|(none)|Password hash, use `fsa -g`|
|`mail.virtuals`|List|No|(none)|Aliases, distribution lists, etc to set up|
|`mail.whitelist`|List|No|(none)|IP addresses or CIDRs to allow|

([Full Reference here](docs/REFERENCE.md))

### See Also
 - [boxes](../boxes/)
 - [filter](../filter/)
 - [dkim](../dkim/)
