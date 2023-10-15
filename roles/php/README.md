# `php` - yviel's FSA v0.3.0

## Table of Contents
 - [Description](#description)
 - [Dependencies](#dependencies)
 - [Example Usage](#example-usage)
 - [Reference](#reference)
 - [See Also](#see-also)

### Description
This role sets up the PHP-FPM daemon and links it to the webserver.

### Works Against
- OpenBSD

### Dependencies
When called, it activates the following roles:
 - [httpd](../httpd)

### Example Usage
The role lives under the `web.httpd` key:

```yaml
web:
  # enable the webserver
  httpd: true
  php:
    # install this php version
    version: 8.4
    # and these additional libs
    libs:
      - zip
      - pdo_sqlite
  sites:
      # vhost address
    - name: php.example.com
      # docroot relative to /var/www
      root: /myphproot
      # enable php for this vhost
      php: true
```

### Reference
|Key|Type|Required|Default|Summary|
|--|--|--|--|--|
|`web.php`|Parent|No|(none)|Activates `php`|
|`web.php.version`|String|Yes|(none)|PHP version to install (`X.Y`)|
|`web.php.libs`|List|No|(none)|Any PHP libraries to install|

([Full Reference here](../../docs/REFERENCE.md))

### See Also
 - [httpd](../httpd)
