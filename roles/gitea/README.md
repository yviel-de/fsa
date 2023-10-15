# `gitea` - yviel's FSA v0.3.0

## Table of Contents
 - [Description](#description)
 - [Dependencies](#dependencies)
 - [Example Usage](#example-usage)
 - [Reference](#reference)
 - [See Also](#see-also)

### Description
This role sets up a gitea instance on localhost, intended to be used with a reverse proxy like [relay](../relay/).

*Note that the install must be finalized via a few manual steps in the GUI.*

### Works Against
- OpenBSD
- Alpine

### Dependencies
This role calls no other roles.

### Example Usage

The role lives under the `apps` key:

```yaml
apps:
  gitea:
    # installation name
    name: My Gitea Server
    # full url of the instal
    url: "https://my-gitea.com/"
    # unlocks the install screen
    install: true
    # your arbitrary values for the gitea.ini config file
    # here the necessary settings for a mysql backend (sqlite by default)
    # aswell as listen on public ip instead of localhost requiring reverse proxy
    config:
      # listen on public addr
      - section: server
        option: HTTP_ADDR
        value: 0.0.0.0
      # local mysql backend
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
|Key|Type|Required|Default|Summary|
|--|--|--|--|--|
|`apps.gitea`|Parent|No|(none)|Install Gitea|
|`apps.gitea.name`|String|No|My Beautiful Gitea|Name of the installation|
|`apps.gitea.url`|String|Yes|(none)|Full URL including protocol of the install|
|`apps.gitea.install`|String|No|`false`|Unlocks the install screen|
|`apps.gitea.config`|Dict|No|(none)|Any config keys to set|
|`apps.gitea.config.section`|String|Yes|(none)|Section of the INI file|
|`apps.gitea.config.option`|String|Yes|(none)|Name of the setting|
|`apps.gitea.config.value`|String|Yes|(none)|Value of the setting|

([Full Reference here](../../docs/REFERENCE.md))

### See Also
 - [relay](../relay)
