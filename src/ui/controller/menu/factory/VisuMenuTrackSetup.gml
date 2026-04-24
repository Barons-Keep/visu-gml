///@package fun.barons-keep.visu.ui.controller.menu

///@param {?Struct} [_config]
///@return {Event}
function factoryVisuMenuOpenTrackSetupEvent(_config = null) {
  var context = this
  var controller = Beans.get(BeanVisuController)
  var config = Struct.appendUnique(_config, {
    title: "",
    path: "",
    node: null,
  })

  var event = new Event("open").setData({
    layout: controller.visuRenderer.layout,
    title: {
      name: "open-track-setup_title",
      template: VisuComponents.get("menu-title"),
      layout: VisuLayouts.get("menu-title"),
      config: {
        label: {
          text: config.title,
        },
      },
    },
    content: new Array(Struct, [
      {
        name: "open-track-setup_menu-spin-select-entry_difficulty",
        template: VisuComponents.get("menu-spin-select-entry"),
        layout: VisuLayouts.get("menu-spin-select-entry"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: Language.get("visu.menu.difficulty"),
          },
          previous: { 
            callback: function() {
              var map = new Map(String, Number)
                .set(Difficulty.EASY, 0)
                .set(Difficulty.NORMAL, 1)
                .set(Difficulty.HARD, 2)
                .set(Difficulty.LUNATIC, 3)
              var pointer = map.getDefault(Visu.settings.getValue("visu.difficulty"), 1)
              var target = clamp(int64(pointer - 1), 0, 3)
              var value = map.findKey(function(value, key, target) {
                return value == target
              }, target)

              if (!Optional.is(value)) {
                return
              }

              Visu.settings.setValue("visu.difficulty", value).save()
              Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
            },
            updateCustom: function() {
              var value = Visu.settings.getValue("visu.difficulty")
              if (value == Difficulty.EASY) {
                this.sprite.setAlpha(0.15)
              } else {
                this.sprite.setAlpha(1.0)
              }
            }
          },
          preview: {
            label: {
              text: Visu.settings.getValue("visu.difficulty"),
            },
            updateCustom: function() { 
              var difficulty = String.toLowerCase(Visu.settings.getValue("visu.difficulty"))
              this.label.text = Language.get($"visu.menu.difficulty.{difficulty}")
            },
          },
          next: { 
            callback: function() {
              var map = new Map(String, Number)
                .set(Difficulty.EASY, 0)
                .set(Difficulty.NORMAL, 1)
                .set(Difficulty.HARD, 2)
                .set(Difficulty.LUNATIC, 3)
              var pointer = map.getDefault(Visu.settings.getValue("visu.difficulty"), 1)
              var target = clamp(int64(pointer + 1), 0, 3)
              var value = map.findKey(function(value, key, target) {
                return value == target
              }, target)

              if (!Optional.is(value)) {
                return
              }

              Visu.settings.setValue("visu.difficulty", value).save()
              Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
            },
            updateCustom: function() {
              var value = Visu.settings.getValue("visu.difficulty")
              if (value == Difficulty.LUNATIC) {
                this.sprite.setAlpha(0.15)
              } else {
                this.sprite.setAlpha(1.0)
              }
            }
          },
        },
      },
      {
        name: "open-track-setup_menu-button-input-entry_mouse-shoot",
        template: VisuComponents.get("menu-button-input-entry"),
        layout: VisuLayouts.get("menu-button-input-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.mouse-aim"),
            callback: new BindIntent(function() {
              var value = Visu.settings.getValue("visu.developer.mouse-shoot")
              Visu.settings.setValue("visu.developer.mouse-shoot", !value).save()
              Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
            }),
            onMouseReleasedLeft: function() {
              this.callback()
            },
          },
          input: {
            label: {
              text: VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT,
            },
            callback: function() {
              var value = Visu.settings.getValue("visu.developer.mouse-shoot")
              Visu.settings.setValue("visu.developer.mouse-shoot", !value).save()
              Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
            },
            updateCustom: function() {
              this.label.text = Visu.settings.getValue("visu.developer.mouse-shoot")
                ? VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT
                : VISU_MENU_BUTTON_INPUT_ENTRY_FALSE_TEXT
              this.label.alpha = this.label.text == VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT
                ? 1.0
                : 0.3
            },
            onMouseReleasedLeft: function() {
              this.callback()
            },
          }
        }
      },
      {
        name: "open-track-setup_menu-button-input-entry_raw-mode",
        template: VisuComponents.get("menu-button-input-entry"),
        layout: VisuLayouts.get("menu-button-input-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.raw-mode"),
            callback: new BindIntent(function() {
              var value = Visu.settings.getValue("visu.graphics.raw-mode")
              Visu.settings.setValue("visu.graphics.raw-mode", !value).save()
              Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
            }),
            onMouseReleasedLeft: function() {
              this.callback()
            },
          },
          input: {
            label: { text: VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT },
            callback: function() {
              var value = Visu.settings.getValue("visu.graphics.raw-mode")
              Visu.settings.setValue("visu.graphics.raw-mode", !value).save()
              Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
            },
            updateCustom: function() {
              this.label.text = Visu.settings.getValue("visu.graphics.raw-mode") ? VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT : VISU_MENU_BUTTON_INPUT_ENTRY_FALSE_TEXT
              this.label.alpha = this.label.text == VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT ? 1.0 : 0.3
            },
            onMouseReleasedLeft: function() {
              this.callback()
            },
          }
        }
      },
      {
        name: "open-track-setup_menu-button-entry_run",
        template: VisuComponents.get("menu-button-entry"),
        layout: VisuLayouts.get("menu-button-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.run"),
            callback: new BindIntent(function() {
              Visu.settings.setValue("visu.graphics.visual-mode", false).saveToFile()
              Beans.get(BeanVisuController).send(new Event("load", {
                manifest: $"{working_directory}{this.callbackData}",
                autoplay: true,
                isRawMode: Visu.settings.getValue("visu.graphics.raw-mode"),
              }))
              Beans.get(BeanVisuController).sfxService.play("menu-select-entry")
              Beans.get(BeanDialogueDesignerService).close()
            }),
            callbackData: config.path,
            onMouseReleasedLeft: function() {
              this.callback()
            },
          },
        }
      },
      {
        name: "open-track-setup_menu-button-entry_run-visual-mode",
        template: VisuComponents.get("menu-button-entry"),
        layout: VisuLayouts.get("menu-button-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.run.visual-mode"),
            callback: new BindIntent(function() {
              Visu.settings
                .setValue("visu.graphics.visual-mode", true)
                .saveToFile()
              Beans.get(BeanVisuController).send(new Event("load", {
                manifest: $"{working_directory}{this.callbackData}",
                autoplay: true,
                rawMode: false,
              }))
              Beans.get(BeanVisuController).sfxService.play("menu-select-entry")
              Beans.get(BeanDialogueDesignerService).close()
            }),
            callbackData: config.path,
            onMouseReleasedLeft: function() {
              this.callback()
            },
          },
        }
      },
      {
        name: "open-track-setup_menu-button-entry_back",
        template: VisuComponents.get("menu-button-entry"),
        layout: VisuLayouts.get("menu-button-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.back"),
            callback: new BindIntent(function() {
              var controller = Beans.get(BeanVisuController)
              var menu = controller.menu
              var factoryMain = controller.menu.factories.get("menu-main")
              var factoryNode = controller.menu.factories.get("menu-node")
              menu.send(Core.isType(menu.nodes.get(this.callbackData), VisuMenuNode)
                ? factoryNode(this.callbackData)
                : factoryMain())
              controller.sfxService.play("menu-select-entry")
            }),
            callbackData: config.node,
            onMouseReleasedLeft: function() {
              this.callback()
            },
            colorHoverOut: VisuTheme.color.deny,
          },
        }
      }
    ]),
    back: (config.node != null 
      ? controller.menu.factories.get("menu-node")
      : controller.menu.factories.get("menu-main")),
    backData: config.node,
  })

  return event
}