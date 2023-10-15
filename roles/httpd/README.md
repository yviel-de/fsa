# `httpd` - yviel's FSA v0.3.0

## Table of Contents
 - [Description](#description)
 - [Dependencies](#dependencies)
 - [Example Usage](#example-usage)
    - [Simple Example](#simple-example)
    - [Aliases, SSL & Index](#aliases-ssl-and-custom-indexfile)
 - [Reference](#reference)
 - [See Also](#see-also)

### Description
This role sets up a basic webserver with virtual hosts.

### Works Against
- OpenBSD
- Alpine

### Dependencies
When called, it activates the following roles:
 - [tls](../tls)
 - [php](../php)

### Example Usage
#### Simple Example
```yaml
web:
  # enable the webserver
  httpd: true
  sites:
      # set up a vhost
    - name: example.com
      root: /myexampleroot
```

#### Aliases, SSL and custom Indexfile
```yaml
web:
  httpd: true
  sites:
    - name: example.com
      root: /myexampleroot
      alts:
        - www.example.com
        - web.example.com
      tls: prod
      index: myfile.html
```

### Reference
|Key|Type|Required|Default|Summary|
|--|--|--|--|--|
|`web.httpd`|Bool/Parent|No|`false`|Activates `httpd`|
|`web.httpd.auth`|Dict|No|(none)|Any `htpasswd` entries to set up|
|`web.httpd.auth.name`|String|Yes|(none)|Username to set up|
|`web.httpd.auth.pass`|String|Yes|(none)|Password for the user|
|`web.sites`|Dict|No|(none)|Virtual webhosts to set up|
|`web.sites.name`|String|Yes|(none)|Website's primary address|
|`web.sites.listen`|String|Yes|`all`|Address or interface to listen on|
|`web.sites.root`|String|Yes|(none)|Document-Root, relative to `/var/www`|
|`web.sites.port`|Int|No|default ones|Alternative port to listen on|
|`web.sites.alts`|List|No|(none)|Any alternative domain `name`s|
|`web.sites.tls`|String|No|`false`|Setup LetsEncrypt, `dev` or `prod`|
|`web.sites.index`|String|No|(none)|Default index page to serve|
|`web.sites.php`|Bool|No|`false`|Enable PHP for the vhost|

([Full Reference here](../../docs/REFERENCE.md))

### See Also
 - [relay](../relay)
 - [php](../php)
 - [net](../net)
