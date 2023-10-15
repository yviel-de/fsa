# `mysql` - yviel's FSA v0.3.0

## Table of Contents
 - [Description](#description)
 - [Dependencies](#dependencies)
 - [Example Usage](#example-usage)
    - [Minimal Example](#minimal-example)
    - [With Non-root DB User](#with-non-root-db-user)
    - [Import from Local & Remote](#Import-from-local-and-remote)
 - [Reference](#reference)
 - [See Also](#see-also)

### Description
This role sets up a mysql or mariadb server and allows for import of databases.

### Works Against
- OpenBSD
- Alpine

### Dependencies
This role calls no other roles.

### Example Usage
#### Minimal Example
The role lives under the `apps` key:

```yaml
apps:
  mysql:
    # databases to set up
    dbs:
      - mydatabase
```

#### With Non-root DB User
```
apps:
  mysql:
    # databases to set up
    dbs:
      - mydatabase
    # users to set up
    users:
      - name: mysqluser
        # pass in cleartext
        pass: mysqlpass
        from: "%"
        # permit on this db
        ondb: mydatabase
```

#### Import from Local and Remote
```
apps:
  mysql:
    # define some databases
    dbs:
      - dbfoo
      - dbbar
    imports:
      # this is from a local file on the server
      - src: /tmp/dbfoo_dump.sql
        # existing db to import into
        dest: dbfoo
      # this is from a remote mysql server
      - src: remotedbbar
        host: 10.0.0.2
        user: remoteuser
        # in cleartext
        pass: remotepass
        # existing db to import into
        dest: dbbar
```

### Reference
|Key|Type|Required|Default|Summary|
|--|--|--|--|--|
|`apps.mysql`|Parent|No|(none)|Activates `mysql`|
|`apps.mysql.config`|Dict|No|(none)|Config values for my.cnf|
|`apps.mysql.config.section`|String|Yes|(none)|Section of the ini file|
|`apps.mysql.config.option`|String|Yes|(none)|Config key to set|
|`apps.mysql.config.value`|String|Yes|(none)|Config value to set|
|`apps.mysql.dbs`|List|Yes|(none)|Databases to set up|
|`apps.mysql.users`|Dict|No|(none)|Users to set up|
|`apps.mysql.users.name`|String|Yes|(none)|Username to create|
|`apps.mysql.users.pass`|String|Yes|(none)|Password in cleartext|
|`apps.mysql.users.from`|String|No|`localhost`|User origin|
|`apps.mysql.users.ondb`|String|Yes|(none)|Existing `db` to permit the user on|
|`apps.mysql.imports`|Dict|No|(none)|Any SQL imports to perform|
|`apps.mysql.imports.src`|String|Yes|(none)|Path to local file, or name of remote DB|
|`apps.mysql.imports.dest`|String|Yes|(none)|Name of existing `db` to import into|
|`apps.mysql.imports.host`|String|if remote `src`|(none)|Address of the remote MySQL host|
|`apps.mysql.imports.user`|String|if remote `src`|(none)|Remote SQL user to use|
|`apps.mysql.imports.pass`|String|if remote `src`|(none)|Password for the remote SQL user, in cleartext|

([Full Reference here](../../docs/REFERENCE.md))

### See Also
 - [net](../net)
 - [httpd](../httpd)
 - [php](../php)
