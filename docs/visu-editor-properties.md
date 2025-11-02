# `visu-editor-properties.json` Documentation

This file configures editor-specific behavior for `visu-project.exe`.  
All fields are optional — if not present, built-in defaults are used.

---

## Core editor behavior

### `visu.editor.force-init`
**Type:** `Boolean`

If `true`, forces the editor to be enabled automatically:

> `Settings → Developer → Editor: Enable`

---

### `visu.editor.force-render`
**Type:** `Boolean`

If `true`, forces `renderUI = true` in `VisuEditorController`, regardless of editor settings.

---

### `visu.editor.renderEditorMode`
**Type:** `Boolean`

If `true`, displays text `"SHOW EDITOR [F5]"` in the bottom-right corner  
(when the editor is enabled via Developer Settings).

---

### `visu.editor.controlTrack.alwaysEnabled`
**Type:** `Boolean`

If `true`, the following shortcuts always control track playback,  
even when the editor UI is not focused:

| Shortcut | Action |
|----------|--------|
| `SPACE`  | Play / Pause the track |
| `CTRL + ,` | Step backward |
| `CTRL + .` | Step forward |

---

### `visu.editor.status-bar.render-real-fps`
**Type:** `Boolean`

If `true`, the FPS counter in the editor status bar shows uncapped FPS values  
(instead of limiting display to 60).

---

### `visu.editor.edit-theme`
**Type:** `Boolean`

If `true`, the editor exposes a built-in color theme editor (`Edit Level` → color editing tools).

---

## UI component enabling

### `visu.editor.ui.components.numeric-button`
**Type:** `Boolean`

If `true`, numeric fields show **Increase/Decrease** buttons.

---

### `visu.editor.ui.components.numeric-stick`
**Type:** `Boolean`

If `true`, numeric fields include a drag control ("stick") for adjusting numerical values.

---

## Inspector initialization (`updateArea`)

These settings determine whether `updateArea()` is called during initialization of UI inspector components.

| Property | Type | Description |
|----------|------|-------------|
| `visu.editor.ui.brush-toolbar.inspector-view.init-ui-contanier.updateArea` | `Boolean` | Calls `updateArea()` when initializing the **brush inspector**. |
| `visu.editor.ui.template-toolbar.inspector-view.init-ui-contanier.updateArea` | `Boolean` | Calls `updateArea()` when initializing the **template inspector**. |
| `visu.editor.ui.event-inspector.inspector-view.init-ui-contanier.updateArea` | `Boolean` | Calls `updateArea()` when initializing the **event inspector**. |

---

## Autosave

### `visu.editor.autosave.interval`
**Type:** `Number`

Defines how often autosave is executed (in minutes), *if autosave is enabled*.

---

## UI Update Timers (refresh intervals)

These properties define how often specific UI areas are refreshed.

> Value is in **seconds** (floating-point supported).

| Property | Type | Component updated |
|----------|------|------------------|
| `visu.editor.ui.brush-toolbar.brush-view.updateTimer` | `Number` | Brush Toolbar → Brush View |
| `visu.editor.ui.brush-toolbar.inspector-view.updateTimer` | `Number` | Brush Toolbar → Inspector View |
| `visu.editor.ui.event-inspector.properties.updateTimer` | `Number` | Event Inspector |
| `visu.editor.ui.template-toolbar.inspector-view.updateTimer` | `Number` | Template Inspector → Inspector View |
| `visu.editor.ui.template-toolbar.template-view.updateTimer` | `Number` | Template Inspector → Template View |
| `visu.editor.ui.timeline.channels.updateTimer` | `Number` | Timeline → Channels |
| `visu.editor.ui.timeline.timeline-events.updateTimer` | `Number` | Timeline → Timeline Events |
| `visu.editor.ui.timeline.background.updateTimer` | `Number` | Timeline → Background |
| `visu.editor.ui.sceneConfigPreview.updateTimer` | `Number` | Scene Configuration Preview |
| `visu.editor.ui.accordion.items.updateTimer` | `Number` | Accordion |
| `visu.editor.ui.brush-toolbar.accordion.updateTimer` | `Number` | Brush Toolbar Accordion |
| `visu.editor.ui.brush-toolbar.inspector-bar.updateTimer` | `Number` | Brush Toolbar → Inspector Bar |

---

## UI Cooldowns

Cooldown = minimum delay before the next refresh can occur.

> Value is in **seconds**.

| Property | Type | Component |
|----------|------|----------|
| `visu.editor.ui.timeline.background.updateTimer.cooldown` | `Number` | Timeline → Background |
| `visu.editor.ui.event-inspector.title.updateTimer.cooldown` | `Number` | Event Inspector → Title |
| `visu.editor.ui.event-inspector.inspector-bar.updateTimer.cooldown` | `Number` | Event Inspector → Inspector Bar |
| `visu.editor.ui.brush-toolbar.accordion.updateTimer.cooldown` | `Number` | Brush Toolbar Accordion |
| `visu.editor.ui.brush-toolbar.inspector-bar.updateTimer.cooldown` | `Number` | Brush Toolbar → Inspector Bar |
| `visu.editor.ui.brush-toolbar.inspector-view.init-ui-contanier.cooldown` | `Number` | Brush Inspector initialization |
| `visu.editor.ui.template-toolbar.inspector-view.init-ui-contanier.cooldown` | `Number` | Template Inspector initialization |
| `visu.editor.ui.event-inspector.inspector-view.init-ui-contanier.cooldown` | `Number` | Event Inspector initialization |

---

## Mouse Interaction

### `visu.editor.io.mouse-moved.cooldown`
**Type:** `Integer` (pixels)

Defines the mouse movement distance required to trigger a `MouseDrag` action.

---

## End marker

### `end-property`
**Type:** always `null`

Indicates the end of the JSON file.
