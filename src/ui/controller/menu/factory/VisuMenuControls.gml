///@package fun.barons-keep.visu.ui.controller.menu

///@param {?Struct} [_config]
///@return {Event}
function factoryVisuMenuOpenControlsEvent(_config = null) {
  var controller = Beans.get(BeanVisuController)
  var config = Struct.appendUnique(_config, {
    back: controller.menu.factories.get("menu-settings"),
  })

  var event = new Event("open").setData({
    back: config.back,
    layout: controller.visuRenderer.layout,
    title: {
      name: "controls_title",
      template: VisuComponents.get("menu-title"),
      layout: VisuLayouts.get("menu-title"),
      config: {
        label: { 
          text: Language.get("visu.menu.controls", "Controls"),
        },
      },
    },
    content: new Array(Struct, [
      {
        name: $"settings_menu-button-entry_controls.keyboard-and-mouse.title",
        template: VisuComponents.get("menu-button-entry"),
        layout: VisuLayouts.get("menu-button-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: Language.get("visu.menu.controls.keyboard-and-mouse"),
            font: "font_kodeo_mono_28_bold",
          },
        },
      },
      {
        name: $"settings_menu-keyboard-key-entry_up",
        template: VisuComponents.get("menu-keyboard-key-entry"),
        layout: VisuLayouts.get("menu-keyboard-key-entry"),
        config: factoryPlayerKeyboardKeyEntryConfig("up", Language.get("visu.menu.key.up")),
      },
      {
        name: $"settings_menu-keyboard-key-entry_down",
        template: VisuComponents.get("menu-keyboard-key-entry"),
        layout: VisuLayouts.get("menu-keyboard-key-entry"),
        config: factoryPlayerKeyboardKeyEntryConfig("down", Language.get("visu.menu.key.down")),
      },
      {
        name: $"settings_menu-keyboard-key-entry_left",
        template: VisuComponents.get("menu-keyboard-key-entry"),
        layout: VisuLayouts.get("menu-keyboard-key-entry"),
        config: factoryPlayerKeyboardKeyEntryConfig("left", Language.get("visu.menu.key.left")),
      },
      {
        name: $"settings_menu-keyboard-key-entry_right",
        template: VisuComponents.get("menu-keyboard-key-entry"),
        layout: VisuLayouts.get("menu-keyboard-key-entry"),
        config: factoryPlayerKeyboardKeyEntryConfig("right", Language.get("visu.menu.key.right")),
      },
      {
        name: $"settings_menu-keyboard-key-entry_action",
        template: VisuComponents.get("menu-keyboard-key-entry"),
        layout: VisuLayouts.get("menu-keyboard-key-entry"),
        config: factoryPlayerKeyboardKeyEntryConfig("action", Language.get("visu.menu.key.shoot")),
      },
      {
        name: $"settings_menu-keyboard-key-entry_bomb",
        template: VisuComponents.get("menu-keyboard-key-entry"),
        layout: VisuLayouts.get("menu-keyboard-key-entry"),
        config: factoryPlayerKeyboardKeyEntryConfig("bomb", Language.get("visu.menu.key.use-bomb")),
      },
      {
        name: $"settings_menu-keyboard-key-entry_focus",
        template: VisuComponents.get("menu-keyboard-key-entry"),
        layout: VisuLayouts.get("menu-keyboard-key-entry"),
        config: factoryPlayerKeyboardKeyEntryConfig("focus", Language.get("visu.menu.key.focus-mode")),
      },
      {
        name: $"settings_menu-button-entry_gamepad-title",
        template: VisuComponents.get("menu-button-entry"),
        layout: VisuLayouts.get("menu-button-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: Language.get("visu.menu.gamepad.title.disconnected"),
            font: "font_kodeo_mono_28_bold",
            preRender: function() {
              var loader = Beans.get(BeanInputCandyLoader)
              var label = (loader != null && loader.isGamepadConnected())
                ? "visu.menu.gamepad.title.connected"
                : "visu.menu.gamepad.title.disconnected"
              this.label.text = Language.get(label)
            },
          },
        },
      },
      {
        name: "settings_menu-button-input-entry_gamepad",
        template: VisuComponents.get("menu-button-input-entry"),
        layout: VisuLayouts.get("menu-button-input-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.gamepad"),
            callback: new BindIntent(function() {
              var value = Visu.settings.getValue("visu.gamepad")
              Visu.settings.setValue("visu.gamepad", !value).save()
              Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
            }),
            onMouseReleasedLeft: function() {
              this.callback()
            },
          },
          input: {
            label: { text: VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT },
            callback: function() {
              var value = Visu.settings.getValue("visu.gamepad")
              Visu.settings.setValue("visu.gamepad", !value).save()
              Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
            },
            updateCustom: function() {
              this.label.text = Visu.settings.getValue("visu.gamepad") ? VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT : VISU_MENU_BUTTON_INPUT_ENTRY_FALSE_TEXT
              this.label.alpha = this.label.text == VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT ? 1.0 : 0.3
            },
            onMouseReleasedLeft: function() {
              this.callback()
            },
          }
        }
      },
      {
        name: "settings_menu-spin-select-entry_gamepad_BTN_A",
        template: VisuComponents.get("menu-spin-select-entry"),
        layout: VisuLayouts.get("menu-spin-select-entry"),
        config: factoryPlayerGamepadButtonEntryConfig("BTN_A", Language.get("visu.menu.gamepad.button.a"))
      },
      {
        name: "settings_menu-spin-select-entry_gamepad_BTN_B",
        template: VisuComponents.get("menu-spin-select-entry"),
        layout: VisuLayouts.get("menu-spin-select-entry"),
        config: factoryPlayerGamepadButtonEntryConfig("BTN_B", Language.get("visu.menu.gamepad.button.b"))
      },
      {
        name: "settings_menu-spin-select-entry_gamepad_BTN_X",
        template: VisuComponents.get("menu-spin-select-entry"),
        layout: VisuLayouts.get("menu-spin-select-entry"),
        config: factoryPlayerGamepadButtonEntryConfig("BTN_X", Language.get("visu.menu.gamepad.button.x"))
      },
      {
        name: "settings_menu-spin-select-entry_gamepad_BTN_Y",
        template: VisuComponents.get("menu-spin-select-entry"),
        layout: VisuLayouts.get("menu-spin-select-entry"),
        config: factoryPlayerGamepadButtonEntryConfig("BTN_Y", Language.get("visu.menu.gamepad.button.y"))
      },
      {
        name: "settings_menu-spin-select-entry_gamepad_BTN_PAD_U",
        template: VisuComponents.get("menu-spin-select-entry"),
        layout: VisuLayouts.get("menu-spin-select-entry"),
        config: factoryPlayerGamepadButtonEntryConfig("BTN_PAD_U", Language.get("visu.menu.gamepad.d-pad.up"))
      },
      {
        name: "settings_menu-spin-select-entry_gamepad_BTN_PAD_D",
        template: VisuComponents.get("menu-spin-select-entry"),
        layout: VisuLayouts.get("menu-spin-select-entry"),
        config: factoryPlayerGamepadButtonEntryConfig("BTN_PAD_D", Language.get("visu.menu.gamepad.d-pad.down"))
      },
      {
        name: "settings_menu-spin-select-entry_gamepad_BTN_PAD_L",
        template: VisuComponents.get("menu-spin-select-entry"),
        layout: VisuLayouts.get("menu-spin-select-entry"),
        config: factoryPlayerGamepadButtonEntryConfig("BTN_PAD_L", Language.get("visu.menu.gamepad.d-pad.left"))
      },
      {
        name: "settings_menu-spin-select-entry_gamepad_BTN_PAD_R",
        template: VisuComponents.get("menu-spin-select-entry"),
        layout: VisuLayouts.get("menu-spin-select-entry"),
        config: factoryPlayerGamepadButtonEntryConfig("BTN_PAD_R", Language.get("visu.menu.gamepad.d-pad.right"))
      },
      {
        name: "settings_menu-spin-select-entry_gamepad_BTN_L_TRIGGER",
        template: VisuComponents.get("menu-spin-select-entry"),
        layout: VisuLayouts.get("menu-spin-select-entry"),
        config: factoryPlayerGamepadButtonEntryConfig("BTN_L_TRIGGER", Language.get("visu.menu.gamepad.left-shoulder"))
      },
      {
        name: "settings_menu-spin-select-entry_gamepad_BTN_R_TRIGGER",
        template: VisuComponents.get("menu-spin-select-entry"),
        layout: VisuLayouts.get("menu-spin-select-entry"),
        config: factoryPlayerGamepadButtonEntryConfig("BTN_R_TRIGGER", Language.get("visu.menu.gamepad.left-trigger"))
      },
      {
        name: "settings_menu-spin-select-entry_gamepad_BTN_L_SHOULDER",
        template: VisuComponents.get("menu-spin-select-entry"),
        layout: VisuLayouts.get("menu-spin-select-entry"),
        config: factoryPlayerGamepadButtonEntryConfig("BTN_L_SHOULDER", Language.get("visu.menu.gamepad.right-shoulder"))
      },
      {
        name: "settings_menu-spin-select-entry_gamepad_BTN_R_SHOULDER",
        template: VisuComponents.get("menu-spin-select-entry"),
        layout: VisuLayouts.get("menu-spin-select-entry"),
        config: factoryPlayerGamepadButtonEntryConfig("BTN_R_SHOULDER", Language.get("visu.menu.gamepad.right-trigger"))
      },
      {
        name: "settings_menu-spin-select-entry_gamepad_BTN_L_STICK",
        template: VisuComponents.get("menu-spin-select-entry"),
        layout: VisuLayouts.get("menu-spin-select-entry"),
        config: factoryPlayerGamepadButtonEntryConfig("BTN_L_STICK", Language.get("visu.menu.gamepad.left-stick"))
      },
      {
        name: "settings_menu-spin-select-entry_gamepad_BTN_R_STICK",
        template: VisuComponents.get("menu-spin-select-entry"),
        layout: VisuLayouts.get("menu-spin-select-entry"),
        config: factoryPlayerGamepadButtonEntryConfig("BTN_R_STICK", Language.get("visu.menu.gamepad.right-stick"      ))
      },
      {
        name: "settings_menu-spin-select-entry_gamepad_ANALOG_L",
        template: VisuComponents.get("menu-spin-select-entry"),
        layout: VisuLayouts.get("menu-spin-select-entry"),
        config: factoryPlayerGamepadAnalogEntryConfig("ANALOG_L", Language.get("visu.menu.gamepad.analog-l"))
      },
      {
        name: "settings_menu-spin-select-entry_gamepad_ANALOG_R",
        template: VisuComponents.get("menu-spin-select-entry"),
        layout: VisuLayouts.get("menu-spin-select-entry"),
        config: factoryPlayerGamepadAnalogEntryConfig("ANALOG_R", Language.get("visu.menu.gamepad.analog-r"))
      },
      {
        name: "settings_menu-button-entry_back",
        template: VisuComponents.get("menu-button-entry"),
        layout: VisuLayouts.get("menu-button-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.back"),
            callback: new BindIntent(function() {
              Beans.get(BeanVisuController).menu.send(Callable.run(this.callbackData))
              Beans.get(BeanVisuController).sfxService.play("menu-select-entry")
            }),
            callbackData: config.back,
            onMouseReleasedLeft: function() {
              this.callback()
            },
            colorHoverOut: VisuTheme.color.deny,
          },
        }
      }
    ])
  })

  return event
}