# `webdav` - yviel's FSA v0.2.0
This role sets up a baikal instance for CalDAV and CardDAV.

## Table of Contents
 - [Dependencies](#dependencies)
 - [Example Usage](#example-usage)
 - [Reference](#reference)
 - [See Also](#see-also)

### Dependencies
When called, it activates the following roles:
 - [httpd](../httpd)
 - [php](../php)

### Example Usage
The role lives under the `apps` key.

It requires a matching `web.sites` entry with enabled PHP.

Setup will need to be finalized manually via the WebUI.

```yaml
apps:
  webdav:
    # matching web.sites entry
    site: dav.mydomain.net
    # set up admin users
    admin:
      - user: myadminuser
        # cleartext
        pass: myadminpass
web:
  # enable httpd with the required php
  httpd: true
  php:
    version: 8.0
    libs:
      - pdo_sqlite
  # set up the site
  sites:
    - name: dav.mydomain.net
      root: /webdav
      php: true
```

### Reference
|Key|Type|Required|Default|Summary|
|--|--|--|--|--|
|`apps.webdav`|Parent|No|(none)|Activates `webdav`|
|`apps.webdav.site`|String|Yes|(none)|Matching `name` in `web.sites`|
|`apps.webdav.admin`|Dict|No|(none)|Admin users to set up|
|`apps.webdav.admin.user`|String|Yes|(none)|Admin username|
|`apps.webdav.admin.pass`|String|Yes|(none)|Password in cleartext for the user|

([Full Reference here](docs/REFERENCE.md))

### See Also
 - [httpd](../httpd)
 - [php](../php)
