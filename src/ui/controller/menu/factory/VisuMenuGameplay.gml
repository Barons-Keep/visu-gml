///@package fun.barons-keep.visu.ui.controller.menu

///@param {?Struct} [_config]
///@return {Event}
function factoryVisuMenuOpenGameplayEvent(_config = null) {
  var controller = Beans.get(BeanVisuController)
  var config = Struct.appendUnique(_config, {
    back: controller.menu.factories.get("menu-settings"),
  })

  var event = new Event("open").setData({
    back: config.back,
    layout: controller.visuRenderer.layout,
    title: {
      name: "gameplay_title",
      template: VisuComponents.get("menu-title"),
      layout: VisuLayouts.get("menu-title"),
      config: {
        label: { 
          text: Language.get("visu.menu.gameplay"),
        },
      },
    },
    content: new Array(Struct, [
      //factoryMenuButtonEntryTitle("graphics_menu-button-input-entry_title", Language.get("visu.menu.settings.display")),
      {
        name: "gameplay_menu-button-input-entry_render-hud",
        template: VisuComponents.get("menu-button-input-entry"),
        layout: VisuLayouts.get("menu-button-input-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.render-hud", "Render HUD"),
            callback: new BindIntent(function() {
              var value = Visu.settings.getValue("visu.interface.render-hud")
              Visu.settings.setValue("visu.interface.render-hud", !value).save()
              Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
            }),
            onMouseReleasedLeft: function() {
              this.callback()
            },
          },
          input: {
            label: { text: VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT },
            callback: function() {
              var value = Visu.settings.getValue("visu.interface.render-hud")
              Visu.settings.setValue("visu.interface.render-hud", !value).save()
              Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
            },
            updateCustom: function() {
              this.label.text = Visu.settings.getValue("visu.interface.render-hud") ? VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT : VISU_MENU_BUTTON_INPUT_ENTRY_FALSE_TEXT
              this.label.alpha = this.label.text == VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT ? 1.0 : 0.3
            },
            onMouseReleasedLeft: function() {
              this.callback()
            },
          }
        }
      },
      {
        name: "gameplay_menu-button-input-entry_player-hint",
        template: VisuComponents.get("menu-button-input-entry"),
        layout: VisuLayouts.get("menu-button-input-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.off-screen-player-hints", "Off-screen player hints"),
            callback: new BindIntent(function() {
              var value = Visu.settings.getValue("visu.interface.player-hint")
              Visu.settings.setValue("visu.interface.player-hint", !value).save()
              Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
            }),
            onMouseReleasedLeft: function() {
              this.callback()
            },
          },
          input: {
            label: { text: VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT },
            callback: function() {
              var value = Visu.settings.getValue("visu.interface.player-hint")
              Visu.settings.setValue("visu.interface.player-hint", !value).save()
              Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
            },
            updateCustom: function() {
              this.label.text = Visu.settings.getValue("visu.interface.player-hint") ? VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT : VISU_MENU_BUTTON_INPUT_ENTRY_FALSE_TEXT
              this.label.alpha = this.label.text == VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT ? 1.0 : 0.3
            },
            onMouseReleasedLeft: function() {
              this.callback()
            },
          }
        }
      },
      {
        name: "gameplay_menu-button-input-entry_raw-mode",
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
        name: "gameplay_menu-spin-select-entry_dt",
        template: VisuComponents.get("menu-spin-select-entry"),
        layout: VisuLayouts.get("menu-spin-select-entry"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: Language.get("visu.menu.delta-time", "Delta time"),
          },
          previous: { 
            callback: function() {
              var map = new Map(String, Number)
                .set(DeltaTimeMode.DEFAULT, 0)
                .set(DeltaTimeMode.STEADY, 1)
                .set(DeltaTimeMode.UNSTEADY, 2)
                .set(DeltaTimeMode.DISABLED, 3)
              var pointer = map.getDefault(Visu.settings.getValue("visu.delta-time"), 0)
              var target = clamp(int64(pointer - 1), -1, 4)
              target = target == -1 ? 3 : (target == 4 ? 0 : target)
              var value = map.findKey(Lambda.equal, target)

              if (!Optional.is(value)) {
                return
              }

              Visu.settings.setValue("visu.delta-time", value).save()
              Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
            },
          },
          preview: {
            label: {
              text: Visu.settings.getValue("visu.delta-time")
            },
            updateCustom: function() { 
              this.label.text = Visu.settings.getValue("visu.delta-time")
            },
          },
          next: { 
            callback: function() {
              var map = new Map(String, Number)
                .set(DeltaTimeMode.DEFAULT, 0)
                .set(DeltaTimeMode.STEADY, 1)
                .set(DeltaTimeMode.UNSTEADY, 2)
                .set(DeltaTimeMode.DISABLED, 3)
              var pointer = map.getDefault(Visu.settings.getValue("visu.delta-time"), 0)
              var target = clamp(int64(pointer + 1), -1, 4)
              target = target == -1 ? 3 : (target == 4 ? 0 : target)
              var value = map.findKey(Lambda.equal, target)

              if (!Optional.is(value)) {
                return
              }

              Visu.settings.setValue("visu.delta-time", value).save()
              Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
            },
          },
        },
      },
      {
        name: "gameplay_menu-spin-select-entry_lang",
        template: VisuComponents.get("menu-spin-select-entry"),
        layout: VisuLayouts.get("menu-spin-select-entry"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: Language.get("visu.menu.lang"),
          },
          previous: { 
            callback: function() {
              var controller = Beans.get(BeanVisuController)
              var map = new Map(String, Number)
                .set(LanguageType.en_EN, 0)
                .set(LanguageType.pl_PL, 1)

              var langIntent = Struct.getDefault(this.context, "langIntent", Visu.settings.getValue("visu.language"))
              var pointer = map.getDefault(langIntent, 0)
              var target = clamp(int64(pointer - 1), -1, 2)
              target = target == -1 ? 1 : (target == 2 ? 0 : target)
              var value = map.findKey(Lambda.equal, target)

              if (!Optional.is(value)) {
                return
              }

              Struct.set(this.context, "langIntent", value)
              controller.sfxService.play("menu-use-entry")
            },
          },
          preview: {
            label: {
              text: Language.get(Language.getCode()),
            },
            updateCustom: function() { 
              var langIntent = Struct.getIfType(this.context, "langIntent", String, Visu.settings.getValue("visu.language"))
              this.label.text = Language.get(langIntent)
            },
          },
          next: { 
            callback: function() {
              var controller = Beans.get(BeanVisuController)
              var map = new Map(String, Number)
                .set(LanguageType.en_EN, 0)
                .set(LanguageType.pl_PL, 1)

              var langIntent = Struct.getDefault(this.context, "langIntent", Visu.settings.getValue("visu.language"))
              var pointer = map.getDefault(langIntent, 0)
              var target = clamp(int64(pointer + 1), -1, 2)
              target = target == -1 ? 1 : (target == 2 ? 0 : target)
              var value = map.findKey(Lambda.equal, target)

              if (!Optional.is(value)) {
                return
              }

              Struct.set(this.context, "langIntent", value)
              controller.sfxService.play("menu-use-entry")
            },
          },
        },
      },
      {
        name: "gameplay_menu-button-entry_lang-apply",
        template: VisuComponents.get("menu-button-entry"),
        layout: VisuLayouts.get("menu-button-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.lang.apply"),
            enable: { value: true },
            updateCustom: function() {
              var lang = Visu.settings.getValue("visu.language")
              var langIntent = Struct.getIfType(this.context, "langIntent", String, lang)
              this.enable.value = lang != langIntent
            },
            callback: new BindIntent(function() {
              var controller = Beans.get(BeanVisuController)
              var lang = Visu.settings.getValue("visu.language")
              var langIntent = Struct.getIfType(this.context, "langIntent", String, lang)
              Struct.set(controller, "langIntent", langIntent)
              if (lang == langIntent) {
                return
              }

              var factory = controller.menu.factories.get("menu-confirm")
              var event = factory({
                accept: function() {
                  var controller = Beans.get(BeanVisuController)
                  var langIntent = Struct.get(controller, "langIntent")
                  Visu.settings.setValue("visu.language", langIntent).save()
                  VISU_MANIFEST_LOAD_ON_START_DISPATCHED = false
                  VISU_FORCE_GOD_MODE_DISPATCHED = false
                  VISU_BOOT_UP = false
                  VISU_LOAD_PROPERTIES = false
                  VISU_LOAD_SETTINGS = false
                  VISU_PARSE_CLI = false
                  //VISU_DISPLAY_SERVICE_SETUP = false
                  controller.send(new Event("scene-close", {
                    duration: 1.0,
                    callback: function() {
                      var controller = Beans.get(BeanVisuController)
                      controller.sfxService.play("menu-use-entry")
                      controller.playerService.remove()
                      Scene.open("scene_visu", {
                        VisuController: {
                          initialState: {
                            name: Core.getProperty("visu.splashscreen.skip")
                              ? "idle" 
                              : "splashscreen",
                          },
                        },
                      })
                    },
                  }))
                  return new Event("close", { fade: true })
                },
                decline: function() {
                  var factory = Beans.get(BeanVisuController).menu.factories.get("menu-gameplay")
                  return factory()
                },
                message: Language.get("visu.menu.lang.reload"), 
              })

              Struct.set(event.data, "back", controller.menu.factories.get("menu-settings"))
              controller.menu.send(event)
              controller.sfxService.play("menu-select-entry")
            }),
            onMouseReleasedLeft: function() {
              this.callback()
            },
          },
        }
      },
      {
        name: "gameplay_menu-button-entry_back",
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