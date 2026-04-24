///@package fun.barons-keep.visu.ui.controller.menu

///@param {?Struct} [_config]
///@return {Event}
function factoryVisuMenuOpenDeveloperEvent(_config = null) {
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
          text: Language.get("visu.menu.developer", "Developer"),
        },
      },
    },
    content: new Array(Struct, [
      {
        name: "developer_menu-button-input-entry_debug",
        template: VisuComponents.get("menu-button-input-entry"),
        layout: VisuLayouts.get("menu-button-input-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.debug.mode", "Debug mode"),
            callback: new BindIntent(function() {
              var value = !is_debug_overlay_open()
              Visu.settings.setValue("visu.debug", value).save()
              Core.debugOverlay(value)
              Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
            }),
            onMouseReleasedLeft: function() {
              this.callback()
            },
          },
          input: {
            label: { text: VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT },
            callback: function() {
              var value = !is_debug_overlay_open()
              Visu.settings.setValue("visu.debug", value).save()
              Core.debugOverlay(value)
              Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
            },
            updateCustom: function() {
              this.label.text = is_debug_overlay_open() ? VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT : VISU_MENU_BUTTON_INPUT_ENTRY_FALSE_TEXT
              this.label.alpha = this.label.text == VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT ? 1.0 : 0.3
            },
            onMouseReleasedLeft: function() {
              this.callback()
            },
          }
        }
      },
      {
        name: "developer_menu-button-input-entry_god-mode",
        template: VisuComponents.get("menu-button-input-entry"),
        layout: VisuLayouts.get("menu-button-input-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.god-mode", "God mode"),
            callback: new BindIntent(function() {
              var value = Visu.settings.getValue("visu.god-mode")
              Visu.settings.setValue("visu.god-mode", !value).save()
              Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
            }),
            onMouseReleasedLeft: function() {
              this.callback()
            },
          },
          input: {
            label: { text: VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT },
            callback: function() {
              var value = Visu.settings.getValue("visu.god-mode")
              Visu.settings.setValue("visu.god-mode", !value).save()
              Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
            },
            updateCustom: function() {
              this.label.text = Visu.settings.getValue("visu.god-mode") ? VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT : VISU_MENU_BUTTON_INPUT_ENTRY_FALSE_TEXT
              this.label.alpha = this.label.text == VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT ? 1.0 : 0.3
            },
            onMouseReleasedLeft: function() {
              this.callback()
            },
          }
        }
      },
      {
        name: "developer_menu-button-input-entry_debug-render-entities-mask",
        template: VisuComponents.get("menu-button-input-entry"),
        layout: VisuLayouts.get("menu-button-input-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.debug.render.masks", "Render debug masks"),
            callback: new BindIntent(function() {
              var value = Visu.settings.getValue("visu.debug.render-entities-mask")
              Visu.settings.setValue("visu.debug.render-entities-mask", !value).save()
              Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
            }),
            onMouseReleasedLeft: function() {
              this.callback()
            },
          },
          input: {
            label: { text: VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT },
            callback: function() {
              var value = Visu.settings.getValue("visu.debug.render-entities-mask")
              Visu.settings.setValue("visu.debug.render-entities-mask", !value).save()
              Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
            },
            updateCustom: function() {
              this.label.text = Visu.settings.getValue("visu.debug.render-entities-mask") ? VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT : VISU_MENU_BUTTON_INPUT_ENTRY_FALSE_TEXT
              this.label.alpha = this.label.text == VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT ? 1.0 : 0.3
            },
            onMouseReleasedLeft: function() {
              this.callback()
            },
          }
        }
      },
      {
        name: "developer_menu-button-input-entry_debug-render-debug-chunks",
        template: VisuComponents.get("menu-button-input-entry"),
        layout: VisuLayouts.get("menu-button-input-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.debug.render.chunks", "Render debug chunks"),
            callback: new BindIntent(function() {
              var value = Visu.settings.getValue("visu.debug.render-debug-chunks")
              Visu.settings.setValue("visu.debug.render-debug-chunks", !value).save()
              Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
            }),
            onMouseReleasedLeft: function() {
              this.callback()
            },
          },
          input: {
            label: { text: VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT },
            callback: function() {
              var value = Visu.settings.getValue("visu.debug.render-debug-chunks")
              Visu.settings.setValue("visu.debug.render-debug-chunks", !value).save()
              Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
            },
            updateCustom: function() {
              this.label.text = Visu.settings.getValue("visu.debug.render-debug-chunks") ? VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT : VISU_MENU_BUTTON_INPUT_ENTRY_FALSE_TEXT
              this.label.alpha = this.label.text == VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT ? 1.0 : 0.3
            },
            onMouseReleasedLeft: function() {
              this.callback()
            },
          }
        }
      },
      {
        name: "developer_menu-button-input-entry_debug-render-surfaces",
        template: VisuComponents.get("menu-button-input-entry"),
        layout: VisuLayouts.get("menu-button-input-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.debug.render.surfaces", "Render debug surfaces"),
            callback: new BindIntent(function() {
              var value = Visu.settings.getValue("visu.debug.render-surfaces")
              Visu.settings.setValue("visu.debug.render-surfaces", !value).save()
              Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
            }),
            onMouseReleasedLeft: function() {
              this.callback()
            },
          },
          input: {
            label: { text: VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT },
            callback: function() {
              var value = Visu.settings.getValue("visu.debug.render-surfaces")
              Visu.settings.setValue("visu.debug.render-surfaces", !value).save()
              Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
            },
            updateCustom: function() {
              this.label.text = Visu.settings.getValue("visu.debug.render-surfaces") ? VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT : VISU_MENU_BUTTON_INPUT_ENTRY_FALSE_TEXT
              this.label.alpha = this.label.text == VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT ? 1.0 : 0.3
            },
            onMouseReleasedLeft: function() {
              this.callback()
            },
          }
        }
      },
      {
        name: "developer_menu-button-input-entry_ws",
        template: VisuComponents.get("menu-button-input-entry"),
        layout: VisuLayouts.get("menu-button-input-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.server.web-socket", "WebSocket"),
            callback: new BindIntent(function() {
              var value = false
              var controller = Beans.get(BeanVisuController)
              if (controller.server.isRunning()) {
                value = false
                controller.server.free()
              } else {
                value = true
                controller.server.run()
              }

              Visu.settings.setValue("visu.server.enable", value).save()
              controller.sfxService.play("menu-use-entry")
            }),
            onMouseReleasedLeft: function() {
              this.callback()
            },
          },
          input: {
            label: { text: VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT },
            callback: function() {
              var value = false
              var controller = Beans.get(BeanVisuController)
              if (controller.server.isRunning()) {
                value = false
                controller.server.free()
              } else {
                value = true
                controller.server.run()
              }

              Visu.settings.setValue("visu.server.enable", value).save()
              controller.sfxService.play("menu-use-entry")
            },
            updateCustom: function() {
              this.label.text = Beans.get(BeanVisuController).server.isRunning() ? VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT : VISU_MENU_BUTTON_INPUT_ENTRY_FALSE_TEXT
              this.label.alpha = this.label.text == VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT ? 1.0 : 0.3
            },
            onMouseReleasedLeft: function() {
              this.callback()
            },
          }
        }
      },
      {
        name: "developer_menu-button-input-entry_mouse-shoot",
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
            label: { text: VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT },
            callback: function() {
              var value = Visu.settings.getValue("visu.developer.mouse-shoot")
              Visu.settings.setValue("visu.developer.mouse-shoot", !value).save()
              Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
            },
            updateCustom: function() {
              this.label.text = Visu.settings.getValue("visu.developer.mouse-shoot") ? VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT : VISU_MENU_BUTTON_INPUT_ENTRY_FALSE_TEXT
              this.label.alpha = this.label.text == VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT ? 1.0 : 0.3
            },
            onMouseReleasedLeft: function() {
              this.callback()
            },
          }
        }
      },
      {
        name: "developer_menu-button-input-entry_visual-mode",
        template: VisuComponents.get("menu-button-input-entry"),
        layout: VisuLayouts.get("menu-button-input-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.visual-mode", "Visual only"),
            callback: new BindIntent(function() {
              var value = Visu.settings.getValue("visu.graphics.visual-mode")
              Visu.settings.setValue("visu.graphics.visual-mode", !value).save()
              Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
            }),
            onMouseReleasedLeft: function() {
              this.callback()
            },
          },
          input: {
            label: { text: VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT },
            callback: function() {
              var value = Visu.settings.getValue("visu.graphics.visual-mode")
              Visu.settings.setValue("visu.graphics.visual-mode", !value).save()
              Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
            },
            updateCustom: function() {
              this.label.text = Visu.settings.getValue("visu.graphics.visual-mode") ? VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT : VISU_MENU_BUTTON_INPUT_ENTRY_FALSE_TEXT
              this.label.alpha = this.label.text == VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT ? 1.0 : 0.3
            },
            onMouseReleasedLeft: function() {
              this.callback()
            },
          }
        }
      },
      {
        name: "developer_menu-button-input-entry_hide-quit",
        template: VisuComponents.get("menu-button-input-entry"),
        layout: VisuLayouts.get("menu-button-input-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.debug.quit.hidden"),
            callback: new BindIntent(function() {
              var value = Visu.settings.getValue("visu.debug.menu.quit.hidden")
              Visu.settings.setValue("visu.debug.menu.quit.hidden", !value).save()
              Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
            }),
            onMouseReleasedLeft: function() {
              this.callback()
            },
          },
          input: {
            label: { text: VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT },
            callback: function() {
              var value = Visu.settings.getValue("visu.debug.menu.quit.hidden")
              Visu.settings.setValue("visu.debug.menu.quit.hidden", !value).save()
              Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
            },
            updateCustom: function() {
              this.label.text = !Visu.settings.getValue("visu.debug.menu.quit.hidden") ? VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT : VISU_MENU_BUTTON_INPUT_ENTRY_FALSE_TEXT
              this.label.alpha = this.label.text == VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT ? 1.0 : 0.3
            },
            onMouseReleasedLeft: function() {
              this.callback()
            },
          }
        }
      },
      {
        name: "developer_menu-spin-select-entry_difficulty",
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
              text: Visu.settings.getValue("visu.difficulty")
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
        name: "developer_menu-button-entry_demo",
        template: VisuComponents.get("menu-button-entry"),
        layout: VisuLayouts.get("menu-button-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.demo", "Demo mode"),
            callback: new BindIntent(function() {
              VISU_MANIFEST_LOAD_ON_START_DISPATCHED = false
              VISU_FORCE_GOD_MODE_DISPATCHED = false
              VISU_BOOT_UP = false
              VISU_LOAD_PROPERTIES = false
              VISU_LOAD_SETTINGS = false
              VISU_PARSE_CLI = false
              //VISU_DISPLAY_SERVICE_SETUP = false

              var controller = Beans.get(BeanVisuController)
              controller.sfxService.play("menu-select-entry")
              controller.send(new Event("scene-close", {
                duration: 1.5,
                callback: function() {
                  var controller = Beans.get(BeanVisuController)
                  controller.sfxService.play("menu-use-entry")
                  controller.playerService.remove()
                  Scene.open("scene_visu", {
                    VisuController: {
                      initialState: {
                        name: "idle",
                        data: new Event("run-tests", Core.getProperty("visu.menu.demo.files", new Array(String))),
                      },
                    },
                  })
                },
              }))
              controller.menu.send(new Event("close", { fade: true }))
            }),
            callbackData: config,
            onMouseReleasedLeft: function() {
              this.callback()
            },
          },
        }
      },
      {
        name: "developer_menu-button-entry_restart",
        template: VisuComponents.get("menu-button-entry"),
        layout: VisuLayouts.get("menu-button-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.restart", "Restart game"),
            callback: new BindIntent(function() {
              VISU_MANIFEST_LOAD_ON_START_DISPATCHED = false
              VISU_FORCE_GOD_MODE_DISPATCHED = false
              VISU_BOOT_UP = false
              VISU_LOAD_PROPERTIES = false
              VISU_LOAD_SETTINGS = false
              VISU_PARSE_CLI = false
              //VISU_DISPLAY_SERVICE_SETUP = false

              var controller = Beans.get(BeanVisuController)
              controller.sfxService.play("menu-select-entry")
              controller.send(new Event("scene-close", {
                duration: 1.5,
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
              controller.menu.send(new Event("close", { fade: true }))
            }),
            callbackData: config,
            onMouseReleasedLeft: function() {
              this.callback()
            },
          },
        }
      },
      {
        name: "developer_menu-button-entry_back",
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

  var editorConstructor = Core.getConstructor("VisuEditorController")
  if (Optional.is(editorConstructor)) {
    event.data.content.add({
      name: "developer_menu-button-input-entry_editor",
      template: VisuComponents.get("menu-button-input-entry"),
      layout: VisuLayouts.get("menu-button-input-entry"),
      config: {
        layout: { type: UILayoutType.VERTICAL },
        label: { 
          text: Language.get("visu.menu.editor", "Editor"),
          callback: function() {
            Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
            var value = false
            var editorIOConstructor = Core.getConstructor(Visu.modules().editor.io)
            var editorControllerConstructor = Core.getConstructor(Visu.modules().editor.controller)
            if (!Optional.is(editorIOConstructor) || !Optional.is(editorControllerConstructor)) {
              return
            }
            
            if (Optional.is(Beans.get(Visu.modules().editor.io))) {
              Beans.kill(Visu.modules().editor.io)
              value = false
            } else {
              Beans.add(Beans.factory(Visu.modules().editor.io, GMServiceInstance, 
                Beans.get(BeanVisuController).layerId, new editorIOConstructor()))
              value = true
            }

            if (Optional.is(Beans.get(Visu.modules().editor.controller))) {
              Beans.kill(Visu.modules().editor.controller)
              value = false
            } else {
              Beans.add(Beans.factory(Visu.modules().editor.controller, GMServiceInstance, 
                Beans.get(BeanVisuController).layerId, new editorControllerConstructor()))
              value = true
              var editor = Beans.get(Visu.modules().editor.controller)
              if (Optional.is(editor)) {
                editor.send(new Event("open"))
              }
            }

            Visu.settings.setValue("visu.editor.enable", value).save()
          },
          onMouseReleasedLeft: function() {
            this.callback()
          },
        },
        input: {
          label: { text: EMPTY_STRING },
          updateCustom: function() {
            this.label.text = Optional.is(Beans.get(Visu.modules().editor.controller)) ? VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT : VISU_MENU_BUTTON_INPUT_ENTRY_FALSE_TEXT
            this.label.alpha = this.label.text == VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT ? 1.0 : 0.3
          },
          callback: function() {
            Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
            var value = false

            var editorIOConstructor = Core.getConstructor("VisuEditorIO")
            if (Optional.is(editorIOConstructor)) {
              if (Optional.is(Beans.get(Visu.modules().editor.io))) {
                Beans.kill(Visu.modules().editor.io)
                value = false
              } else {
                Beans.add(Beans.factory(Visu.modules().editor.io, GMServiceInstance, 
                  Beans.get(BeanVisuController).layerId, new editorIOConstructor()))
                value = true
              }
            }

            var editorConstructor = Core.getConstructor("VisuEditorController")
            if (Optional.is(editorConstructor)) {
              if (Optional.is(Beans.get(Visu.modules().editor.controller))) {
                Beans.kill(Visu.modules().editor.controller)
                value = false
              } else {
                Beans.add(Beans.factory(Visu.modules().editor.controller, GMServiceInstance, 
                  Beans.get(BeanVisuController).layerId, new editorConstructor()))
                value = true
                var editor = Beans.get(Visu.modules().editor.controller)
                if (Optional.is(editor)) {
                  editor.send(new Event("open"))
                }
              }
            }

            Visu.settings.setValue("visu.editor.enable", value).save()
          },
        }
      }
    }, 1)
  }

  return event
}