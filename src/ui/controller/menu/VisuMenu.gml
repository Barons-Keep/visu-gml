///@package fun.barons-keep.visu.ui.controller

///@type {String}
#macro VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT " ON "


///@type {String}
#macro VISU_MENU_BUTTON_INPUT_ENTRY_FALSE_TEXT " OFF"


///@type {String}
#macro EMPTY_STRING ""


///@enum
function _VisuMenuEntryEventType(): Enum() constructor {
  OPEN_NODE = "open-node"
  OPEN_TRACK_SETUP = "open-track-setup"
  LOAD_TRACK = "load-track"
}
global.__VisuMenuEntryEventType = new _VisuMenuEntryEventType()
#macro VisuMenuEntryEventType global.__VisuMenuEntryEventType


///@param {String} sfxName
function playCleanSFX(sfxName) {
  var controller = Beans.get(BeanVisuController)
  if (controller == null) {
    return
  }

  var sfx = controller.sfxService.get(sfxName)
  if (sfx == null) {
    return
  }

  var size = sfx.queue.size()
  if (size == 0) {
    sfx.play()
    return
  }

  var sound = sfx.queue.tail().sound
  if (sound == null) {
    return
  }

  if (sound.getPosition() / sound.getDuration() > 0.5) {
    sfx.play()
  }
}


///@return {Callable}
function factoryPostRenderVisuMenuSliderEntry() {
  return function() {
    var label = Struct.get(this, "label")
    if (label == null) {
      label = new UILabel({
        text: $"{string(int64(this.value))}",
        align: { v: VAlign.CENTER, h: HAlign.CENTER },
        font: "font_kodeo_mono_18_bold",
        color: VisuTheme.color.text,
        outline: true,
        outlineColor: VisuTheme.color.side,
        useScale: false,
      })
      Struct.set(this, "label", label)
    }
    
    label.text = $"{string(int64(this.value))}"
    label.render(
      this.context.area.getX() + this.area.getX() + (this.area.getWidth() / 2.0),
      this.context.area.getY() + this.area.getY() + (this.area.getHeight() / 2.0)
    )
  }
}


///@return {Callable}
function factoryPostRenderVisuMenuSliderEntryPercentage() {
  return function() {
    var label = Struct.get(this, "label")
    if (label == null) {
      label = new UILabel({
        text: $"{string(int64(this.value))}%",
        align: { v: VAlign.CENTER, h: HAlign.CENTER },
        font: "font_kodeo_mono_18_bold",
        color: VisuTheme.color.text,
        outline: true,
        outlineColor: VisuTheme.color.side,
        useScale: false,
      })
      Struct.set(this, "label", label)
    }
    
    label.text = $"{string(int64(this.value))}%"
    label.render(
      this.context.area.getX() + this.area.getX() + (this.area.getWidth() / 2.0),
      this.context.area.getY() + this.area.getY() + (this.area.getHeight() / 2.0)
    )
  }
}


///@param {String} name
///@param {String} text
///@return {Struct}
function factoryPlayerKeyboardKeyEntryConfig(name, text) {
  return {
    layout: { type: UILayoutType.VERTICAL },
    label: { 
      key: name,
      text: text,
      keyboardLabel: Language.get("visu.menu.controls.keyboard"),
      mouseLabel: Language.get("visu.menu.controls.mouse"),
      updateCustom: function() {

        var lastKey = keyboard_lastkey
        var lastMouseButton = mouse_wheel_up()
          ? MouseButtonType.WHEEL_UP
          : (mouse_wheel_down()
            ? MouseButtonType.WHEEL_DOWN
            : mouse_button)

        var lastEventType = (lastKey != vk_nokey ? this.keyboardLabel : (lastMouseButton != mb_none ? this.mouseLabel : null))
        if (lastEventType == null) {
          return
        }

        var controller = Beans.get(BeanVisuController)
        var visuIO = Beans.get(BeanVisuIO)
        switch (lastEventType) {
          case "keyboard":
            if (this.context.state.get("remapKey") != this.key 
                || lastKey == KeyboardKeyType.ESC 
                || lastKey == KeyboardKeyType.ENTER) {
              return
            }

            var keyboard = visuIO.keyboards.get("player")
            keyboard.setKey(this.key, lastKey)
            keyboard_lastkey = vk_nokey
            Logger.debug("VisuMenu", $"Remap key {this.key} to {lastKey}")
            Visu.settings.setValue("visu.keyboard.player.up", Struct.get(keyboard.keys, "up").gmKey)
            Visu.settings.setValue("visu.keyboard.player.down", Struct.get(keyboard.keys, "down").gmKey)
            Visu.settings.setValue("visu.keyboard.player.left", Struct.get(keyboard.keys, "left").gmKey)
            Visu.settings.setValue("visu.keyboard.player.right", Struct.get(keyboard.keys, "right").gmKey)
            Visu.settings.setValue("visu.keyboard.player.action", Struct.get(keyboard.keys, "action").gmKey)
            Visu.settings.setValue("visu.keyboard.player.bomb", Struct.get(keyboard.keys, "bomb").gmKey)
            Visu.settings.setValue("visu.keyboard.player.focus", Struct.get(keyboard.keys, "focus").gmKey)
            Visu.settings.save()
            this.context.state.set("remapKey", null)
            break
          case "mouse":
            if (this.context.state.get("remapKey") != this.key
                || (lastMouseButton == MouseButtonType.WHEEL_UP || lastMouseButton == MouseButtonType.WHEEL_DOWN
                    ? !lastMouseButton()
                    : !mouse_check_button_pressed(lastMouseButton))) {
              return
            }

            var mouse = visuIO.mouses.get("player")
            mouse.setButton(this.key, mouse.getButton(this.key).type == lastMouseButton ? MouseButtonType.NONE : lastMouseButton)
            Logger.debug("VisuMenu", $"Remap mouseButton {this.key} to {lastMouseButton}")
            Visu.settings.setValue("visu.mouse.player.up", Struct.get(mouse.buttons, "up").type)
            Visu.settings.setValue("visu.mouse.player.down", Struct.get(mouse.buttons, "down").type)
            Visu.settings.setValue("visu.mouse.player.left", Struct.get(mouse.buttons, "left").type)
            Visu.settings.setValue("visu.mouse.player.right", Struct.get(mouse.buttons, "right").type)
            Visu.settings.setValue("visu.mouse.player.action", Struct.get(mouse.buttons, "action").type)
            Visu.settings.setValue("visu.mouse.player.bomb", Struct.get(mouse.buttons, "bomb").type)
            Visu.settings.setValue("visu.mouse.player.focus", Struct.get(mouse.buttons, "focus").type)
            Visu.settings.save()
            this.context.state.set("remapKey", null)

            if (lastMouseButton == MouseButtonType.LEFT) {
              this.context.state.set("remapMouseButton", this.key)
            }
            break
        }
      },
      callback: new BindIntent(function() {
        if (this.context.state.get("remapKey") == this.key) {
          return
        }

        keyboard_lastkey = vk_nokey
        this.context.state.set("remapKey", this.key)
      }),
      onMouseReleasedLeft: function() {
        if (this.context.state.get("remapKey") == this.key) {
          return
        }

        if (this.context.state.get("remapMouseButton") == this.key) {
          this.context.state.set("remapMouseButton", null)
          return
        }

        keyboard_lastkey = vk_nokey
        this.context.state.set("remapKey", this.key)
      },
    },
    preview: {
      key: name,
      text: EMPTY_STRING,
      updateCustom: function() {
        var visuIO = Beans.get(BeanVisuIO)
        var remapKeyEvent = this.context.state.get("remapKey") == this.key
        var keyCode = Struct.get(visuIO.keyboards.get("player").keys, this.key).gmKey
        var keyboardText = ""
        if (KeyboardKeyType.contains(keyCode)) {
          keyboardText = KeyboardKeyType.findKey(keyCode)
        } else if (KeyboardSpecialKeys.contains(keyCode)) {
          keyboardText = KeyboardSpecialKeys.get(keyCode)
        } else {
          keyboardText = chr(keyCode)
        }

        var mouseCode = Struct.get(visuIO.mouses.get("player").buttons, this.key).type
        var mouseText = $"{MouseButtonType.findKey(mouseCode)}"

        if (remapKeyEvent) {
          keyboardText = $"Key: [ {keyboardText} ]"
          mouseText = $" | Mouse: [ {mouseText} ]"
        } else {
          keyboardText = $"Key: {keyboardText}"
          mouseText = mouseCode == MouseButtonType.NONE ? "" : $" | Mouse: {mouseText}"
        }

        //mouseText = Visu.settings.getValue("visu.developer.mouse-shoot") ? mouseText : ""
        this.label.text = $"{keyboardText}{mouseText}"
      },
      remapKeyTimer: new Timer(TAU, { loop: Infinity }),
      preRender: function() {
        Struct.set(this, "previousBackgroundAlpha", this.backgroundAlpha)
        if (this.context.state.get("remapKey") != this.key) {
          this.remapKeyTimer.reset()
          return
        }

        var frequency = 16.0
        var boost = 1.4
        var time = this.remapKeyTimer.update().time
        this.backgroundAlpha = Struct.get(this, "previousBackgroundAlpha")
          * ((cos(frequency * time) + boost) / (boost + 1.0))
      },
      postRender: function() {
        this.backgroundAlpha = Struct.getIfType(this, "previousBackgroundAlpha", 
          Number, this.backgroundAlpha)
      },
      callback: new BindIntent(function() {
        if (this.context.state.get("remapKey") == this.key) {
          return
        }

        keyboard_lastkey = vk_nokey
        this.context.state.set("remapKey", this.key)
      }),
      onMouseReleasedLeft: function() {
        if (this.context.state.get("remapKey") == this.key) {
          return
        }

        if (this.context.state.get("remapMouseButton") == this.key) {
          this.context.state.set("remapMouseButton", null)
          return
        }

        keyboard_lastkey = vk_nokey
        this.context.state.set("remapKey", this.key)
      },
    },
  }
}


