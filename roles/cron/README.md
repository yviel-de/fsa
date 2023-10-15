# `cron` - yviel's FSA v0.3.0

## Table of Contents
 - [Description](#description)
 - [Dependencies](#dependencies)
 - [Example Usage](#example-usage)
 - [Reference](#reference)
 - [See Also](#see-also)

### Description
This role sets up cron folders, files and entries for executing scheduled tasks.

### Dependencies
This role calls no other roles.

### Works Against
- OpenBSD
- Alpine

### Example Usage
The role lives under the `base` key:
```yaml
base:
  autoupdate: false
  cron:
    entries:
      - schedule: daily
        user: root
        command: "sh /path/to/script.sh"
      - schedule: monthly
        user: someuser
        command: "echo example"
    raw:
      - "MAILTO=hostmaster@example.com"
      - "0 0 * * * root echo example"
```

### Reference
|Key|Type|Required|Default Value|Action|
|--|--|--|--|--|--|
|`base.cron`|Parent|No|(none)|Activates `cron`|
|`base.cron.entries`|Dict|No|(none)|Generic cron entries to create|
|`base.cron.entries.schedule`|String|Yes|(none)|`daily`, `weekly`, or `monthly`|
|`base.cron.entries.user`|String|No|`root`|User to execute command as|
|`base.cron.entries.command`|String|Yes|(none|Command to execute|
|`base.cron.raw`|List|No|(none)|Any raw crontab lines to create|
|`base.autoupdate`|Bool|No|`false`|Sets up a daily system update cron|
([Full Reference here](../../docs/REFERENCE.md))

### See Also
 - [base](../base/)
