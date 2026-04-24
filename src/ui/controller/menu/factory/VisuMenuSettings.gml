///@package fun.barons-keep.visu.ui.controller.menu

///@param {?Struct} [_config]
///@return {Event}
function factoryVisuMenuOpenSettingsEvent(_config = null) {
  var controller = Beans.get(BeanVisuController)
  var config = Struct.appendUnique(_config, {
    graphics: controller.menu.factories.get("menu-graphics"),
    audio: controller.menu.factories.get("menu-audio"),
    gameplay: controller.menu.factories.get("menu-gameplay"),
    controls: controller.menu.factories.get("menu-controls"),
    developer: controller.menu.factories.get("menu-developer"),
    back:  controller.menu.factories.get("menu-main"),
  })

  var event = new Event("open").setData({
    back: config.back,
    layout: controller.visuRenderer.layout,
    title: {
      name: "settings_title",
      template: VisuComponents.get("menu-title"),
      layout: VisuLayouts.get("menu-title"),
      config: {
        label: { 
          text: Language.get("visu.menu.settings", "Settings"),
        },
      },
    },
    content: new Array(Struct, [
      {
        name: "settings_menu-button-entry_graphics",
        template: VisuComponents.get("menu-button-entry"),
        layout: VisuLayouts.get("menu-button-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.graphics", "Graphics"),
            callback: new BindIntent(function() {
              Beans.get(BeanVisuController).sfxService.play("menu-select-entry")
              Beans.get(BeanVisuController).menu.send(Callable.run(this.callbackData))
            }),
            callbackData: config.graphics,
            onMouseReleasedLeft: function() {
              this.callback()
            },
          },
        }
      },
      {
        name: "settings_menu-button-entry_audio",
        template: VisuComponents.get("menu-button-entry"),
        layout: VisuLayouts.get("menu-button-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.audio", "Audio"),
            callback: new BindIntent(function() {
              Beans.get(BeanVisuController).sfxService.play("menu-select-entry")
              Beans.get(BeanVisuController).menu.send(Callable.run(this.callbackData))
            }),
            callbackData: config.audio,
            onMouseReleasedLeft: function() {
              this.callback()
            },
          },
        }
      },
      {
        name: "settings_menu-button-entry_gameplay",
        template: VisuComponents.get("menu-button-entry"),
        layout: VisuLayouts.get("menu-button-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.gameplay", "Gameplay"),
            callback: new BindIntent(function() {
              Beans.get(BeanVisuController).sfxService.play("menu-select-entry")
              Beans.get(BeanVisuController).menu.send(Callable.run(this.callbackData))
            }),
            callbackData: config.gameplay,
            onMouseReleasedLeft: function() {
              this.callback()
            },
          },
        }
      },
      {
        name: "settings_menu-button-entry_controls",
        template: VisuComponents.get("menu-button-entry"),
        layout: VisuLayouts.get("menu-button-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.controls", "Controls"),
            callback: new BindIntent(function() {
              Beans.get(BeanVisuController).sfxService.play("menu-select-entry")
              Beans.get(BeanVisuController).menu.send(Callable.run(this.callbackData))
            }),
            callbackData: config.controls,
            onMouseReleasedLeft: function() {
              this.callback()
            },
          },
        }
      },
      {
        name: "settings_menu-button-entry_developer",
        template: VisuComponents.get("menu-button-entry"),
        layout: VisuLayouts.get("menu-button-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.developer", "Developer"),
            callback: new BindIntent(function() {
              Beans.get(BeanVisuController).sfxService.play("menu-select-entry")
              Beans.get(BeanVisuController).menu.send(Callable.run(this.callbackData))
            }),
            callbackData: config.developer,
            onMouseReleasedLeft: function() {
              this.callback()
            },
          },
        }
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