///@param {String} name
///@param {String} text
///@return {Struct}
function factoryPlayerGamepadButtonEntryConfig(name, text) {
  return { 
    layout: { type: UILayoutType.VERTICAL },
    label: {
      key: name,
      text: text,
    },
    previous: {
      key: name,
      callback: function() {
        var controller = Beans.get(BeanVisuController)
        var config = Visu.settings.getValue("visu.gamepad.controls")
        var map = new Map(String, Number)
          .set(VisuGamepadButtonActions.NONE, 0)
          .set(VisuGamepadButtonActions.UP, 1)
          .set(VisuGamepadButtonActions.DOWN, 2)
          .set(VisuGamepadButtonActions.LEFT, 3)
          .set(VisuGamepadButtonActions.RIGHT, 4)
          .set(VisuGamepadButtonActions.ACTION, 5)
          .set(VisuGamepadButtonActions.FOCUS, 6)
          .set(VisuGamepadButtonActions.BOMB, 7)
        var pointer = map.getDefault(Struct.get(config, this.key), 0)
        var target = int64(pointer - 1)
        target = target < 0 ? 7 : (target > 7 ? 0 : target)
        var value = map.findKey(Lambda.equal, target)
        if (!Optional.is(value)) {
          return
        }

        Struct.set(config, this.key, value)
        Visu.settings.setValue("visu.gamepad.controls", config).save()
        Visu.initInputCandyLoader(controller.layerId)
        controller.sfxService.play("menu-use-entry")
      },
    },
    preview: {
      key: name,
      label: {
        key: name,
        text: "None",
      },
      updateCustom: function() { 
        var action = String.toLowerCase(Struct.get(Visu.settings.getValue("visu.gamepad.controls"), this.key)),
        this.label.text = Language.get($"visu.menu.gamepad.action.{action}")
      },
    },
    next: {
      key: name,
      callback: function() {
        var controller = Beans.get(BeanVisuController)
        var config = Visu.settings.getValue("visu.gamepad.controls")
        var map = new Map(String, Number)
          .set(VisuGamepadButtonActions.NONE, 0)
          .set(VisuGamepadButtonActions.UP, 1)
          .set(VisuGamepadButtonActions.DOWN, 2)
          .set(VisuGamepadButtonActions.LEFT, 3)
          .set(VisuGamepadButtonActions.RIGHT, 4)
          .set(VisuGamepadButtonActions.ACTION, 5)
          .set(VisuGamepadButtonActions.FOCUS, 6)
          .set(VisuGamepadButtonActions.BOMB, 7)
        var pointer = map.getDefault(Struct.get(config, this.key), 0)
        var target = int64(pointer + 1)
        target = target < 0 ? 7 : (target > 7 ? 0 : target)
        var value = map.findKey(Lambda.equal, target)
        if (!Optional.is(value)) {
          return
        }

        Struct.set(config, this.key, value)
        Visu.settings.setValue("visu.gamepad.controls", config).save()
        Visu.initInputCandyLoader(controller.layerId)
        controller.sfxService.play("menu-use-entry")
      },
    },
  }
}



