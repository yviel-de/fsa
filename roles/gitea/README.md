# `gitea` - yviel's FSA v0.2.0
This role sets up a gitea instance. It opens a HTTP listener on port 8080.

## Table of Contents
 - [Dependencies](#dependencies)
 - [Example Usage](#example-usage)
 - [Reference](#reference)
 - [See Also](#see-also)

### Dependencies
This role calls no other roles.

### Example Usage

The role lives under the `apps` key:

```yaml
apps:
  gitea:
    # installation name
    name: My Gitea Server
    # your arbitrary values for the gitea.ini config file
    # here the necessary settings for a mysql backend (default sqlite)
    config:
      - section: database
        option: DB_TYPE
        value: mysql
      - section: database
        option: HOST
        value: /var/run/mysqld/mysqld.sock
      - section: database
        option: NAME
        value: mygiteadb
      - section: database
        option: USER
        value: mydbuser
      - section: database
        option: PASSWD
        value: mydbuserpass
```

### Reference
|`apps.gitea`|Parent|No|(none)|Activates `gitea`|
|`apps.gitea.name`|String|No|My Beautiful Gitea|Name of the installation|
|`apps.gitea.config`|Dict|No|(none)|Any config keys to set|
|`apps.gitea.config.section`|String|Yes|(none)|Section of the INI file|
|`apps.gitea.config.option`|String|Yes|(none)|Name of the setting|
|`apps.gitea.config.value`|String|Yes|(none)|Value of the setting|

([Full Reference here](docs/REFERENCE.md))

### See Also
 - [relay](../relay)
