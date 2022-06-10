# `cron` - yviel's FSA v0.2.0
This role handles `/etc/crontab` files and entries.

## Table of Contents
 - [Dependencies](#dependencies)
 - [Example Usage](#example-usage)
 - [Reference](#reference)
 - [See Also](#see-also)

### Dependencies
This role calls no other roles.

### Example Usage
The role lives under the `base` key:
```yaml
base:
  autoupdate: false
  cron:
    - "MAILTO=hostmaster@example.com"
    - "0 0 * * * someuser echo example"
```

### Reference
|Key|Type|Required|Example Value|Default Value|Action|
|--|--|--|--|--|--|
|`base.cron`|List|No|`- "0 0 * * * someuser echo example"`<br/>`- "MAILTO=hostmaster@example.com`|(none)|Your lines are inserted into /etc/crontab as they are|
|`base.autoupdate`|Bool|No|`true`|`false`|Sets up a daily system update cron|

([Full Reference here](docs/REFERENCE.md))

### See Also
 - [base](../base/)
