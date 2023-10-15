# `mpd` - yviel's FSA v0.3.0

## Table of Contents
 - [Description](#description)
 - [Dependencies](#dependencies)
 - [Example Usage](#example-usage)
 - [Reference](#reference)
 - [See Also](#see-also)

### Description
This role sets up a Music Player Daemon with optional radio stations and alarm clock feature.

### Works Against
- OpenBSD

### Dependencies
This role calls no other roles.

### Example Usage

The role lives under the `apps` key:

```yaml
apps:
  mpd:
    # default listen on all
    listen: any
    # port to listen on
    port: 6600
    # this is the default location
    storage: /var/lib/mpd/music
    # setup chosen webradios from somafm and others
    webradio: true
    # setup any extra sources
    sources:
        # name to save under
      - name: groovesalad
        # webradio playlist file
        source: https://somafm.com/groovesalad.pls
      - name: jungletrain
        source: https://jungletrain.net/128kbps.pls
```

### Reference
|Key|Type|Required|Default|Summary|
|--|--|--|--|--|--|
|`apps.mpd`|Parent|No|(none)|Sets up MPD|
|`apps.mpd.listen`|String|No|`any`|Listen address|
|`apps.mpd.port`|String|No|`6600`|Listen port|
|`apps.mpd.storage`|String|No|`/var/lib/mpd/music`|Path to store music|
|`apps.mpd.webradio`|Bool|No|`false`|Setup chosen webradios from somafm and others|
|`apps.mpd.sources`|Dict|No|(none)|Playlist files to download|
|`apps.mpd.sources.name`|Bool|Yes|(none)|Name to save it under|
|`apps.mpd.sources.source`|Bool|Yes|(none)|Web location of `.pls` file|

([Full Reference here](../../docs/REFERENCE.md))

### See Also
