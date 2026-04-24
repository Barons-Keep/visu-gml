///@package fun.barons-keep.visu.ui.controller.menu

///@param {?Struct} [_config]
///@return {Event}
function factoryVisuMenuOpenConfirmEvent(_config = null) {
  var context = this
  var controller = Beans.get(BeanVisuController)
  var config = Struct.appendUnique(_config, {
    accept: function() { return new Event("game-end") },
    acceptLabel: Language.get("visu.menu.confirmation.accept"),
    decline: controller.menu.factories.get("menu-main"),
    declineLabel: Language.get("visu.menu.confirmation.decline"),
    message: Language.get("visu.menu.confirmation.message"), 
  })

  var event = new Event("open").setData({
    accept: config.accept,
    decline: config.decline,
    layout: controller.visuRenderer.layout,
    title: {
      name: "confirmation-dialog_title",
      template: VisuComponents.get("menu-title"),
      layout: VisuLayouts.get("menu-title"),
      config: {
        label: { 
          text: config.message,
        },
      },
    },
    content: new Array(Struct, [
      {
        name: "confirmation-dialog_menu-button-entry_accept",
        template: VisuComponents.get("menu-button-entry"),
        layout: VisuLayouts.get("menu-button-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: config.acceptLabel,
            callback: new BindIntent(function() {
              var controller = Beans.get(BeanVisuController)
              controller.sfxService.play("menu-select-entry")
              controller.menu.send(Callable.run(this.callbackData))
            }),
            callbackData: config.accept,
            onMouseReleasedLeft: function() {
              this.callback()
            },
          },
        }
      },
      {
        name: "confirmation-dialog_menu-button-entry_decline",
        template: VisuComponents.get("menu-button-entry"),
        layout: VisuLayouts.get("menu-button-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: config.declineLabel,
            callback: new BindIntent(function() {
              Beans.get(BeanVisuController).sfxService.play("menu-select-entry")
              Beans.get(BeanVisuController).menu.send(Callable.run(this.callbackData))
            }),
            callbackData: config.decline,
            onMouseReleasedLeft: function() {
              this.callback()
            },
            colorHoverOut: VisuTheme.color.deny,
          },
        }
      },
    ])
  })

  return event
}