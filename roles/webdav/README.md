# `webdav` - yviel's FSA v0.3.0

## Table of Contents
 - [Description](#description)
 - [Dependencies](#dependencies)
 - [Example Usage](#example-usage)
 - [Reference](#reference)
 - [See Also](#see-also)

### Description
This role sets up [Radicale](https://radicale.org) CalDAV and CardDAV server for synchronization of contacts and calenders.

### Works Against
- OpenBSD

### Dependencies
When called, it activates the following roles:
 - [tls](../tls)

### Example Usage
The role lives under the `apps` key

```yaml
apps:
  webdav:
    host: 0.0.0.0
    port: 5555
    tls: prod
    domain: example.com
    users:
      - name: user1
        pass: user1
      - name: user2
        pass: pass2
```

### Reference
|Key|Type|Required|Default|Summary|
|--|--|--|--|--|
|`apps.webdav`|Parent|No|(none)|Activates `webdav`|
|`apps.webdav.host`|String|No|127.0.0.1|Address to listen on|
|`apps.webdav.port`|Int|No|5232|Port to listen on|
|`apps.webdav.users`|Dict|Yes|(none)|WebDAV users to create|
|`apps.webdav.users.name`|String|Yes|(none)|Username|
|`apps.webdav.users.pass`|String|Yes|(none)|Password (cleartext)|
|`apps.webdav.tls`|String|No|(none)|Signs with letsencrypt-staging (dev) or letsencrypt (prod)|
|`apps.webdav.domain`|String|if `tls` is defined|(none)|Domain name, required if you setup tls|
|`apps.webdav.fs_folder`|String|No|/var/db/radicale/collections|Folder for storing local collections|
