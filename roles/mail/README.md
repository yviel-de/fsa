# `mail` - yviel's FSA v0.3.0

## Table of Contents
 - [Description](#description)
 - [Dependencies](#dependencies)
 - [Example Usage](#example-usage)
    - [Minimal Example](#minimal-example)
    - [Relay Host](#relayhost)
    - [Full Mail Server](#full-mail-server)
 - [Reference](#reference)
 - [See Also](#see-also)

### Description
This role sets up a mail server for forwarding and/or more advanced purposes.

### Works Against
- OpenBSD

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
|`mail.setup`|Bool|No|`false`|Whether to display the DKIM pubkeys and other DNS information|
|`mail.listen`|Dict|Yes|(none)|Listeners to set up|
|`mail.listen.addr`|String|Yes|(none)|Addresses to listen on|
|`mail.listen.port`|Int|Yes|(none)|Port to listen on|
|`mail.listen.filter`|String|Yes|(none)|Filtering level: `none`, `conn`ection or full `spam`|
|`mail.listen.tls`|String|No|`false`|Sets up LetsEncrypt, `dev` or `prod`|
|`mail.listen.auth`|Bool|No|`false`|Require authentication|
|`mail.listen.dkim`|Bool|No|`false`|Sign submitted messages with DKIM|
|`mail.listen.whitelist`|Bool|No|`false`|Apply `mail.whitelist` to this listener|
|`mail.domains`|List|Yes|(none)|Domains to accept mail for|
|`mail.users`|Dict|No|(none)|Sender-only users to set up|
|`mail.users.name`|String|Yes|(none)|Username to set up|
|`mail.users.pass`|String|Yes|(none)|Password hash, use `fsa -g`|
|`mail.boxes`|Dict|No|(none)|Mailboxes to set up|
|`mail.boxes.addr`|String|Yes|(none)|Email address to set up|
|`mail.boxes.pass`|String|Yes|(none)|Password hash, use `fsa -g` to generate|
|`mail.virtuals`|List|No|(none)|Aliases, distribution lists, etc to set up|
|`mail.whitelist`|List|No|(none)|IP addresses or CIDRs to forward mail for|
|`mail.relay`|String|No|(none)|Hostname of the server all incoming mail will be relayed to|

([Full Reference here](../../docs/REFERENCE.md))

### See Also
 - [boxes](../boxes/)
 - [filter](../filter/)
 - [dkim](../dkim/)
