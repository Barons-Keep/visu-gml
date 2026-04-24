///@package fun.barons-keep.visu.ui.controller.menu

///@param {?Struct} [_config]
///@return {Event}
function factoryVisuMenuOpenStoryEvent(_config = null) {
  var controller = Beans.get(BeanVisuController)
  var config = Struct.appendUnique(_config, {
    back: controller.menu.factories.get("menu-main"),
  })

  var event = new Event("open").setData({
    back: config.back,
    layout: controller.visuRenderer.layout,
    title: {
      name: "open-story_title",
      template: VisuComponents.get("menu-title"),
      layout: VisuLayouts.get("menu-title"),
      config: {
        label: { 
          text: Language.get("visu.menu.select-difficulty"),
        },
      },
    },
    content: new Array(Struct, [
      {
        name: "open-story_difficulty-easy_menu-button-entry",
        template: VisuComponents.get("menu-button-entry"),
        layout: VisuLayouts.get("menu-button-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.difficulty.easy"),
            callback: new BindIntent(function() {
              Visu.settings.setValue("visu.difficulty", Difficulty.EASY)
                .save()
              Beans.get(BeanVisuController).menu.dispatcher
                .execute(new Event("close", { fade: true }))
              Beans.get(BeanDialogueDesignerService)
                .open(Core.getProperty("visu.story.dialog")).facts
                .clear()
            }),
            callbackData: config.back,
            onMouseReleasedLeft: function() {
              this.callback()
            },
          },
        }
      },
      {
        name: "open-story_difficulty-normal_menu-button-entry",
        template: VisuComponents.get("menu-button-entry"),
        layout: VisuLayouts.get("menu-button-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.difficulty.normal"),
            callback: new BindIntent(function() {
              Visu.settings.setValue("visu.difficulty", Difficulty.NORMAL)
                .save()
              Beans.get(BeanVisuController).menu.dispatcher
                .execute(new Event("close", { fade: true }))
              Beans.get(BeanDialogueDesignerService)
                .open(Core.getProperty("visu.story.dialog")).facts
                .clear()
            }),
            callbackData: config.back,
            onMouseReleasedLeft: function() {
              this.callback()
            },
          },
        }
      },
      {
        name: "open-story_difficulty-hard_menu-button-entry",
        template: VisuComponents.get("menu-button-entry"),
        layout: VisuLayouts.get("menu-button-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.difficulty.hard"),
            callback: new BindIntent(function() {
              Visu.settings.setValue("visu.difficulty", Difficulty.HARD)
                .save()
              Beans.get(BeanVisuController).menu.dispatcher
                .execute(new Event("close", { fade: true }))
              Beans.get(BeanDialogueDesignerService)
                .open(Core.getProperty("visu.story.dialog")).facts
                .clear()
            }),
            callbackData: config.back,
            onMouseReleasedLeft: function() {
              this.callback()
            },
          },
        }
      },
      {
        name: "open-story_difficulty-lunatic_menu-button-entry",
        template: VisuComponents.get("menu-button-entry"),
        layout: VisuLayouts.get("menu-button-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.difficulty.lunatic"),
            callback: new BindIntent(function() {
              Visu.settings.setValue("visu.difficulty", Difficulty.LUNATIC)
                .save()
              Beans.get(BeanVisuController).menu.dispatcher
                .execute(new Event("close", { fade: true }))
              Beans.get(BeanDialogueDesignerService)
                .open(Core.getProperty("visu.story.dialog")).facts
                .clear()
            }),
            callbackData: config.back,
            onMouseReleasedLeft: function() {
              this.callback()
            },
          },
        }
      },
      {
        name: "open-story_menu-button-entry_back",
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