///@param {String} name
///@param {String} text
///@return {Struct}
function factoryPlayerGamepadAnalogEntryConfig(name, text) {
  return { 
    layout: { type: UILayoutType.VERTICAL },
    label: {
      key: name,
      text: text,
    },
    previous: {
      key: name,
      callback: function() {
        var controller = Beans.get(BeanVisuController)
        var config = Visu.settings.getValue("visu.gamepad.controls")
        var map = new Map(String, Number)
          .set(VisuGamepadAnalogActions.NONE, 0)
          .set(VisuGamepadAnalogActions.MOVE, 1)
          .set(VisuGamepadAnalogActions.AIM, 2)
        var pointer = map.getDefault(Struct.get(config, this.key), 0)
        var target = int64(pointer - 1)
        target = target < 0 ? 2 : (target > 2 ? 0 : target)
        var value = map.findKey(Lambda.equal, target)
        if (!Optional.is(value)) {
          return
        }

        Struct.set(config, this.key, value)
        var oppositeKey = this.key == "ANALOG_L" ? "ANALOG_R" : "ANALOG_L"
        var oppositeValue = Struct.get(config, oppositeKey)
        if (value != VisuGamepadAnalogActions.NONE && value == oppositeValue) {
          oppositeValue = value == VisuGamepadAnalogActions.MOVE
            ? VisuGamepadAnalogActions.AIM
            : VisuGamepadAnalogActions.MOVE
          Struct.set(config, oppositeKey, oppositeValue)
        }

        Visu.settings.setValue("visu.gamepad.controls", config).save()
        controller.sfxService.play("menu-use-entry")
      },
    },
    preview: {
      key: name,
      label: {
        key: name,
        text: "None",
      },
      updateCustom: function() { 
        var controls = Visu.settings.getValue("visu.gamepad.controls")
        var value = Struct.get(controls, this.key)
        var action = String.toLowerCase(value)
        this.label.text = Language.get($"visu.menu.gamepad.action.{action}")
      },
    },
    next: {
      key: name,
      callback: function() {
        var controller = Beans.get(BeanVisuController)
        var config = Visu.settings.getValue("visu.gamepad.controls")
        var map = new Map(String, Number)
          .set(VisuGamepadAnalogActions.NONE, 0)
          .set(VisuGamepadAnalogActions.MOVE, 1)
          .set(VisuGamepadAnalogActions.AIM, 2)
        var pointer = map.getDefault(Struct.get(config, this.key), 0)
        var target = int64(pointer + 1)
        target = target < 0 ? 2 : (target > 2 ? 0 : target)
        var value = map.findKey(Lambda.equal, target)
        if (!Optional.is(value)) {
          return
        }

        Struct.set(config, this.key, value)
        var oppositeKey = this.key == "ANALOG_L" ? "ANALOG_R" : "ANALOG_L"
        var oppositeValue = Struct.get(config, oppositeKey)
        if (value != VisuGamepadAnalogActions.NONE && value == oppositeValue) {
          oppositeValue = value == VisuGamepadAnalogActions.MOVE
            ? VisuGamepadAnalogActions.AIM
            : VisuGamepadAnalogActions.MOVE
          Struct.set(config, oppositeKey, oppositeValue)
        }

        Visu.settings.setValue("visu.gamepad.controls", config).save()
        controller.sfxService.play("menu-use-entry")
      },
    },
  }
}


///@param {Number} index
///@param {String} text
///@return {Struct}
function factoryMenuButtonEntryTitle(index, text) {
  return {
    name: $"menu-button-entry_{index}",
    template: VisuComponents.get("menu-button-entry"),
    layout: VisuLayouts.get("menu-button-entry"),
    config: {
      layout: { type: UILayoutType.VERTICAL },
      label: {
        text: text,
        font: "font_kodeo_mono_28_bold",
      },
    }
  }
}


///@param {Struct} json
function VisuMenuNode(json) constructor {

  ///@type {String}
  title = Assert.isType(json.title, String)

  ///@type {?String}
  back = Core.isType(json.back, String) ? json.back : null

  ///@type {Array<VisuMenuEntry>}
  entries = new Array(VisuMenuEntry, Core.isType(Struct.get(json, "entries"), GMArray) 
    ? GMArray.map(json.entries, function(json) { return new VisuMenuEntry(json) }) 
    : [])
}


///@param {Struct} json
function VisuMenuEntry(json) constructor {

  ///@type {String}
  name = Assert.isType(json.name, String)

  ///@type {String}
  title = Struct.getIfType(json, "title", String, "")

  ///@type {VisuMenuEntryEvent}
  event = new VisuMenuEntryEvent(json.event)
}


///@param {Struct} json
function VisuMenuEntryEvent(json) constructor {

  ///@type {String}
  type = Assert.isEnum(json.type, VisuMenuEntryEventType)

  ///@type {?Struct}
  data = Core.isType(Struct.get(json, "data"), Struct) ? json.data : null
}


