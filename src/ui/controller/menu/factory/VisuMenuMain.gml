///@package fun.barons-keep.visu.ui.controller.menu

///@param {?Struct} [_config]
///@return {Event}
function factoryVisuMenuOpenMainEvent(_config = null) {
  var controller = Beans.get(BeanVisuController)
  var dialogueDesignerService = Beans.get(BeanDialogueDesignerService)
  var config = Struct.appendUnique(_config, {
    back: controller.menu.factories.get("menu-main"),
    quit: controller.menu.factories.get("menu-confirm"),
    titleLabel: Language.get("visu.menu.title"),
    disableResume: controller.trackService.isTrackLoaded()
      && !controller.trackService.track.audio.isLoaded() 
      && 1 > abs(controller.trackService.time - controller.trackService.duration),
    isTrackLoaded: controller.trackService.isTrackLoaded(),
    isGameOver: controller.fsm.getStateName() == "game-over",
  })

  var event = new Event("open").setData({
    back: null,
    isMainMenu: true,
    layout: controller.visuRenderer.layout,
    title: {
      name: "main-menu_title",
      template: VisuComponents.get("menu-title"),
      layout: VisuLayouts.get("menu-title"),
      config: {
        label: { 
          text: config.titleLabel,
        },
      },
    },
    content: new Array(Struct, [
      {
        name: "main-menu_menu-button-entry_settings",
        template: VisuComponents.get("menu-button-entry"),
        layout: VisuLayouts.get("menu-button-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.options"),
            callback: new BindIntent(function() {
              var controller = Beans.get(BeanVisuController)
              var factory = controller.menu.factories.get("menu-settings")
              controller.menu.send(factory(this.callbackData))
              controller.sfxService.play("menu-select-entry")
            }),
            callbackData: config,
            onMouseReleasedLeft: function() {
              this.callback()
            },
          },
        }
      },
      {
        name: "main-menu_menu-button-entry_credits",
        template: VisuComponents.get("menu-button-entry"),
        layout: VisuLayouts.get("menu-button-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.credits", "Credits"),
            callback: new BindIntent(function() {
              var controller = Beans.get(BeanVisuController)
              var factory = controller.menu.factories.get("menu-credits")
              controller.menu.send(factory(this.callbackData))
              controller.sfxService.play("menu-select-entry")
            }),
            callbackData: config,
            onMouseReleasedLeft: function() {
              this.callback()
            },
          },
        }
      },
    ])
  })

  var menuState = config.isGameOver
    ? "game-over"
    : (config.isTrackLoaded ? "in-game" : "main-menu")
  
  var counter = 0
  switch (menuState) {
    case "in-game":
      if (!config.disableResume) {
        event.data.content.add({
          name: "main-menu_menu-button-entry_resume",
          template: VisuComponents.get("menu-button-entry"),
          layout: VisuLayouts.get("menu-button-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: Language.get("visu.menu.resume", "Resume"),
              callback: new BindIntent(function() {
                var controller = Beans.get(BeanVisuController)
                controller.fsm.transition("play")
                controller.sfxService.play("menu-select-entry")
              }),
              callbackData: config,
              onMouseReleasedLeft: function() {
                this.callback()
              },
            },
          }
        }, counter)
        counter++
      } else {
        event.data.title.config.label.text = Language.get("visu.menu.finish")
        if (dialogueDesignerService.dialog != null) {
          event.data.content.add({
            name: "main-menu_menu-button-entry_continue_story",
            template: VisuComponents.get("menu-button-entry"),
            layout: VisuLayouts.get("menu-button-entry"),
            config: {
              layout: { type: UILayoutType.VERTICAL },
              label: { 
                text: Language.get("visu.menu.continue-story"),
                callback: new BindIntent(function() {
                  var controller = Beans.get(BeanVisuController)
                  if (controller.ostSound != null) {
                    controller.ostSound.stop()
                    controller.ostSound = null
                  }
                  Beans.get(BeanSoundService).free(GMArray.toMap(VISU_SFX_AUDIO_NAMES, String, Boolean, Lambda.returnTrue, null, Lambda.passthrough))
                  audio_stop_all()

                  controller.menu.send(new Event("close", { fade: true }))
                  controller.loader.fsm.transition("clear-state")
                  controller.fsm.transition("idle")
                  controller.trackService.dispatcher.execute(new Event("close-track"))
                  controller.sfxService.play("menu-select-entry")
                  controller.visuRenderer.gridRenderer.clear()
                  //Beans.get(BeanTextureService).free()
                }),
                callbackData: config,
                onMouseReleasedLeft: function() {
                  this.callback()
                },
              },
            }
          }, counter)
          counter++
        }
      }

      if (dialogueDesignerService.dialog == null) {
        event.data.content.add({
          name: "main-menu_menu-button-entry_retry",
          template: VisuComponents.get("menu-button-entry"),
          layout: VisuLayouts.get("menu-button-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: Language.get("visu.menu.retry"),
              callback: new BindIntent(function() {
                var controller = Beans.get(BeanVisuController)
                controller.sfxService.play("menu-select-entry")
                controller.menu.send(Callable
                  .run(this.callbackData.quit, {
                    back: this.callbackData.back,
                    accept: function() {
                      var controller = Beans.get(BeanVisuController)
                      controller.send(new Event("scene-close", {
                        duration: 1.5,
                        event: new Event("load", {
                          manifest: $"{controller.track.path}manifest.visu",
                          autoplay: true,
                        }),
                        callback: function() {
                          var controller = Beans.get(BeanVisuController)
                          Assert.isType(controller.track, VisuTrack, "VisuController.track must be type of VisuTrack")
                          controller.send(this.event)
                          controller.sfxService.play("menu-use-entry")
                        },
                      }))
                      return new Event("close", { fade: true })
                    },
                    decline: this.callbackData.back,
                  }))
              }),
              callbackData: config,
              onMouseReleasedLeft: function() {
                this.callback()
              },
            },
          }
        }, counter)
        counter++
      }

      event.data.content.add({
        name: "main-menu_menu-button-entry_restart",
        template: VisuComponents.get("menu-button-entry"),
        layout: VisuLayouts.get("menu-button-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.title.main-menu", "Main menu"),
            callback: new BindIntent(function() {
              var controller = Beans.get(BeanVisuController)
              controller.sfxService.play("menu-select-entry")
              controller.menu.send(Callable
                .run(this.callbackData.quit, {
                  back: this.callbackData.back,
                  accept: function() {
                    Beans.get(BeanVisuController).send(new Event("scene-close", {
                      duration: 1.5,
                      callback: function() {
                        var controller = Beans.get(BeanVisuController)
                        controller.playerService.remove()
                        controller.sfxService.play("menu-use-entry")
                        Scene.open("scene_visu", {
                          VisuController: {
                            initialState: { name: "idle" },
                          },
                        })
                      },
                    }))
                    return new Event("close", { fade: true })
                  },
                  decline: this.callbackData.back,
                }))
            }),
            callbackData: config,
            onMouseReleasedLeft: function() {
              this.callback()
            },
          },
        }
      }, counter)
      counter++
      break
    case "main-menu":
      event.data.content.add({
        name: "main-menu_menu-button-entry_play",
        template: VisuComponents.get("menu-button-entry"),
        layout: VisuLayouts.get("menu-button-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.play"),
            callback: new BindIntent(function() {
              var controller = Beans.get(BeanVisuController)
              var factory = controller.menu.factories.get("menu-node")
              var root = Core.getProperty("visu.menu.play.root", "root.tracks")
              controller.menu.send(factory(root))
              controller.sfxService.play("menu-select-entry")
            }),
            callbackData: config,
            onMouseReleasedLeft: function() {
              this.callback()
            },
          },
        }
      }, counter)
      counter++

      if (Core.getProperty("visu.story.dialog") != null) {
        event.data.content.add({
          name: "main-menu_menu-button-entry_story",
          template: VisuComponents.get("menu-button-entry"),
          layout: VisuLayouts.get("menu-button-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: Language.get("visu.menu.story"),
              callback: new BindIntent(function() {
                var controller = Beans.get(BeanVisuController)
                var factory = controller.menu.factories.get("menu-story")
                controller.menu.send(factory(this.callbackData))
                controller.sfxService.play("menu-select-entry")
              }),
              callbackData: config,
              onMouseReleasedLeft: function() {
                this.callback()
              },
            },
          }
        }, counter)
        counter++
      }
      break
    case "game-over":
      var editor = Beans.get(Visu.modules().editor.controller)
      event.data.content.add({
        name: "main-menu_menu-button-entry_continue",
        template: VisuComponents.get("menu-button-entry"),
        layout: VisuLayouts.get("menu-button-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.continue"),
            callback: new BindIntent(function() {
              var controller = Beans.get(BeanVisuController)
              controller.menu.dispatcher.execute(new Event("close"))
              controller.fsm.transition("play")
              controller.sfxService.play("menu-select-entry")

              var player = controller.playerService.player
              if (player != null) {
                player.stats.life.set(4.0)
                return
              }

              var editor = Beans.get(BeanVisuEditorController)
              if (editor != null) {
                editor.renderUI = true
                editor.send(new Event("open"))
                return
              }
            }),
            callbackData: config,
            onMouseReleasedLeft: function() {
              this.callback()
            },
          },
        }
      }, counter)
      counter++

      if (dialogueDesignerService.dialog == null) {
        event.data.content.add({
          name: "main-menu_menu-button-entry_retry",
          template: VisuComponents.get("menu-button-entry"),
          layout: VisuLayouts.get("menu-button-entry"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            label: { 
              text: Language.get("visu.menu.retry"),
              callback: new BindIntent(function() {
                var controller = Beans.get(BeanVisuController)
                controller.playerService.remove()
                controller.sfxService.play("menu-select-entry")
                controller.menu.send(new Event("close", { fade: true }))
                controller.dispatcher.execute(new Event("scene-close", {
                  duration: 1.5,
                  event: new Event("load", {
                    manifest: $"{controller.track.path}manifest.visu",
                    autoplay: true,
                  }),
                  callback: function() {
                    var controller = Beans.get(BeanVisuController)
                    Assert.isType(controller.track, VisuTrack, "VisuController.track must be type of VisuTrack")
                    controller.send(this.event)
                    controller.sfxService.play("menu-use-entry")
                  },
                }))
              }),
              callbackData: config,
              onMouseReleasedLeft: function() {
                this.callback()
              },
            },
          }
        }, counter)
        counter++
      }

      event.data.content.add({
        name: "main-menu_menu-button-entry_restart",
        template: VisuComponents.get("menu-button-entry"),
        layout: VisuLayouts.get("menu-button-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.title.main-menu", "Main menu"),
            callback: new BindIntent(function() {
              var controller = Beans.get(BeanVisuController)
              controller.sfxService.play("menu-select-entry")
              controller.send(new Event("scene-close", {
                duration: 1.5,
                callback: function() {
                  var controller = Beans.get(BeanVisuController)
                  controller.playerService.remove()
                  controller.sfxService.play("menu-use-entry")
                  Scene.open("scene_visu", {
                    VisuController: {
                      initialState: { name: "idle" },
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
      }, counter)
      counter++
      break
  }

  
  if (Core.getRuntimeType() != RuntimeType.GXGAMES
      && !Visu.settings.getValue("visu.debug.menu.quit.hidden")) {
    event.data.content.add({
      name: "main-menu_menu-button-entry_quit",
      template: VisuComponents.get("menu-button-entry"),
      layout: VisuLayouts.get("menu-button-entry"),
      config: {
        layout: { type: UILayoutType.VERTICAL },
        label: { 
          text: Language.get("visu.menu.quit", "Quit"),
          callback: new BindIntent(function() {
            Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
            Beans.get(BeanVisuController).menu.send(Callable
              .run(this.callbackData.quit, { back: this.callbackData.back }))
          }),
          callbackData: config,
          onMouseReleasedLeft: function() {
            this.callback()
          },
          colorHoverOut: VisuTheme.color.deny,
        },
      }
    })
  }

  return event
}