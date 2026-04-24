///@package fun.barons-keep.visu.ui.controller.menu

///@param {?Struct} [_config]
///@return {Event}
function factoryVisuMenuOpenGraphicsEvent(_config = null) {
  var controller = Beans.get(BeanVisuController)
  var config = Struct.appendUnique(_config, {
    back: controller.menu.factories.get("menu-settings"),
  })

  var event = new Event("open").setData({
    back: config.back,
    layout: controller.visuRenderer.layout,
    title: {
      name: "graphics_title",
      template: VisuComponents.get("menu-title"),
      layout: VisuLayouts.get("menu-title"),
      config: {
        label: { 
          text: Language.get("visu.menu.graphics"),
        },
      },
    },
    content: new Array(Struct, [
      factoryMenuButtonEntryTitle("graphics_menu-button-input-entry_title", Language.get("visu.menu.settings.display")),
      {
        name: "graphics_menu-button-input-entry_vsync",
        template: VisuComponents.get("menu-button-input-entry"),
        layout: VisuLayouts.get("menu-button-input-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.vsync", "VSync"),
            callback: new BindIntent(function() {
              var value = Visu.settings.getValue("visu.graphics.vsync")
              Visu.settings.setValue("visu.graphics.vsync", !value).save()
              display_reset(Visu.settings.getValue("visu.graphics.aa"), Visu.settings.getValue("visu.graphics.vsync"))
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
              var value = Visu.settings.getValue("visu.graphics.vsync")
              Visu.settings.setValue("visu.graphics.vsync", !value).save()
              display_reset(Visu.settings.getValue("visu.graphics.aa"), Visu.settings.getValue("visu.graphics.vsync"))
              Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
            },
            updateCustom: function() {
              this.label.text = Visu.settings.getValue("visu.graphics.vsync") ? VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT : VISU_MENU_BUTTON_INPUT_ENTRY_FALSE_TEXT
              this.label.alpha = this.label.text == VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT ? 1.0 : 0.3
            },
            onMouseReleasedLeft: function() {
              this.callback()
            },
          }
        }
      },
      {
        name: "graphics_menu-spin-select-entry_timing",
        template: VisuComponents.get("menu-spin-select-entry"),
        layout: VisuLayouts.get("menu-spin-select-entry"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: Language.get("visu.menu.timing", "Timing"),
          },
          previous: { 
            callback: function() {
              var map = new Map(String, Number)
                .set(TimingMethod.getKey(TimingMethod.COUNTSYNC), 0)
                .set(TimingMethod.getKey(TimingMethod.COUNTSYNC_WINALT), 1)
                .set(TimingMethod.getKey(TimingMethod.SLEEP), 2)
                .set(TimingMethod.getKey(TimingMethod.SYSTEMTIMING), 3)
              var pointer = map.getDefault(Visu.settings.getValue("visu.graphics.timing-method"), 0)
              var target = clamp(int64(pointer - 1), -1, 4)
              target = target == -1 ? 3 : (target == 4 ? 0 : target)
              var value = map.findKey(Lambda.equal, target)

              if (!Optional.is(value)) {
                return
              }

              Visu.settings.setValue("visu.graphics.timing-method", value).save()
              var controller = Beans.get(BeanVisuController)
              var timingMethod = TimingMethod.get(Visu.settings.getValue("visu.graphics.timing-method"))
              Beans.get(BeanDisplayService).setTimingMethod(timingMethod)
              display_reset(display_aa, Visu.settings.getValue("visu.graphics.vsync", true))
              controller.sfxService.play("menu-use-entry")
            },
          },
          preview: {
            label: {
              text: Visu.settings.getValue("visu.graphics.timing-method"),
            },
            updateCustom: function() { 
              this.label.text = Visu.settings.getValue("visu.graphics.timing-method")
            },
          },
          next: { 
            callback: function() {
              var map = new Map(String, Number)
                .set(TimingMethod.getKey(TimingMethod.COUNTSYNC), 0)
                .set(TimingMethod.getKey(TimingMethod.COUNTSYNC_WINALT), 1)
                .set(TimingMethod.getKey(TimingMethod.SLEEP), 2)
                .set(TimingMethod.getKey(TimingMethod.SYSTEMTIMING), 3)
              var pointer = map.getDefault(Visu.settings.getValue("visu.graphics.timing-method"), 0)
              var target = clamp(int64(pointer + 1), -1, 4)
              target = target == -1 ? 3 : (target == 4 ? 0 : target)
              var value = map.findKey(Lambda.equal, target)

              if (!Optional.is(value)) {
                return
              }

              Visu.settings.setValue("visu.graphics.timing-method", value).save()
              var controller = Beans.get(BeanVisuController)
              var timingMethod = TimingMethod.get(Visu.settings.getValue("visu.graphics.timing-method"))
              Beans.get(BeanDisplayService).setTimingMethod(timingMethod)
              display_reset(display_aa, Visu.settings.getValue("visu.graphics.vsync", true))
              controller.sfxService.play("menu-use-entry")
            },
          },
        },
      },
      {
        name: "graphics_menu-slider-entry_scale-gui",
        template: VisuComponents.get("menu-slider-entry"),
        layout: VisuLayouts.get("menu-slider-entry"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: Language.get("visu.menu.gui-scale", "GUI scale"),
          },
          slider: {
            value: round(Visu.settings.getValue("visu.interface.scale") * 100.0),
            minValue: 50.0,
            maxValue: 400.0,
            snapValue: 5.0,
            updatePosition: function(mouseX, mouseY) {
              this.callback()
            },
            callback: function() {
              var value = round(Struct.getIfType(this.context, "scaleIntent", Number, Visu.settings.getValue("visu.interface.scale")) * 100.0)
              if (this.value == value) {
                return
              }

              //Visu.settings.setValue("visu.interface.scale", this.value / 100.0).save()
              Struct.set(this.context, "scaleIntent", this.value / 100.0)
              playCleanSFX("menu-move-cursor")
            },
            postRender: factoryPostRenderVisuMenuSliderEntryPercentage(),
          },
        },
      },
      {
        name: "graphics_menu-button-entry_apply",
        template: VisuComponents.get("menu-button-entry"),
        layout: VisuLayouts.get("menu-button-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.gui-scale.apply"),
            callback: new BindIntent(function() {
              Beans.get(BeanVisuController).sfxService.play("menu-select-entry")

              var scaleIntent = Struct.getIfType(this.context, "scaleIntent", Number, Visu.settings.getValue("visu.interface.scale"))
              Visu.settings.setValue("visu.interface.scale", scaleIntent).save()
              Beans.get(BeanDisplayService).scale = scaleIntent
              Beans.get(BeanDisplayService).state = "required"
              Beans.get(BeanDisplayService).timer.reset().finish()

              Beans.get(BeanVisuController).visuRenderer.fadeTimer.reset().time = -0.33
            }),
            callbackData: config.back,
            onMouseReleasedLeft: function() {
              this.callback()
            },
            preRender: function() {
              var scale = Struct.getIfType(this.context, "scaleIntent", Number, Visu.settings.getValue("visu.interface.scale"))
              var displayService = Beans.get(BeanDisplayService)
              var width = Math.getEvenCeil(displayService.getWidth() / scale)
              var height = Math.getEvenCeil(displayService.getHeight() / scale)
              var label = Language.get("visu.menu.gui-scale.apply")
              this.label.text = $"{label} [ {width} x {height} ]"
            }
          },
        }
      },
      factoryMenuButtonEntryTitle("graphics_menu-button-input-entry_effect", Language.get("visu.menu.settings.effect")),
      {
        name: "graphics_menu-button-input-entry_bkt-glitch",
        template: VisuComponents.get("menu-button-input-entry"),
        layout: VisuLayouts.get("menu-button-input-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.glitch-effects", "Glitch effects"),
            callback: new BindIntent(function() {
              var value = Visu.settings.getValue("visu.graphics.bkt-glitch")
              Visu.settings.setValue("visu.graphics.bkt-glitch", !value).save()
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
              var value = Visu.settings.getValue("visu.graphics.bkt-glitch")
              Visu.settings.setValue("visu.graphics.bkt-glitch", !value).save()
              Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
            },
            updateCustom: function() {
              this.label.text = Visu.settings.getValue("visu.graphics.bkt-glitch") ? VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT : VISU_MENU_BUTTON_INPUT_ENTRY_FALSE_TEXT
              this.label.alpha = this.label.text == VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT ? 1.0 : 0.3
            },
            onMouseReleasedLeft: function() {
              this.callback()
            },
          }
        }
      },
      {
        name: "graphics_menu-button-input-entry_particle",
        template: VisuComponents.get("menu-button-input-entry"),
        layout: VisuLayouts.get("menu-button-input-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.particles", "Particles"),
            callback: new BindIntent(function() {
              var value = Visu.settings.getValue("visu.graphics.particle")
              Visu.settings.setValue("visu.graphics.particle", !value).save()
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
              var value = Visu.settings.getValue("visu.graphics.particle")
              Visu.settings.setValue("visu.graphics.particle", !value).save()
              Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
            },
            updateCustom: function() {
              this.label.text = Visu.settings.getValue("visu.graphics.particle") ? VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT : VISU_MENU_BUTTON_INPUT_ENTRY_FALSE_TEXT
              this.label.alpha = this.label.text == VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT ? 1.0 : 0.3
            },
            onMouseReleasedLeft: function() {
              this.callback()
            },
          }
        }
      },
      {
        name: "graphics_menu-button-input-entry_bkg-tx",
        template: VisuComponents.get("menu-button-input-entry"),
        layout: VisuLayouts.get("menu-button-input-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.bkg.tx", "Background textures"),
            callback: new BindIntent(function() {
              var value = Visu.settings.getValue("visu.graphics.bkg-tx")
              Visu.settings.setValue("visu.graphics.bkg-tx", !value).save()
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
              var value = Visu.settings.getValue("visu.graphics.bkg-tx")
              Visu.settings.setValue("visu.graphics.bkg-tx", !value).save()
              Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
            },
            updateCustom: function() {
              this.label.text = Visu.settings.getValue("visu.graphics.bkg-tx") ? VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT : VISU_MENU_BUTTON_INPUT_ENTRY_FALSE_TEXT
              this.label.alpha = this.label.text == VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT ? 1.0 : 0.3
            },
            onMouseReleasedLeft: function() {
              this.callback()
            },
          }
        }
      },
      {
        name: "graphics_menu-button-input-entry_frg-tx",
        template: VisuComponents.get("menu-button-input-entry"),
        layout: VisuLayouts.get("menu-button-input-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.frg.tx", "Foreground textures"),
            callback: new BindIntent(function() {
              var value = Visu.settings.getValue("visu.graphics.frg-tx")
              Visu.settings.setValue("visu.graphics.frg-tx", !value).save()
              Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
            }),
            onMouseReleasedLeft: function() {
              this.callback()
            },
          },
          input: {
            label: { text: VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT },
            callback: function() {
              var value = Visu.settings.getValue("visu.graphics.frg-tx")
              Visu.settings.setValue("visu.graphics.frg-tx", !value).save()
              Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
            },
            updateCustom: function() {
              this.label.text = Visu.settings.getValue("visu.graphics.frg-tx") ? VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT : VISU_MENU_BUTTON_INPUT_ENTRY_FALSE_TEXT
              this.label.alpha = this.label.text == VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT ? 1.0 : 0.3
            },
            onMouseReleasedLeft: function() {
              this.callback()
            },
          }
        }
      },
      factoryMenuButtonEntryTitle("graphics_menu-button-input-entry_shader", Language.get("visu.menu.settings.shader")),
      {
        name: "graphics_menu-button-input-entry_bkg-shaders",
        template: VisuComponents.get("menu-button-input-entry"),
        layout: VisuLayouts.get("menu-button-input-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.bkg.shd", "Background shaders"),
            callback: new BindIntent(function() {
              var value = Visu.settings.getValue("visu.graphics.bkg-shaders")
              Visu.settings.setValue("visu.graphics.bkg-shaders", !value).save()
              Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
            }),
            onMouseReleasedLeft: function() {
              this.callback()
            },
          },
          input: {
            label: { text: VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT },
            callback: function() {
              var value = Visu.settings.getValue("visu.graphics.bkg-shaders")
              Visu.settings.setValue("visu.graphics.bkg-shaders", !value).save()
              Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
            },
            updateCustom: function() {
              this.label.text = Visu.settings.getValue("visu.graphics.bkg-shaders") ? VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT : VISU_MENU_BUTTON_INPUT_ENTRY_FALSE_TEXT
              this.label.alpha = this.label.text == VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT ? 1.0 : 0.3
            },
            onMouseReleasedLeft: function() {
              this.callback()
            },
          }
        }
      },
      {
        name: "graphics_menu-button-input-entry_main-shaders",
        template: VisuComponents.get("menu-button-input-entry"),
        layout: VisuLayouts.get("menu-button-input-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.grid.shd", "Grid shaders"),
            callback: new BindIntent(function() {
              var value = Visu.settings.getValue("visu.graphics.main-shaders")
              Visu.settings.setValue("visu.graphics.main-shaders", !value).save()
              Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
            }),
            onMouseReleasedLeft: function() {
              this.callback()
            },
          },
          input: {
            label: { text: VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT },
            callback: function() {
              var value = Visu.settings.getValue("visu.graphics.main-shaders")
              Visu.settings.setValue("visu.graphics.main-shaders", !value).save()
              Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
            },
            updateCustom: function() {
              this.label.text = Visu.settings.getValue("visu.graphics.main-shaders") ? VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT : VISU_MENU_BUTTON_INPUT_ENTRY_FALSE_TEXT
              this.label.alpha = this.label.text == VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT ? 1.0 : 0.3
            },
            onMouseReleasedLeft: function() {
              this.callback()
            },
          }
        }
      },
      {
        name: "graphics_menu-button-input-entry_combined-shaders",
        template: VisuComponents.get("menu-button-input-entry"),
        layout: VisuLayouts.get("menu-button-input-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.combined.shd", "Combined shaders"),
            callback: new BindIntent(function() {
              var value = Visu.settings.getValue("visu.graphics.combined-shaders")
              Visu.settings.setValue("visu.graphics.combined-shaders", !value).save()
              Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
            }),
            onMouseReleasedLeft: function() {
              this.callback()
            },
          },
          input: {
            label: { text: VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT },
            callback: function() {
              var value = Visu.settings.getValue("visu.graphics.combined-shaders")
              Visu.settings.setValue("visu.graphics.combined-shaders", !value).save()
              Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
            },
            updateCustom: function() {
              this.label.text = Visu.settings.getValue("visu.graphics.combined-shaders") ? VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT : VISU_MENU_BUTTON_INPUT_ENTRY_FALSE_TEXT
              this.label.alpha = this.label.text == VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT ? 1.0 : 0.3
            },
            onMouseReleasedLeft: function() {
              this.callback()
            },
          }
        }
      },
      {
        name: "graphics_menu-slider-entry_shaders-limit",
        template: VisuComponents.get("menu-slider-entry"),
        layout: VisuLayouts.get("menu-slider-entry"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: Language.get("visu.menu.max-sim-shd", "Max simultaneous shaders"),
          },
          slider: {
            value: round(Visu.settings.getValue("visu.graphics.shaders-limit")),
            minValue: 0.0,
            maxValue: DEFAULT_SHADER_PIPELINE_LIMIT,
            snapValue: 1.0,
            updatePosition: function(mouseX, mouseY) {
              this.callback()
            },
            callback: function() {
              var value = round(Visu.settings.getValue("visu.graphics.shaders-limit"))
              if (this.value == value) {
                return
              }

              Visu.settings.setValue("visu.graphics.shaders-limit", this.value).save()
              playCleanSFX("menu-move-cursor")
            },
            postRender: factoryPostRenderVisuMenuSliderEntry(),
          },
        },
      },
      {
        name: "graphics_menu-slider-entry_shader-quality",
        template: VisuComponents.get("menu-slider-entry"),
        layout: VisuLayouts.get("menu-slider-entry"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: Language.get("visu.menu.shader-quality", "Shaders quality"),
          },
          slider: {
            value: round(Visu.settings.getValue("visu.graphics.shader-quality") * 100.0),
            minValue: 1.0,
            maxValue: 100.0,
            snapValue: 1.0,
            updatePosition: function(mouseX, mouseY) {
              this.callback()
            },
            callback: function() {
              var value = round(Visu.settings.getValue("visu.graphics.shader-quality") * 100.0)
              if (this.value == value) {
                return
              }

              Visu.settings.setValue("visu.graphics.shader-quality", this.value / 100.0).save()
              playCleanSFX("menu-move-cursor")
            },
            postRender: factoryPostRenderVisuMenuSliderEntryPercentage(),
          },
        },
      },
      {
        name: "graphics_menu-button-entry_back",
        template: VisuComponents.get("menu-button-entry"),
        layout: VisuLayouts.get("menu-button-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.back"),
            callback: new BindIntent(function() {
              Beans.get(BeanVisuController).menu.send(Callable.run(this.callbackData))
              Beans.get(BeanVisuController).sfxService.play("menu-select-entry")
              Struct.set(this.context, "scaleIntent", Visu.settings.getValue("visu.interface.scale"))
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

  if (Core.getRuntimeType() != RuntimeType.GXGAMES) {
    event.data.content
      .add({
        name: "graphics_menu-button-input-entry_fullscreen",
        template: VisuComponents.get("menu-button-input-entry"),
        layout: VisuLayouts.get("menu-button-input-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.fullscreen", "Fullscreen"),
            callback: new BindIntent(function() {
              var controller = Beans.get(BeanVisuController)
              var fullscreen = Beans.get(BeanDisplayService).getFullscreen()
              Beans.get(BeanDisplayService).setFullscreen(!fullscreen)
              Visu.settings.setValue("visu.fullscreen", !fullscreen).save()
              Beans.get(BeanVisuController).sfxService.play("menu-use-entry")

              if (fullscreen && Visu.settings.getValue("visu.borderless-window")) {
                Beans.get(BeanDisplayService).center()
              }
            }),
            onMouseReleasedLeft: function() {
              this.callback()
            },
          },
          input: {
            label: { text: EMPTY_STRING },
            callback: function() {
              var controller = Beans.get(BeanVisuController)
              var fullscreen = Beans.get(BeanDisplayService).getFullscreen()
              Beans.get(BeanDisplayService).setFullscreen(!fullscreen)
              Visu.settings.setValue("visu.fullscreen", !fullscreen).save()
              Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
              if (fullscreen && Visu.settings.getValue("visu.borderless-window")) {
                Beans.get(BeanDisplayService).center()
              }
            },
            updateCustom: function() {
              this.label.text = Beans.get(BeanDisplayService).getFullscreen() ? VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT : VISU_MENU_BUTTON_INPUT_ENTRY_FALSE_TEXT
              this.label.alpha = this.label.text == VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT ? 1.0 : 0.3
            },
            onMouseReleasedLeft: function() {
              this.callback()
            },
          }
        }
      }, 1)
      .add({
        name: "graphics_menu-button-input-entry_borderless_window",
        template: VisuComponents.get("menu-button-input-entry"),
        layout: VisuLayouts.get("menu-button-input-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.borderless-window", "Borderless window"),
            callback: new BindIntent(function() {
              var controller = Beans.get(BeanVisuController)
              var borderlessWindow = Beans.get(BeanDisplayService).getBorderlessWindow()
              Beans.get(BeanDisplayService).setBorderlessWindow(!borderlessWindow)
              Visu.settings.setValue("visu.borderless-window", !borderlessWindow).save()
              Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
            }),
            onMouseReleasedLeft: function() {
              this.callback()
            },
          },
          input: {
            label: { text: EMPTY_STRING },
            callback: function() {
              var controller = Beans.get(BeanVisuController)
              var borderlessWindow = Beans.get(BeanDisplayService).getBorderlessWindow()
              Beans.get(BeanDisplayService).setBorderlessWindow(!borderlessWindow)
              Visu.settings.setValue("visu.borderless-window", !borderlessWindow).save()
              Beans.get(BeanVisuController).sfxService.play("menu-use-entry")
            },
            updateCustom: function() {
              this.label.text = Beans.get(BeanDisplayService).getBorderlessWindow() ? VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT : VISU_MENU_BUTTON_INPUT_ENTRY_FALSE_TEXT
              this.label.alpha = this.label.text == VISU_MENU_BUTTON_INPUT_ENTRY_TRUE_TEXT ? 1.0 : 0.3
            },
            onMouseReleasedLeft: function() {
              this.callback()
            },
          }
        }
      }, 2)
  }

  return event
}