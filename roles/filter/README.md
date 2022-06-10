# `filter` - yviel's FSA v0.2.0
This role sets up connection and spam filtering for mail.

## Table of Contents
 - [Dependencies](#dependencies)
 - [Example Usage](#example-usage)
 - [Reference](#reference)
 - [See Also](#see-also)

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
|`mail.listen.filter`|String|Yes|(none)|Filtering, `none`, `conn`ection-level or full `spam`|

([Full Reference here](docs/REFERENCE.md))

### See Also
 - [mail](../mail/)
 - [dkim](../dkim/)
