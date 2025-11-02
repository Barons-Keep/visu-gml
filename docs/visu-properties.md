# `visu-properties.json` Documentation

This file defines configuration options for `visu-project.exe`.  
All properties are optional — if a property is missing, the application falls back to its internal defaults.

---

## `visu.sfx`
**Type:** `Map<String, String | null>`

Defines a mapping of sound effect identifiers to audio file paths.

- All audio files **must be in `.ogg` format**.
- Paths are **relative to the directory** of `visu-project.exe`.
- Values can be either a relative path to a `.ogg` file or `null`.
- Sound effects can be reloaded dynamically at runtime via  
  **File → Reload SFX** or shortcut **`CTRL + R`**.  
  This allows replacing `.ogg` files without modifying `visu-properties.json`.

**Example:**
```json
"visu.sfx": {
  "sound_sfx_intro": "sfx/sound_sfx_intro.ogg",
  "sound_sfx_menu_move_cursor": "sfx/sound_sfx_menu_move_cursor.ogg",
  "sound_sfx_menu_select_entry": "sfx/sound_sfx_menu_select_entry.ogg",
  "sound_sfx_menu_use_entry": "sfx/sound_sfx_menu_use_entry.ogg",
  "sound_sfx_player_collect_bomb": "sfx/sound_sfx_player_collect_bomb.ogg",
  "sound_sfx_player_collect_life": "sfx/sound_sfx_player_collect_life.ogg",
  "sound_sfx_player_collect_point_or_force": "sfx/sound_sfx_player_collect_point_or_force.ogg",
  "sound_sfx_player_die": "sfx/sound_sfx_player_die.ogg",
  "sound_sfx_player_force_level_up": "sfx/sound_sfx_player_force_level_up.ogg",
  "sound_sfx_player_shoot": "sfx/sound_sfx_player_shoot.ogg",
  "sound_sfx_player_use_bomb": "sfx/sound_sfx_player_use_bomb.ogg",
  "sound_sfx_shroom_damage": "sfx/sound_sfx_shroom_damage.ogg",
  "sound_sfx_shroom_die": "sfx/sound_sfx_shroom_die.ogg",
  "sound_sfx_shroom_shoot": "sfx/sound_sfx_shroom_shoot.ogg"
}
````

---

## `visu.manifest.path`

**Type:** `String | null`

Relative path to the `manifest.visu` file that should be loaded on application start.

---

## `visu.manifest.load-on-start`

**Type:** `Boolean`

If `true`, the file specified in `visu.manifest.path` is automatically loaded at startup.

---

## `visu.manifest.play-on-start`

**Type:** `Boolean`

If both this option and `visu.manifest.load-on-start` are `true`,
the loaded manifest will immediately enter *play mode*.

---

## `visu.skip-splashscreen`

**Type:** `Boolean`

If `true`, skips the splash screen on application start.

---

## `visu.menu.open-on-start`

**Type:** `Boolean`

If `true`, opens the main menu right after startup (or after splash screen if enabled).

---

## `visu.player.force-god-mode`

**Type:** `Boolean`

If `true`, automatically enables:

> `Settings → Developer → God Mode: Enabled`

Used for testing and debugging.

---

## `visu.manifest.load-brushes`

**Type:** `Boolean`

If `true`, editor brushes defined inside `manifest.visu` (field `editor: String[]`) will be loaded.

---

## `visu.manifest.parse-track-async`

**Type:** `Boolean`

If `true`, `track.json` will be parsed incrementally over multiple frames (non-blocking load).

---

## `visu.manifest.parse-track-event-step`

**Type:** `Integer`

Defines how many `TrackEvent` items are parsed per frame when loading `track.json`.

---

## `visu.io.mouse-moved.cooldown`

**Type:** `Integer` (pixels)

Defines the minimum cursor movement distance required to trigger a `MouseDrag`.

---

## `visu.files-service.dispatcher.limit`

**Type:** `Integer`

Maximum number of file operations that the `FileService` is allowed to perform per frame.

---

## `visu.player.force.tresholds`

**Type:** `Integer[]`

Defines thresholds of the player **Force** stat that trigger leveling up.

**Example:**

```
[0, 50, 125, 250]
```

---

## `visu.player.point.tresholds`

**Type:** `Integer[]`

Defines thresholds of the player **Point** stat that trigger leveling up.

---

## `visu.version.check`

**Type:** `Boolean`

If `true`, the application performs an HTTP GET request to the URL specified in `visu.version.url` to check for the latest version.

---

## `visu.version.url`

**Type:** `String | null`

URL pointing to a JSON file containing the newest available version number.

**Example formatting of expected JSON:**

```json
{
  "model": "io.alkapivo.core.util.VersionConfig",
  "version": 1,
  "data": {
    "current": {
      "Windows": {
        "version": "25.10.26"
      }
    }
  }
}
```

---

## `visu.server.port`

**Type:** `String | null`

Defines the port on which the server socket will be created.

---

## `visu.server.maxClients`

**Type:** `Integer | null`

Maximum number of simultaneous socket connections.

---

### Performance-related constants (`visu.const.*`)

These constants control how much work the engine performs per frame during loading.

| Property                              | Type     | Description |                                                                                               |
| ------------------------------------- | -------- | ----------- | --------------------------------------------------------------------------------------------- |
| `visu.const.MAGIC_NUMBER_TASK`        | `Integer | null`       | Maximum number of general tasks that can be executed per frame while loading `manifest.visu`. |
| `visu.const.SYNC_UI_STORE_STEP`       | `Integer | null`       | Maximum number of `subscribe` operations in UIStore allowed per frame.                        |
| `visu.const.BRUSH_ENTRY_STEP`         | `Integer | null`       | Number of `brush-entry` items loaded per frame.                                               |
| `visu.const.BRUSH_TOOLBAR_ENTRY_STEP` | `Integer | null`       | Number of toolbar UI component entries loaded per frame for the active brush.                 |
| `visu.const.FLIP_VALUE`               | `Integer | null`       | Frame delay after loading a component (`event`, `template`, or `brush`).                      |

---

## End marker

### `end-property`

**Type:** always `null`

Marks the end of the JSON file.
