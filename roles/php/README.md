# `php` - yviel's FSA v0.2.0
This role sets up PHP-FPM and links it with the webserver.

## Table of Contents
 - [Dependencies](#dependencies)
 - [Example Usage](#example-usage)
 - [Reference](#reference)
 - [See Also](#see-also)

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
|`web.httpd.php`|Parent|No|(none)|Activates `php`|
|`web.httpd.php.version`|String|Yes|(none)|PHP version to install (`X.Y`)|
|`web.httpd.php.libs`|List|No|(none)|Any PHP libraries to install|

([Full Reference here](docs/REFERENCE.md))

### See Also
 - [httpd](../httpd)
