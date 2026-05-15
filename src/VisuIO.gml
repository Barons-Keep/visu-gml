///@package io.alkapivo.visu

#macro BeanVisuIO "VisuIO"
///@param {?Struct} [config]
function VisuIO(config = null): Service(config) constructor {

  ///@type {Map}
  keyboards = new Map(String, Keyboard, {
    "player": new Keyboard({
      keys: {
        up: Visu.settings.getValue("visu.keyboard.player.up", KeyboardKeyType.ARROW_UP),
        down: Visu.settings.getValue("visu.keyboard.player.down", KeyboardKeyType.ARROW_DOWN),
        left: Visu.settings.getValue("visu.keyboard.player.left", KeyboardKeyType.ARROW_LEFT),
        right: Visu.settings.getValue("visu.keyboard.player.right", KeyboardKeyType.ARROW_RIGHT),
        action: Visu.settings.getValue("visu.keyboard.player.action", ord("Z")),
        bomb: Visu.settings.getValue("visu.keyboard.player.bomb", ord("X")),
        focus: Visu.settings.getValue("visu.keyboard.player.focus", KeyboardKeyType.SHIFT),
        openMenu: KeyboardKeyType.ESC,
      },
      updateEnd: function() {
        static initGamepad = function(context) {
          var gamepad = Struct.get(context, "gamepad")
          if (gamepad == null) {
            gamepad = {
              index: 1,
              previous: {
                up: false,
                down: false,
                left: false,
                right: false,
              },
              keyUpdater: new PrioritizedPressedVirtualKeyUpdater({
                keys: [
                  "up",
                  "down",
                  "left",
                  "right"
                ],
              }),
              axis: null,
              up: IC_GetAction("up"),
              down: IC_GetAction("down"),
              left: IC_GetAction("left"),
              right: IC_GetAction("right"),
              action: IC_GetAction("action"),
              focus: IC_GetAction("focus"),
              bomb: IC_GetAction("bomb"),
              openMenu: IC_GetAction("openMenu"),
            }

            Struct.set(context, "gamepad", gamepad)
          }

          return gamepad
        }

        static updateKeyboardKey = function(index, action, key) {
          var _action = __INPUTCANDY.actions[action]
          var _actionOn = key.on
          var _actionPressed = key.pressed
          var _actionReleased = key.released
          if (is_array(_action.gamepad)) {
            for (var idx = 0; idx < array_length(_action.gamepad); idx++) {
              var ic_code = _action.gamepad[idx]
              var signal = __IC.GetSignal(index, ic_code)
              if (signal != null) {
                _actionOn = _actionOn || signal.is_held
                _actionPressed = _actionPressed || (signal.is_held && !signal.was_held)
                _actionReleased = _actionReleased || (!signal.is_held && signal.was_held)
              }
            }
          } else {
            var ic_code = _action.gamepad
            var signal = __IC.GetSignal(index, ic_code)
            if (signal != null) {
              _actionOn = _actionOn || signal.is_held
              _actionPressed = _actionPressed || (signal.is_held && !signal.was_held)
              _actionReleased = _actionReleased || (!signal.is_held && signal.was_held)
            }
          }

          if (_actionPressed || _actionReleased) {
            keyboard_lastkey = vk_nokey
          }

          key.on = _actionOn
          key.pressed = _actionPressed
          key.released = _actionReleased
        }

        static updateAxisKeyboardKey = function(axis, key, previous) {
          if (axis) {
            key.on = true
            key.pressed = !previous
            key.released = false
          } else if (previous) {
            key.on = false
            key.pressed = false
            key.released = true
          }

          return axis
        }

        var inputCandyLoader = Beans.get(BeanInputCandyLoader)
        if (inputCandyLoader == null || !inputCandyLoader.enabled || !inputCandyLoader.initialized) {
          Struct.set(Struct.get(this, "gamepad"), "axis", null)
          return this
        }

        var keys = this.keys
        var gamepad = initGamepad(this)
        var index = gamepad.index
        var axis = __IC.GetAxisSignal(index, 0)
        var controls = Visu.settings.getValue("visu.gamepad.controls")
        var updatePrevious = false
        switch (Struct.get(controls, "ANALOG_L")) {
          case VisuGamepadAnalogActions.MOVE:
            gamepad.previous.up = updateAxisKeyboardKey(axis.up, keys.up, gamepad.previous.up)
            gamepad.previous.down = updateAxisKeyboardKey(axis.down, keys.down, gamepad.previous.down)
            gamepad.previous.left = updateAxisKeyboardKey(axis.left, keys.left, gamepad.previous.left)
            gamepad.previous.right = updateAxisKeyboardKey(axis.right, keys.right, gamepad.previous.right)
            updatePrevious = true
            break
          case VisuGamepadAnalogActions.AIM:
            if (axis.value > 0.3) {
              global.gamepadPlayerAimMouse = false
              global.gamepadPlayerAimAngle = Math.lerpAngle(global.gamepadPlayerAimAngle, axis.angle, 0.2)
              global.gamepadPlayerAimAlpha = global.gamepadPlayerAimAlphaDefault
            } else if (!global.gamepadPlayerAimMouse) {
              global.gamepadPlayerAimMouse = MouseUtil.hasMoved()
            }
            break
        }

        switch (Struct.get(controls, "ANALOG_R")) {
          case VisuGamepadAnalogActions.MOVE:
            gamepad.previous.up = updateAxisKeyboardKey(axis.rUp, keys.up, gamepad.previous.up)
            gamepad.previous.down = updateAxisKeyboardKey(axis.rDown, keys.down, gamepad.previous.down)
            gamepad.previous.left = updateAxisKeyboardKey(axis.rLeft, keys.left, gamepad.previous.left)
            gamepad.previous.right = updateAxisKeyboardKey(axis.rRight, keys.right, gamepad.previous.right)
            updatePrevious = true
            break
          case VisuGamepadAnalogActions.AIM:
            if (axis.rValue > 0.3) {
              global.gamepadPlayerAimMouse = false
              global.gamepadPlayerAimAngle = Math.lerpAngle(global.gamepadPlayerAimAngle, axis.rAngle, 0.2)
              global.gamepadPlayerAimAlpha = global.gamepadPlayerAimAlphaDefault
            } else if (!global.gamepadPlayerAimMouse) {
              global.gamepadPlayerAimMouse = global.gamepadPlayerAimMouse || MouseUtil.hasMoved()
            }
            break
        }

        if (!updatePrevious) {

        }

        updateKeyboardKey(index, gamepad.up, keys.up)
        updateKeyboardKey(index, gamepad.down, keys.down)
        updateKeyboardKey(index, gamepad.left, keys.left)
        updateKeyboardKey(index, gamepad.right, keys.right)
        updateKeyboardKey(index, gamepad.action, keys.action)
        updateKeyboardKey(index, gamepad.focus, keys.focus)
        updateKeyboardKey(index, gamepad.bomb, keys.bomb)
        updateKeyboardKey(index, gamepad.openMenu, keys.openMenu)

        gamepad.keyUpdater.updateKeyboard(this)
        gamepad.axis = axis

        return this
      },
    })
  })

  mouses = new Map(String, Mouse, {
    "player": new Mouse({
      up: Visu.settings.getValue("visu.mouse.player.up", MouseButtonType.NONE),
      down: Visu.settings.getValue("visu.mouse.player.down", MouseButtonType.NONE),
      left: Visu.settings.getValue("visu.mouse.player.left", MouseButtonType.NONE),
      right: Visu.settings.getValue("visu.mouse.player.right", MouseButtonType.NONE),
      action: Visu.settings.getValue("visu.mouse.player.action", MouseButtonType.NONE),
      bomb: Visu.settings.getValue("visu.mouse.player.bomb", MouseButtonType.NONE),
      focus: Visu.settings.getValue("visu.mouse.player.focus", MouseButtonType.NONE),
    })
  })

  ///@type {Keyboard}
  keyboard = new Keyboard({
    keys: { 
      fullscreen: KeyboardKeyType.F11,
      openMenu: KeyboardKeyType.ESC,
      anykey: KeyboardKeyType.SHIFT,
    },
    updateEnd: function() {
      static initGamepad = function(context) {
        var gamepad = Struct.get(context, "gamepad")
        if (gamepad == null) {
          gamepad = {
            index: 1,
            openMenu: IC_GetAction("openMenu"),
            anykey: IC_GetAction("anykey"),
          }

          Struct.set(context, "gamepad", gamepad)
        }

        return gamepad
      }

      static updateKeyboardKey = function(index, action, key) {
        var _action = __INPUTCANDY.actions[action]
        var _actionOn = key.on
        var _actionPressed = key.pressed
        var _actionReleased = key.released
        if (is_array(_action.gamepad)) {
          for (var idx = 0; idx < array_length(_action.gamepad); idx++) {
            var ic_code = _action.gamepad[idx]
            var signal = __IC.GetSignal(index, ic_code)
            if (signal != null) {
              _actionOn = _actionOn || signal.is_held
              _actionPressed = _actionPressed || (signal.is_held && !signal.was_held)
              _actionReleased = _actionReleased || (!signal.is_held && signal.was_held)
            }
          }
        } else {
          var ic_code = _action.gamepad
          var signal = __IC.GetSignal(index, ic_code)
          if (signal != null) {
            _actionOn = _actionOn || signal.is_held
            _actionPressed = _actionPressed || (signal.is_held && !signal.was_held)
            _actionReleased = _actionReleased || (!signal.is_held && signal.was_held)
          }
        }

        if (_actionPressed || _actionReleased) {
          keyboard_lastkey = vk_nokey
        }

        key.on = _actionOn
        key.pressed = _actionPressed
        key.released = _actionReleased
      }

      var inputCandyLoader = Beans.get(BeanInputCandyLoader)
      if (inputCandyLoader == null || !inputCandyLoader.enabled || !inputCandyLoader.initialized) {
        return this
      }

      var keys = this.keys
      var gamepad = initGamepad(this)
      var index = gamepad.index

      updateKeyboardKey(index, gamepad.openMenu, keys.openMenu)
      updateKeyboardKey(index, gamepad.anykey, keys.anykey)

      return this
    },
  })

  ///@type {Mouse}
  mouse = new Mouse({ 
    left: MouseButtonType.LEFT,
    right: MouseButtonType.RIGHT,
    wheelUp: MouseButtonType.WHEEL_UP,
    wheelDown: MouseButtonType.WHEEL_DOWN,
  })

  ///@type {Boolean}
  mouseMoved = false

  ///@type {Number}
  mouseMovedCooldown = Core.getProperty("visu.io.mouse-moved.cooldown", 4.0)

  ///@type {Boolean}
  hideCursor = false
  
  ///@private
  ///@param {VisuController} controller
  ///@return {VisuIO}
  fullscreenKeyboardEvent = function(controller) {
    if (Core.getRuntimeType() == RuntimeType.GXGAMES) {
      return this
    }

    if (this.keyboard.keys.fullscreen.pressed) {
      var fullscreen = Beans.get(BeanDisplayService).getFullscreen()
      Logger.debug(BeanVisuIO, String.template("DisplayService::setFullscreen({0})", fullscreen ? "false" : "true"))
      
      Beans.get(BeanDisplayService).setFullscreen(!fullscreen)
      if (fullscreen && Visu.settings.getValue("visu.borderless-window")) {
        Beans.get(BeanDisplayService).center()
      }

      Visu.settings.setValue("visu.fullscreen", !fullscreen).save()
    }

    return this
  }

  ///@private
  ///@param {VisuController} controller
  ///@return {VisuIO}
  functionKeyboardEvent = function(controller) {
    var menu = controller.menu
    if (this.keyboard.keys.openMenu.pressed 
        && controller.visuRenderer.initTimer.finished
        && menu.remapKey == null) {

      var state = controller.fsm.getStateName()
      var factory = menu.factories.get("menu-main")
      switch (state) {
        case "idle":
          if (menu.enabled && controller.visuRenderer.blur.target != 0.0) {
            menu.send(new Event("back"))
            controller.sfxService.play("menu-select-entry")
          } else {
            menu.send(factory())
          }
          break
        case "game-over":
          break
        case "play":
          var fsmState = controller.fsm.currentState
          if (fsmState.state.get("promises-resolved") != "success") {
            break
          }

          var editor = Beans.get(Visu.modules().editor.controller)
          if (Optional.is(editor) && editor.renderUI) {
            break
          }

          controller.send(new Event("pause", factory()))
          break
        case "paused":
          if (menu.enabled) {
            menu.send(new Event("back") )
            controller.sfxService.play("menu-select-entry")
            if (!Optional.is(menu.back)) {
              if (controller.trackService.isTrackLoaded()
                  && !controller.trackService.track.audio.isLoaded() 
                  && 1 > abs(controller.trackService.time - controller.trackService.duration)) {
                var editor = Beans.get(Visu.modules().editor.controller)
                if (editor != null) {
                  controller.send(new Event("rewind", {
                    resume: true,
                    timestamp: 0.0,
                  }))
                } else {
                  menu.send(factory())
                }
              } else {
                controller.send(new Event("play"))
              }
            }
          } else {
            menu.send(factory())
          }
          break
      }
    }

    return this
  }

  ///@private
  ///@param {VisuController} controller
  ///@return {VisuIO}
  mouseEvent = function(controller) {
    static generateMouseEvent = function(name) {
      return new Event(name, { 
        x: MouseUtil.getMouseX(), 
        y: MouseUtil.getMouseY(),
      })
    }

    var _x = MouseUtil.getMouseX() 
    var _y = MouseUtil.getMouseY()
    if (this.mouse.buttons.left.pressed) {
      controller.uiService.send(generateMouseEvent("MousePressedLeft"))
    }

    if (this.mouse.buttons.left.released) {
      controller.uiService.send(generateMouseEvent("MouseReleasedLeft"))
      Beans.get(BeanDisplayService).setCursor(Cursor.DEFAULT)
    }

    if (this.mouse.buttons.left.drag) {
      controller.uiService.send(generateMouseEvent("MouseDragLeft"))
    }

    if (this.mouse.buttons.left.drop) {
      controller.uiService.send(generateMouseEvent("MouseDropLeft"))
    }

    if (this.mouse.buttons.right.pressed) {
      controller.uiService.send(generateMouseEvent("MousePressedRight"))
    }

    if (this.mouse.buttons.right.released) {
      controller.uiService.send(generateMouseEvent("MouseReleasedRight"))
    }
    
    if (this.mouse.buttons.wheelUp.on) {  
      controller.uiService.send(generateMouseEvent("MouseWheelUp"))
    }
    
    if (this.mouse.buttons.wheelDown.on) {  
      controller.uiService.send(generateMouseEvent("MouseWheelDown"))
    }

    if (MouseUtil.hasMoved()) {  
      this.hideCursor = false
      if (this.mouseMoved == 0) {
        this.mouseMoved = this.mouseMovedCooldown
        controller.uiService.mouseEventHandler("MouseHoverOver", _x, _y)
      }
    } else {
      if (this.mouseMoved > 0) {
        this.mouseMoved = clamp(this.mouseMoved - 1, 0, this.mouseMovedCooldown)
      }

      var inputCandyLoader = Beans.get(BeanInputCandyLoader)
      if (!this.hideCursor
          && inputCandyLoader != null
          && inputCandyLoader.enabled 
          && inputCandyLoader.initialized
          && inputCandyLoader.anykey()) {
        this.hideCursor = true
      }
    }

    return this
  }

  ///@private
  ///@param {VisuController} controller
  ///@return {VisuIO}
  __mouseEvent = function(controller) {
    static generateMouseEvent = function(name) {
      return new Event(name, { 
        x: MouseUtil.getMouseX(), 
        y: MouseUtil.getMouseY(),
      })
    }

    if (this.mouse.buttons.left.pressed) {
      controller.uiService.send(generateMouseEvent("MousePressedLeft"))
    }

    if (this.mouse.buttons.left.released) {
      controller.uiService.send(generateMouseEvent("MouseReleasedLeft"))
      Beans.get(BeanDisplayService).setCursor(Cursor.DEFAULT)
    }

    if (this.mouse.buttons.left.drag) {
      controller.uiService.send(generateMouseEvent("MouseDragLeft"))
    }

    if (this.mouse.buttons.left.drop) {
      controller.uiService.send(generateMouseEvent("MouseDropLeft"))
    }

    if (this.mouse.buttons.right.pressed) {
      controller.uiService.send(generateMouseEvent("MousePressedRight"))
    }

    if (this.mouse.buttons.right.released) {
      controller.uiService.send(generateMouseEvent("MouseReleasedRight"))
    }
    
    if (this.mouse.buttons.wheelUp.on) {  
      controller.uiService.send(generateMouseEvent("MouseWheelUp"))
    }
    
    if (this.mouse.buttons.wheelDown.on) {  
      controller.uiService.send(generateMouseEvent("MouseWheelDown"))
    }

    if (MouseUtil.hasMoved()) {  
      this.hideCursor = false
      if (this.mouseMoved == 0) {
        this.mouseMoved = this.mouseMovedCooldown
        controller.uiService.send(generateMouseEvent("MouseHoverOver"))
      }
    } else {
      if (this.mouseMoved > 0) {
        this.mouseMoved = clamp(this.mouseMoved - 1, 0, this.mouseMovedCooldown)
      }

      var inputCandyLoader = Beans.get(BeanInputCandyLoader)
      if (!this.hideCursor
          && inputCandyLoader != null
          && inputCandyLoader.enabled 
          && inputCandyLoader.initialized
          && inputCandyLoader.anykey()) {
        this.hideCursor = true
      }
    }

    return this
  }

  ///@return {VisuIO}
  updateBegin = function() {
    var controller = Beans.get(BeanVisuController)
    var isController = controller != null
    try {
      //EVENT_COUNTER.log().reset()
      GMArray.updateBegin()
      Struct.updateBegin()
      this.keyboard.update()
      this.mouse.update()
      GMTFContext.updateBegin()
      
      if (!isController) {
        return this
      }

      if (controller.fsm.getStateName() != "scene-close") {
        this.fullscreenKeyboardEvent(controller)
        this.functionKeyboardEvent(controller)
        this.mouseEvent(controller)
      }
    } catch (exception) {
      var message = $"'{BeanVisuIO}::update()' fatal error: {exception.message}"
      Logger.error(BeanVisuIO, message)
      Core.printStackTrace().printException(exception)
      if (isController) {
        controller.send(new Event("spawn-popup", { message: message }))
      }
    }

    return this
  }
}