///@param {?Struct} [_config]
function VisuMenu(_config = null) constructor {

  ///@return {Map<String, VisuMenuNode>}
  static parseNodes = function() {
    var nodes = new Map(String, VisuMenuNode)
    try {
      var manifest = FileUtil
        .readFileSync(FileUtil.get(Core.getRuntimeType() != RuntimeType.GXGAMES
          ? $"{working_directory}track/manifest.json"
          : $"{working_directory}track/manifest-wasm.json"))
        .getData()
      var parserTask = JSON.parserTask(manifest, {
        callback: function(prototype, json, key, acc) {
          acc.add(new prototype(json), key)
        },
        acc: nodes,
        model: "Collection<io.alkapivo.visu.ui.VisuMenuNode>",
      })

      var index = 0
      var MAX_INDEX = 9999
      while (true) {
        if (parserTask.update().status != TaskStatus.RUNNING) {
          break
        }
        Assert.isTrue(index++ <= MAX_INDEX, $"Exceed MAX_INDEX={MAX_INDEX}")
      }
    } catch (exception) {
      Logger.error("VisuMenu", $"Exception throwed while parsing track/manifest.json: {exception.message}")
      Core.printStackTrace().printException(exception)
    }

    return nodes
  }

  ///@type {?Struct}
  config = Optional.is(_config)
    ? Assert.isType(_config, Struct, "VisuMenu::config must be type of ?Struct")
    : null

  ///@type {Boolean}
  enabled = false

  ///@type {Boolean}
  isMainMenu = false

  ///@type {?Callable}
  back = null

  ///@type {any}
  backData = null

  ///@type {?String}
  remapKey = null

  ///@type {Map<String, Containers>}
  containers = new Map(String, UI)

  ///@type {Map<String, Callable>}
  factories = new Map(String, Callable)
    .set("menu-main", Callable.get("factoryVisuMenuOpenMainEvent"))
    .set("menu-story", Callable.get("factoryVisuMenuOpenStoryEvent"))
    .set("menu-confirm", Callable.get("factoryVisuMenuOpenConfirmEvent"))
    .set("menu-developer", Callable.get("factoryVisuMenuOpenDeveloperEvent"))
    .set("menu-credits", Callable.get("factoryVisuMenuOpenCreditsEvent"))
    .set("menu-node", Callable.get("factoryVisuMenuOpenNodeEvent"))
    .set("menu-track-setup", Callable.get("factoryVisuMenuOpenTrackSetupEvent"))
    .set("menu-settings", Callable.get("factoryVisuMenuOpenSettingsEvent"))
    .set("menu-graphics", Callable.get("factoryVisuMenuOpenGraphicsEvent"))
    .set("menu-audio", Callable.get("factoryVisuMenuOpenAudioEvent"))
    .set("menu-gameplay", Callable.get("factoryVisuMenuOpenGameplayEvent"))
    .set("menu-controls", Callable.get("factoryVisuMenuOpenControlsEvent"))

  ///@type {Map<String, VisuMenuNode>}
  nodes = this.parseNodes()

  ///@private
  ///@param {UIlayout} parent
  ///@return {UILayout}
  factoryLayout = function(parent) {
    return new UILayout(
      {
        name: "visu-menu",
        //x: function() { return this.context.x() + (this.context.width() - this.width()) / 2.0 },
        x: function() { return this.context.x() },
        y: function() { return this.context.y() },
        width: function() { return this.context.width() },
        height: function() { return this.context.height() },
        nodes: {
          "visu-menu.title": {
            name: "visu-menu.title",
            x: function() { return this.context.x() + min((this.context.width() - this.width() ) / 4.0, 240.0) },
            y: function() { return this.context.y() },
            width: function() { return clamp(this.context.width() * 0.3, 480, 700) },
            height: function() { 
              var minFooterHeight = 48
              var minTitleHeight = 208
              var contextHeight = this.context.height()
              var viewHeight = Struct.get(context.nodes, "visu-menu.content").viewHeight
              if ((contextHeight / 2.0) - viewHeight - minFooterHeight >= 0) {
                return contextHeight / 2.0 >= minTitleHeight ? contextHeight / 2.0 : minTitleHeight
              } else {
                return contextHeight - viewHeight - minFooterHeight > minTitleHeight
                  ? contextHeight - viewHeight - minFooterHeight
                  : minTitleHeight
              }
            },
          },
          "visu-menu.content": {
            name: "visu-menu.content",
            x: function() { return this.context.x() + min((this.context.width() - this.width() ) / 4.0, 240.0) },
            //x: function() { return this.context.x() + clamp(this.context.width() * 0.15, 80, 384) },
            y: function() { return Struct.get(this.context.nodes, "visu-menu.title").bottom() + this.__margin.top },
            width: function() { return clamp(this.context.width() * 0.3, 480, 700) },
            viewHeight: 0.0,
            height: function() {
              var contextHeight = this.context.height()
              this.viewHeight = clamp(this.viewHeight, 0.0, this._height(this.context, this.__margin))
              return this.viewHeight
            },
            _height: function(context, margin) { 
              return context.height() 
                - Struct.get(context.nodes, "visu-menu.title").height()
                - Struct.get(context.nodes, "visu-menu.footer").height()
                - margin.top
                - margin.bottom
            },
            //margin: { top: 24, bottom: 24 },
            margin: { top: 0, bottom: 0 },
          },
          "visu-menu.footer": {
            name: "visu-menu.footer",
            x: function() { return this.context.x() + min((this.context.width() - this.width() ) / 4.0, 240.0) },
            y: function() { return this.context.y() + this.context.height() - this.height() },
            width: function() { return clamp(this.context.width() * 0.3, 480, 700) },
            height: function() {
              var minFooterHeight = 48
              return max(
                context.height()
                  - Struct.get(context.nodes, "visu-menu.title").height()
                  - Struct.get(context.nodes, "visu-menu.content").viewHeight,
                minFooterHeight
              )
            },
          },
          "visu-menu.statistics": {
            name: "visu-menu.statistics",
            margin: { top: 220, bottom: 72, left: 12, right: 4 },
            x: function() { 
              return Struct.get(this.context.nodes, "visu-menu.content").right() + this.margin.left
            },
            y: function() {
              return this.context.y() + this.margin.top
            },
            width: function() { 
              return this.context.width() - Struct.get(this.context.nodes, "visu-menu.content").right() - this.margin.left - this.margin.right
            },
            height: function() { 
             return this.context.height() - this.margin.top - this.margin.bottom
            },
          },
        }
      },
      parent
    )
  }

  ///@private
  ///@param {Struct} title
  ///@param {Array<Struct>} content
  ///@param {?UIlayout} [parent]
  ///@return {Map<String, UI>}
  factoryContainers = function(title, content, parent = null) {
    static factoryTitle = function(name, controller, layout, title) {
      return new UI({
        name: name,
        controller: controller,
        layout: layout,
        state: new Map(String, any, {
          "background-alpha": 0.5,
          "background-color": ColorUtil.fromHex(VisuTheme.color.sideDark).toGMColor(),
          "title": title,
          "uiAlpha": 0.0,
          "uiAlphaFactor": 0.05,
        }),
        updateArea: Callable
          .run(UIUtil.updateAreaTemplates
          .get("applyLayout")),
        renderDefault: new BindIntent(Callable
          .run(UIUtil.renderTemplates
          .get("renderDefaultNoSurface"))),
        __render: function() {
          var uiAlpha = clamp(this.state.get("uiAlpha") + DELTA_TIME * this.state.get("uiAlphaFactor"), 0.0, 1.0)
          this.state.set("uiAlpha", uiAlpha)
          this.renderDefault()
        },
        render: function() {
          var uiAlpha = clamp(this.state.get("uiAlpha") + DELTA_TIME * this.state.get("uiAlphaFactor"), 0.0, 1.0)
          //var uiAlpha = clamp(this.state.get("uiAlpha") + DeltaTime.apply(this.state.get("uiAlphaFactor")), 0.0, 1.0) 
          this.state.set("uiAlpha", uiAlpha)
          if (this.surface == null) {
            this.surface = new Surface({ width: this.area.getWidth(), height: this.area.getHeight() })
          }

          this.surface.update(this.area.getWidth(), this.area.getHeight())
          //if (!this.surfaceTick.get() && !this.surface.updated) {
          //  this.surface.render(this.area.getX(), this.area.getY(), uiAlpha)
          //  return
          //}
          
          GPU.set.surface(this.surface)
          var color = this.state.get("background-color")
          if (Core.isType(color, GMColor)) {
            GPU.render.clear(color, uiAlpha * this.state.getIfType("background-alpha", Number, 1.0))
          }
          
          var areaX = this.area.x
          var areaY = this.area.y
          var delta = DeltaTime.deltaTime
          DeltaTime.deltaTime += this.updateTimer != null && this.updateTimer.finished && this.surfaceTick.previous ? 0.0 : this.surfaceTick.delta
          this.area.x = this.offset.x
          this.area.y = this.offset.y
          this.items.forEach(this.renderItem, this.area)
          this.area.x = areaX
          this.area.y = areaY
          DeltaTime.deltaTime = delta
  
          GPU.reset.surface()
          static easeInExpo = function(progress = 0.0) {
            return progress == 0.0 ? 0.0 : Math.pow(2.0, 10.0 * progress - 10.0)
          }

          static easeOutExpo = function(progress = 0.0) {
            return progress == 1.0 ? 1.0 : 1.0 - Math.pow(2.0, -10.0 * progress)
          }
          
          var _ui = this.state.get("uiAlphaFactor") >= 0.0
            ? easeOutExpo(uiAlpha)
            : (1.0 + easeInExpo(1.0 - abs(uiAlpha)))
          this.surface.render(this.area.getX() * _ui, this.area.getY(), uiAlpha)
          //this.renderDefault()
        },
        onInit: function() {
          this.items.forEach(Lambda.free).clear()
          this.addUIComponents(new Array(UIComponent, [ 
            new UIComponent(this.state.get("title"))
          ]),
          new UILayout({
            area: this.area,
            width: function() { return this.area.getWidth() },
            height: function() { return this.area.getHeight() },
          }))
        },
      })
    }

    static factoryContent = function(name, controller, layout, content) {
      return new UI({
        name: name,
        controller: controller,
        layout: layout,
        selectedIndex: 0,
        previousIndex: 0,
        state: new Map(String, any, {
          "background-alpha": 0.33,
          "background-color": ColorUtil.fromHex(VisuTheme.color.accentShadow).toGMColor(),
          "content": content,
          "isKeyboardEvent": true,
          "initPress": false,
          "remapKey": null,
          "remapKeyRestored": 2,
          "uiAlpha": 0.0,
          "uiAlphaFactor": 0.05,
          "breath": new Timer(16 * pi, { loop: Infinity, amount: FRAME_MS * 8 }),
          "keyboard": new Keyboard({
            keys: {
              up: KeyboardKeyType.ARROW_UP,
              down: KeyboardKeyType.ARROW_DOWN,
              left: KeyboardKeyType.ARROW_LEFT,
              right: KeyboardKeyType.ARROW_RIGHT,
              space: KeyboardKeyType.SPACE,
              enter: KeyboardKeyType.ENTER,
            },
          }),
          "keyUpdater": new PrioritizedPressedKeyUpdater({ cooldown: 0.05 }),
          "playerKeyUpdater": new PrioritizedPressedKeyUpdater({ cooldown: 0.05 }),
        }),
        scrollbarY: { align: HAlign.RIGHT },
        fetchViewHeight: function() {
          return VISU_MENU_ENTRY_HEIGHT * this.collection.size()
        },
        updateArea: Callable
          .run(UIUtil.updateAreaTemplates
          .get("scrollableY")),
        updateVerticalSelectedIndex: new BindIntent(Callable
          .run(UIUtil.templates
          .get("updateVerticalSelectedIndex"))),
        updateCustom: function() {
          this.layout.viewHeight = this.fetchViewHeight()
          this.controller.remapKey = this.state.get("remapKey")
          if (Optional.is(this.controller.remapKey)) {
            this.state.set("remapKeyRestored", 2)
            return
          } 

          var remapKeyRestored = this.state.get("remapKeyRestored")
          if (remapKeyRestored > 0) {
            this.state.set("remapKeyRestored", remapKeyRestored - 1)
            return
          }

          if (this.state.get("initPress")) {
            this.state.set("initPress", false)
            var pointer = Struct.inject(this, "selectedIndex", 0)
            pointer = Core.isType(pointer, Number) ? clamp(pointer, 0, this.collection.size() - 1) : 0
            this.state.set("isKeyboardEvent", true)
            Struct.set(this, "selectedIndex", pointer)

            this.collection.components.forEach(function(component, iterator, pointer) {
              if (component.index == pointer) {
                component.items.forEach(function(item) {
                  item.backgroundColor = Struct.contains(item, "colorHoverOver") 
                    ? ColorUtil.fromHex(item.colorHoverOver).toGMColor()
                    : item.backgroundColor
                })
              } else {
                component.items.forEach(function(item) {
                  item.backgroundColor = Struct.contains(item, "colorHoverOut") 
                    ? ColorUtil.fromHex(item.colorHoverOut).toGMColor()
                    : item.backgroundColor
                })
              }
            }, pointer)
          }

          var keyboard = this.state.get("keyboard")
          var playerKeyboard = Beans.get(BeanVisuIO).keyboards.get("player")
          this.state.get("keyUpdater")
            .updateKeyboard(keyboard.update())
          //keyboard.update()
          this.state.get("playerKeyUpdater")
            .bindKeyboardKeys(playerKeyboard)
            .updateKeyboard(playerKeyboard.update())
          if (playerKeyboard.keys.up.pressed || keyboard.keys.up.pressed) {
            var pointer = Struct.inject(this, "selectedIndex", 0)
            if (!Core.isType(pointer, Number)) {
              pointer = 0
            } else {
              pointer = clamp(
                (pointer == 0 ? this.collection.size() - 1 : pointer - 1), 
                0, 
                (this.collection.size() -1 >= 0 ? this.collection.size() - 1 : 0)
              )
            }

            this.state.set("isKeyboardEvent", true)
            Struct.set(this, "selectedIndex", pointer)

            this.collection.components.forEach(function(component, iterator, pointer) {
              if (component.index == pointer) {
                component.items.forEach(function(item) {
                  item.backgroundColor = Struct.contains(item, "colorHoverOver") 
                    ? ColorUtil.fromHex(item.colorHoverOver).toGMColor()
                    : item.backgroundColor
                })
              } else {
                component.items.forEach(function(item) {
                  item.backgroundColor = Struct.contains(item, "colorHoverOut") 
                    ? ColorUtil.fromHex(item.colorHoverOut).toGMColor()
                    : item.backgroundColor
                })
              }
            }, pointer)
          }

          if (playerKeyboard.keys.down.pressed || keyboard.keys.down.pressed) {
            var pointer = Struct.inject(this, "selectedIndex", 0)
            if (!Core.isType(pointer, Number)) {
              pointer = 0
            } else {
              pointer = clamp(
                (pointer == this.collection.size() - 1 ? 0 : pointer + 1), 
                0, 
                (this.collection.size() - 1 >= 0 ? this.collection.size() - 1 : 0)
              )
            }
            
            this.state.set("isKeyboardEvent", true)
            Struct.set(this, "selectedIndex", pointer)

            this.collection.components.forEach(function(component, iterator, pointer) {
              if (component.index == pointer) {
                component.items.forEach(function(item) {
                  item.backgroundColor = Struct.contains(item, "colorHoverOver") 
                    ? ColorUtil.fromHex(item.colorHoverOver).toGMColor()
                    : item.backgroundColor
                })
              } else {
                component.items.forEach(function(item) {
                  item.backgroundColor = Struct.contains(item, "colorHoverOut") 
                    ? ColorUtil.fromHex(item.colorHoverOut).toGMColor()
                    : item.backgroundColor
                })
              }
            }, pointer)
          }

          if (playerKeyboard.keys.left.pressed || keyboard.keys.left.pressed) {
            var component = this.collection.findByIndex(Struct.inject(this, "selectedIndex", 0))
            if (Optional.is(component)) {
              var type = null
              if (String.contains(component.name, "menu-button-entry")) {
                type = "menu-button-entry"
              } else if (String.contains(component.name, "menu-button-input-entry")) {
                type = "menu-button-input-entry"
              } else if (String.contains(component.name, "menu-spin-select-entry")) {
                type = "menu-spin-select-entry"
              } if (String.contains(component.name, "menu-slider-entry")) {
                type = "menu-slider-entry"
              }

              switch (type) {
                case "menu-button-entry":
                  break
                case "menu-button-input-entry":
                  var label = component.items.find(function(item, index, name) { 
                    return String.contains(item.name, name) && Core.isType(Struct.get(item, "callback"), Callable)
                  }, "label")

                  if (Optional.is(label)) {
                    label.callback()
                  }
                  break
                case "menu-spin-select-entry":
                  var previous = component.items.find(function(item, index, name) { 
                    return String.contains(item.name, name) && Core.isType(Struct.get(item, "callback"), Callable)
                  }, "previous")
                  
                  if (Optional.is(previous)) {
                    previous.callback()
                  }
                  break
                case "menu-slider-entry":
                  var slider = component.items.find(function(item, index, name) { 
                    return String.contains(item.name, name) && Core.isType(Struct.get(item, "callback"), Callable)
                  }, "slider")
                  
                  if (Optional.is(slider)) {
                    slider.value = clamp(slider.value - slider.snapValue, slider.minValue, slider.maxValue)
                    if (slider.store != null && value != slider.store.getValue()) {
                      slider.store.set(slider.value)
                    }
                    slider.callback()
                  }
                  break
              }
            }
          }

          if (playerKeyboard.keys.right.pressed || keyboard.keys.right.pressed) {
            var component = this.collection.findByIndex(Struct.inject(this, "selectedIndex", 0))
            if (Optional.is(component)) {
              var type = null
              if (String.contains(component.name, "menu-button-entry")) {
                type = "menu-button-entry"
              } else if (String.contains(component.name, "menu-button-input-entry")) {
                type = "menu-button-input-entry"
              } else if (String.contains(component.name, "menu-spin-select-entry")) {
                type = "menu-spin-select-entry"
              } if (String.contains(component.name, "menu-slider-entry")) {
                type = "menu-slider-entry"
              }

              switch (type) {
                case "menu-button-entry":
                  break
                case "menu-button-input-entry":
                  var label = component.items.find(function(item, index, name) { 
                    return String.contains(item.name, name) && Core.isType(Struct.get(item, "callback"), Callable)
                  }, "label")

                  if (Optional.is(label)) {
                    label.callback()
                  }
                  break
                case "menu-spin-select-entry":
                  var next = component.items.find(function(item, index, name) { 
                    return String.contains(item.name, name) && Core.isType(Struct.get(item, "callback"), Callable)
                  }, "next")
                  
                  if (Optional.is(next)) {
                    next.callback()
                  }
                  break
                case "menu-slider-entry":
                  var slider = component.items.find(function(item, index, name) { 
                    return String.contains(item.name, name) && Core.isType(Struct.get(item, "callback"), Callable)
                  }, "slider")
                  
                  if (Optional.is(slider)) {
                    slider.value = clamp(slider.value + slider.snapValue, slider.minValue, slider.maxValue)
                    if (slider.store != null && value != slider.store.getValue()) {
                      slider.store.set(slider.value)
                    }
                    slider.callback()
                  }
                  break
              }
            }
          }
          
          if (playerKeyboard.keys.action.pressed
            || keyboard.keys.space.pressed
            || keyboard.keys.enter.pressed) {
            var component = this.collection.findByIndex(Struct.inject(this, "selectedIndex", 0))
            if (Optional.is(component)) {
              var type = null
              if (String.contains(component.name, "menu-button-entry")) {
                type = "menu-button-entry"
              } else if (String.contains(component.name, "menu-button-input-entry")) {
                type = "menu-button-input-entry"
              } else if (String.contains(component.name, "menu-spin-select-entry")) {
                type = "menu-spin-select-entry"
              } else if (String.contains(component.name, "menu-keyboard-key-entry")) {
                type = "menu-keyboard-key-entry"
              } if (String.contains(component.name, "menu-slider-entry")) {
                type = "menu-slider-entry"
              }

              switch (type) {
                case "menu-button-entry":
                case "menu-button-input-entry":
                  var label = component.items.find(function(item, index, name) { 
                    return String.contains(item.name, name) && Core.isType(Struct.get(item, "callback"), Callable)
                  }, "label")

                  if (Optional.is(label)) {
                    label.callback()
                  }
                  break
                case "menu-spin-select-entry":
                  break
                case "menu-keyboard-key-entry":
                  var label = component.items.find(function(item, index, name) { 
                    return String.contains(item.name, name) && Core.isType(Struct.get(item, "callback"), Callable)
                  }, "label")

                  if (Optional.is(label)) {
                    label.callback()
                  }
                  break
                case "menu-slider-entry":
                  break
              }
            }
          }

          var component = this.collection.findByIndex(Struct.get(this, "selectedIndex"))
          if (Optional.is(component)) {
            if (this.selectedIndex != this.previousIndex) {
              Beans.get(BeanVisuController).sfxService.play("menu-move-cursor")
            }
            this.previousIndex = this.selectedIndex

            this.state.get("breath").update()
            component.items.forEach(function(item, index, context) {
              // horizontal offset
              var itemX = item.area.getX();
              var itemWidth = item.area.getWidth()
              var offsetX = abs(context.offset.x)
              var areaWidth = context.area.getWidth()
              var itemRight = itemX + itemWidth
              if (itemX < offsetX || itemRight > offsetX + areaWidth) {
                var newX = (itemX < offsetX) ? itemX : itemRight - areaWidth
                context.offset.x = -1 * clamp(newX, 0.0, abs(context.offsetMax.x))
              }

              // vertical offset
              var itemY = item.area.getY();
              var itemHeight = item.area.getHeight()
              var offsetY = abs(context.offset.y)
              var areaHeight = context.area.getHeight()
              var itemBottom = itemY + itemHeight
              if (itemY < offsetY || itemBottom > offsetY + areaHeight) {
                var newY = (itemY < offsetY) ? itemY : itemBottom - areaHeight
                context.offset.y = -1 * clamp(newY, 0.0, abs(context.offsetMax.y))
              }

              item.backgroundAlpha = ((cos(this.state.get("breath").time) + 2.0) / 3.0) + 0.3
            }, this)
          }

          this.collection.components.forEach(function(component, iterator, pointer) {
            if (component.index != pointer) {
              component.items.forEach(function(item) {
                item.backgroundAlpha = 0.75
              })
            }
          }, Struct.get(this, "selectedIndex"))
        },
        renderItem: Callable
          .run(UIUtil.renderTemplates
          .get("renderItemDefaultScrollable")),
        renderDefaultScrollable: new BindIntent(Callable
          .run(UIUtil.renderTemplates
          .get("renderDefaultScrollableBlend"))),
        renderDefault: function() {
          this.updateVerticalSelectedIndex(VISU_MENU_ENTRY_HEIGHT)
          this.renderDefaultScrollable()
        },
        renderSurface: function() {
          var color = this.state.getIfType("background-color", GMColor, c_white)
          var alpha = this.state.getIfType("background-alpha", Number, 0.0)
          GPU.render.clear(color, alpha * this.state.get("uiAlpha"))
          
          var areaX = this.area.x
          var areaY = this.area.y
          //var delta = DeltaTime.deltaTime
          //DeltaTime.deltaTime += this.updateTimer != null && this.updateTimer.finished && this.surfaceTick.previous ? 0.0 : this.surfaceTick.delta
          this.area.x = this.offset.x
          this.area.y = this.offset.y
          this.items.forEach(this.renderItem, this.area)
          this.area.x = areaX
          this.area.y = areaY
          //DeltaTime.deltaTime = delta
        },
        render: function() {
          var uiAlpha = clamp(this.state.get("uiAlpha") + DELTA_TIME * this.state.get("uiAlphaFactor"), 0.0, 1.0)
          //var uiAlpha = clamp(this.state.get("uiAlpha") + DeltaTime.apply(this.state.get("uiAlphaFactor")), 0.0, 1.0)
          this.state.set("uiAlpha", uiAlpha)

          this.updateVerticalSelectedIndex(VISU_MENU_ENTRY_HEIGHT)
          if (!Optional.is(this.surface)) {
            this.surface = new Surface()
          }
  
          this.surface.update(this.area.getWidth(), this.area.getHeight())
          //if (!this.surfaceTick.get() && !this.surface.updated) {
          //  this.surface.render(this.area.getX(), this.area.getY(), uiAlpha)
          //  if (this.enableScrollbarY) {
          //    this.scrollbarY.render(this)
          //  }
          //  return
          //}
  
          this.surface.renderOn(this.renderSurface)
          static easeInExpo = function(progress = 0.0) {
            return progress == 0.0 ? 0.0 : Math.pow(2.0, 10.0 * progress - 10.0)
          }

          static easeOutExpo = function(progress = 0.0) {
            return progress == 1.0 ? 1.0 : 1.0 - Math.pow(2.0, -10.0 * progress)
          }
          
          var _ui = this.state.get("uiAlphaFactor") >= 0.0
            ? easeOutExpo(uiAlpha)
            : (1.0 + easeInExpo(1.0 - abs(uiAlpha)))
          this.surface.render(this.area.getX() * _ui, this.area.getY(), uiAlpha)
          if (this.enableScrollbarY) {
            this.scrollbarY.render(this)
          }
        },
        onMousePressedLeft: Callable
          .run(UIUtil.mouseEventTemplates
          .get("onMouseScrollbarY")),
        onMouseWheelUp: Callable
          .run(UIUtil.mouseEventTemplates
          .get("scrollableOnMouseWheelUpY")),
        onMouseWheelDown: Callable
          .run(UIUtil.mouseEventTemplates
          .get("scrollableOnMouseWheelDownY")),
        onInit: function() {
          /*///@UICOLLECTION_1*/ this.collection = new UICollection(this, { layout: this.layout })
          ///@UICOLLECTION_2 this.collection = this.collection == null ? new UICollection(this, { layout: this.layout }) : this.collection.clear()
          this.state.get("content").forEach(function(template, index, context) {
            context.collection.add(new UIComponent(template))
          }, this)

          if (this.state.get("content").size() > 0) {
            Struct.set(this, "selectedIndex", 0)
            this.state.set("isKeyboardEvent", true)
            this.collection.components.forEach(function(component, iterator, pointer) {
              if (component.index == pointer) {
                component.items.forEach(function(item) {
                  item.backgroundColor = Struct.contains(item, "colorHoverOver") 
                    ? ColorUtil.fromHex(item.colorHoverOver).toGMColor()
                    : item.backgroundColor
                })
              } else {
                component.items.forEach(function(item) {
                  item.backgroundColor = Struct.contains(item, "colorHoverOut") 
                    ? ColorUtil.fromHex(item.colorHoverOut).toGMColor()
                    : item.backgroundColor
                })
              }
            }, Struct.inject(this, "selectedIndex", 0))
          }

          this.state.set("initPress", true)
          this.scrollbarY.render = method(this.scrollbarY, function() { })
        },
      })
    }

    this.layout = this.factoryLayout(parent)
    this.containers
      .clear()
      .set(
        "container_visu-menu.title", 
        factoryTitle(
          "container_visu-menu.title",
          this,
          Struct.get(this.layout.nodes, "visu-menu.title"),
          title
        ))
      .set(
        "container_visu-menu.content", 
        factoryContent(
          "container_visu-menu.content",
          this,
          Struct.get(this.layout.nodes, "visu-menu.content"),
          content
        ))
      .set(
        "container_visu-menu.footer", 
        factoryTitle(
          "container_visu-menu.footer",
          this,
          Struct.get(this.layout.nodes, "visu-menu.footer"),
          {
            name: "visu-menu.footer",
            template: VisuComponents.get("menu-title"),
            layout: VisuLayouts.get("menu-title"),
            config: {
              label: { 
                font: "font_kodeo_mono_10_bold",
                align: { v: VAlign.BOTTOM, h: HAlign.LEFT },
                offset: { x: 48, y: -12 },
                useScale: true,
                useScaleWithOffset: true,
                text: $"v{Visu.version()} | Baron's Keep 2026 (c)",
                updateCustom: function() {
                  var serverVersion = Visu.serverVersion()
                  if (serverVersion == null) {
                    return this
                  }

                  var version = Visu.version()
                  this.label.text = version == serverVersion 
                    ? $"v{version} | Baron's Keep 2026 (c)"
                    : $"v{version} (itch.io: v{serverVersion}) | Baron's Keep 2026 (c)"

                },
                onMouseReleasedLeft: function() {
                  url_open("https://github.com/Barons-Keep/visu-project")
                }
              },
            },
          }
        ))
      .set(
        "_1_container_container_visu-menu.statistics",
        new UI({
          name: "_container_visu-menu.statistics",
          state: new Map(String, any, {
            "surface-alpha": 0.999,
            "background-alpha": 0.0,
            "text": "",
            "components": new Array(Struct, [
              {
                name: "_1_text-container_visu-menu.statistics",
                template: VisuComponents.get("text"),
                layout: VisuLayouts.get("text"),
                config: { 
                  layout: { 
                    type: UILayoutType.VERTICAL,
                  },
                  label: { 
                    text: "",
                    useScale: true,
                    enableColorWrite: false,
                    align: { v: VAlign.BOTTOM, h: HAlign.LEFT },
                    font: "font_kodeo_mono_28_bold",
                    updateCustom: function() {
                      var controller = Beans.get(BeanVisuController)
                      if (controller.trackService.track != null) {
                        this.label.text = $"{controller.trackService.track.name}"
                      }
                    },
                    postRender: function() {
                      var height = string_height(this.label.text)
                      var store = Struct.get(Struct.get(Struct.get(this, "layout"), "context"), "store")
                      if (height == Struct.get(store, "height")) {
                        return
                      }

                      Struct.set(store, "height", height)
                      this.context.areaWatchdog.signal()
                    },
                  },
                },
              },
              {
                name: "_2_text-container_visu-menu.statistics",
                template: VisuComponents.get("text"),
                layout: VisuLayouts.get("text"),
                config: { 
                  layout: { 
                    type: UILayoutType.VERTICAL,
                  },
                  label: { 
                    text: "",
                    useScale: true ,
                    enableColorWrite: false,
                    align: { v: VAlign.TOP, h: HAlign.LEFT },
                    font: "font_kodeo_mono_18_regular",
                    updateCustom: function() {
                      var statisticsText = ""
                      var controller = Beans.get(BeanVisuController)
                      if (controller.statistics != null) {
                        var trackService = controller.trackService
                        var playerReport = controller.statistics.playerReport
                        var coinReport = controller.statistics.coinReport
                        var shroomReport = controller.statistics.shroomReport
                        var bulletReport = controller.statistics.bulletReport
                        statisticsText = $"\n"
                          + $"\nDifficulty:            {Language.get(controller.difficulty)}"
                          + $"\nDuration:              {String.formatTimestampMilisecond(trackService.duration)}"
                          + $"\nLongest Life Streak:   {String.formatTimestampMilisecond(playerReport.maxAliveTime)}"
                          + $"\nFocus Mode Time:       {String.formatTimestampMilisecond(playerReport.focusedTime)}"
                          + "\n"
                          + $"\nPoints Collected:      {String.format(coinReport.collectedByPointValue, 8, 0)}" 
                          + $"\nForce Collected:       {String.format(coinReport.collectedByForceValue, 8, 0)}"
                          + "\n"
                          + $"\nLives Remaining:       {String.format(playerReport.lives, 8, 0)}"
                          + $"\nExtra Lives Collected: {String.format(coinReport.collectedByLifeValue, 8, 0)}"
                          + $"\nLives Lost:            {String.format(playerReport.usedLives, 8, 0)}"
                          + "\n"
                          + $"\nBombs Remaining:       {String.format(playerReport.bombs, 8, 0)}"
                          + $"\nBombs Collected:       {String.format(coinReport.collectedByBombValue, 8, 0)}"
                          + $"\nBombs Used:            {String.format(playerReport.usedBombs, 8, 0)}"
                          + "\n"
                          + $"\nShots Fired:           {String.format(bulletReport.spawnedByPlayer, 8, 0)}"
                          + $"\nTotal Enemies:         {String.format(shroomReport.spawned, 8, 0)}"
                          + $"\nEnemies Bombed:        {String.format(shroomReport.nuked, 8, 0)}"
                          + $"\nEnemies Hit:           {String.format(shroomReport.shooted, 8, 0)}"
                      }

                      this.context.state.set("text", statisticsText)
                    },
                    postRender: function() {
                      var text = this.context.state.get("text")
                      if (this.label.text == text) {
                        return
                      }
                        
                      this.label.text = text
                      var height = string_height(this.label.text)
                      var store = Struct.get(Struct.get(Struct.get(this, "layout"), "context"), "store")
                      if (height == Struct.get(store, "height")) {
                        return
                      }

                      Struct.set(store, "height", height)
                      this.context.areaWatchdog.signal()
                    },
                  },
                },
              },
            ])
          }),
          layout: Struct.get(this.layout.nodes, "visu-menu.statistics"),
          propagate: true,
          scrollbarY: { align: HAlign.RIGHT },
          updateTimer: new Timer(FRAME_MS * Core.getProperty("visu.menu.statistics.updateTimer", 4.0), { loop: Infinity, shuffle: true }),
          updateArea: Callable.run(UIUtil.updateAreaTemplates.get("scrollableY")),
          renderItem: Callable.run(UIUtil.renderTemplates.get("renderItemDefaultScrollable")),
          __render: new BindIntent(Callable.run(UIUtil.renderTemplates.get("renderDefaultScrollableAlpha"))),
          render: function() {
            if (this.state.get("text") != "" && Beans.get(BeanVisuController).menu.isMainMenu) {
              this.__render()
            }
          },
          onMousePressedLeft: Callable.run(UIUtil.mouseEventTemplates.get("onMouseScrollbarY")),
          onMouseWheelUp: Callable.run(UIUtil.mouseEventTemplates.get("scrollableOnMouseWheelUpY")),
          onMouseWheelDown: Callable.run(UIUtil.mouseEventTemplates.get("scrollableOnMouseWheelDownY")),
          onInit: function() {
            var container = this
            this.items.forEach(Lambda.free).clear() 
            /*///@UICOLLECTION_1*/ this.collection = new UICollection(this, { layout: container.layout })
            ///@UICOLLECTION_2 this.collection = this.collection == null ? new UICollection(this, { layout: container.layout }) : this.collection.clear()
            this.updateArea()
            this.addUIComponents(state.get("components")
              .map(function(component) {
                return new UIComponent(component)
              }),
              new UILayout({
                area: container.area,
                width: function() { return this.area.getWidth() },
              })
            )
          },
        })
      )


    return this.containers
  }
  
  ///@private
  ///@type {EventPump}
  dispatcher = new EventPump(this, new Map(String, Callable, {
    "open": function(event) {
      var controller = Beans.get(BeanVisuController)
      var editor = Beans.get(Visu.modules().editor.controller)
      if (editor != null && editor.renderUI) {
        //this.enabled = false
        return
      }

      var blur = controller.visuRenderer.blur
      blur.target = 24.0
      blur.startValue = blur.value
      blur.reset()

      this.dispatcher.execute(new Event("close"))
      this.back = Struct.getIfType(event.data, "back", Callable)
      this.backData = Struct.get(event.data, "backData")
      this.isMainMenu = Struct.getIfType(event.data, "isMainMenu", Boolean, false)
      this.enabled = true
      this.containers = this.factoryContainers(event.data.title, event.data.content, event.data.layout)
      this.containers.forEach(function(container, key, uiService) {
        container.state.set("uiAlphaFactor", 0.05)
        uiService.send(new Event("add", {
          container: container,
          replace: true,
        }))
      }, controller.uiService)
    },
    "close": function(event) {    
      this.isMainMenu = false
      var controller = Beans.get(BeanVisuController)
      if (Struct.getIfType(event.data, "fade", Boolean, false)) {
        var blur = controller.visuRenderer.blur
        blur.target = 0.0
        blur.startValue = blur.value
        blur.reset()

        this.containers.forEach(function(container) {
          Struct.set(container, "onMousePressedLeft", method(container, function(event) { }))
          Struct.set(container, "onMouseWheelUp", method(container, function(event) { }))
          Struct.set(container, "onMouseWheelDown", method(container, function(event) { }))
          Struct.set(container, "updateCustom", method(container, function() {
            var controller = Beans.get(BeanVisuController)
            this.state.set("uiAlphaFactor", -0.05)
            var blur = controller.visuRenderer.blur
            if (blur.value == 0.0) {
              controller.menu.send(new Event("close"))
            }
          }))
        })

        return
      }

      this.back = null
      this.backData = null
      this.enabled = false
      this.containers.forEach(function (container, key, uiService) {
        uiService.send(new Event("remove", { 
          name: key, 
          quiet: true,
        }))
      }, controller.uiService).clear()
    },
    "back": function(event) {
      if (this.back != null) {
        this.dispatcher.execute(this.back(this.backData))
        return
      }

      this.dispatcher.execute(new Event("close", { fade: true }))
    },
    "game-end": function(event) {
      this.isMainMenu = false
      var controller = Beans.get(BeanVisuController)
      controller.playerService.remove()
      controller.sfxService.play("menu-select-entry")
      controller.send(new Event("scene-close", {
        duration: 1.5,
        callback: function() {
          var controller = Beans.get(BeanVisuController)
          controller.sfxService.play("menu-use-entry")
          game_end()
        },
      }))

      this.send(new Event("close", { fade: true }))
    },
  }))

  ///@param {Event} event
  ///@return {?Promise}
  send = function(event) {
    return this.dispatcher.send(event)
  }

  ///@return {VETrackControl}
  update = function() { 
    VISU_MENU_ENTRY_HEIGHT = ceil(clamp((((GuiHeight() - 540) / 540) * 44) + 60, 60, 104))
    this.dispatcher.update()
    return this
  }
}
