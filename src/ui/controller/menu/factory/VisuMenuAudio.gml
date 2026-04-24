///@package fun.barons-keep.visu.ui.controller.menu


///@param {?Struct} [_config]
///@return {Event}
function factoryVisuMenuOpenAudioEvent(_config = null) {
  var controller = Beans.get(BeanVisuController)
  var config = Struct.appendUnique(_config, {
    back: controller.menu.factories.get("menu-settings"),
  })

  var event = new Event("open").setData({
    back: config.back,
    layout: controller.visuRenderer.layout,
    title: {
      name: "audio_title",
      template: VisuComponents.get("menu-title"),
      layout: VisuLayouts.get("menu-title"),
      config: {
        label: { 
          text: Language.get("visu.menu.audio", "Audio"),
        },
      },
    },
    content: new Array(Struct, [
      {
        name: "audio_menu-slider-entry_ost-volume",
        template: VisuComponents.get("menu-slider-entry"),
        layout: VisuLayouts.get("menu-slider-entry"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: Language.get("visu.menu.ost.volume", "OST volume"),
          },
          slider: {
            value: round(Visu.settings.getValue("visu.audio.ost-volume") * 100.0),
            minValue: 0.0,
            maxValue: 100.0,
            snapValue: 1.0,
            updatePosition: function(mouseX, mouseY) {
              this.callback()
            },
            callback: function() {
              var value = round(Visu.settings.getValue("visu.audio.ost-volume") * 100.0)
              if (this.value == value) {
                return
              }

              Visu.settings.setValue("visu.audio.ost-volume", this.value / 100.0).save()
              playCleanSFX("menu-move-cursor")
            },
            postRender: factoryPostRenderVisuMenuSliderEntryPercentage(),
          },
        },
      },
      {
        name: "audio_menu-slider-entry_sfx-volume",
        template: VisuComponents.get("menu-slider-entry"),
        layout: VisuLayouts.get("menu-slider-entry"),
        config: { 
          layout: { type: UILayoutType.VERTICAL },
          label: {
            text: Language.get("visu.menu.sfx.volume", "SFX volume"),
          },
          slider: {
            value: round(Visu.settings.getValue("visu.audio.sfx-volume") * 100.0),
            minValue: 0.0,
            maxValue: 100.0,
            snapValue: 1.0,
            updatePosition: function(mouseX, mouseY) {
              this.callback()
            },
            callback: function() {
              var value = round(Visu.settings.getValue("visu.audio.sfx-volume") * 100.0)
              if (this.value == value) {
                return
              }

              Visu.settings.setValue("visu.audio.sfx-volume", this.value / 100.0).save()
              playCleanSFX("menu-move-cursor")
            },
            postRender: factoryPostRenderVisuMenuSliderEntryPercentage(),
          },
        },
      },
      {
        name: "audio_menu-button-entry_back",
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