# `filter` - yviel's FSA v0.3.0

## Table of Contents
 - [Description](#description)
 - [Dependencies](#dependencies)
 - [Example Usage](#example-usage)
 - [Reference](#reference)
 - [See Also](#see-also)

### Description
This role sets up connection and spam filtering for [mail](../mail/).

### Works Against
- OpenBSD

### Dependencies
When called, it activates the following roles:
 - [mail](../mail)

### Example Usage
The role lives under the `mail` key:

```yaml
mail:
  listen:
    - addr: 10.0.0.1
      filter: false
```

### Reference
|Key|Type|Required|Default|Summary|
|--|--|--|--|--|
|`mail.listen.filter`|String|Yes|(none)|Filtering level: `none`, `conn`ection or full `spam`|

([Full Reference here](../../docs/REFERENCE.md))

### See Also
 - [mail](../mail/)
 - [dkim](../dkim/)
