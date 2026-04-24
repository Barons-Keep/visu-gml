///@package fun.barons-keep.visu.ui.controller.menu

///@param {String} nodeName
///@return {Event}
function factoryVisuMenuOpenNodeEvent(nodeName) {
  var controller = Beans.get(BeanVisuController)
  var node = controller.menu.nodes.get(nodeName)
  if (!Core.isType(node, VisuMenuNode)) {
    var factory = controller.menu.factories.get("menu-main")
    return factory()
  }

  var back = Core.isType(controller.menu.nodes.get(node.back), VisuMenuNode)
    ? controller.menu.factories.get("menu-node")
    : controller.menu.factories.get("menu-main")
  var backData = back == controller.menu.factories.get("menu-node")
    ? node.back
    : null,
  var event = new Event("open").setData({
    back: back,
    backData: backData,
    layout: controller.visuRenderer.layout,
    title: {
      name: $"{nodeName}_title",
      template: VisuComponents.get("menu-title"),
      layout: VisuLayouts.get("menu-title"),
      config: {
        label: { 
          text: Language.get(node.title),
        },
      },
    },
    content: new Array(Struct, node.entries
      .map(function(entry, index, nodeName) {
        return {
          name: $"{nodeName}_menu-button-entry-title_{index}",
          template: VisuComponents.get("menu-button-entry-title"),
          layout: VisuLayouts.get("menu-button-entry-title"),
          config: {
            layout: { type: UILayoutType.VERTICAL },
            title: {
              text: Language.get(entry.title),
              callback: new BindIntent(function() {
                var controller = Beans.get(BeanVisuController)
                var menu = controller.menu
                var event = this.callbackData
                var factoryMain = controller.menu.factories.get("menu-main")
                var factoryNode = controller.menu.factories.get("menu-node")
                var factoryTrackSetup = controller.menu.factories.get("menu-track-setup")
                switch (event.type) {
                  case VisuMenuEntryEventType.OPEN_NODE:
                    menu.send(Core.isType(menu.nodes.get(event.data.node), VisuMenuNode)
                      ? factoryNode()
                      : factoryMain())
                    controller.sfxService.play("menu-select-entry")
                    break
                  case VisuMenuEntryEventType.OPEN_TRACK_SETUP:
                    if (!Optional.is(Struct.getIfType(event.data, "title", String))) {
                      Struct.set(event.data, "title", this.text)
                    }

                    menu.send(factoryTrackSetup(event.data))
                    controller.sfxService.play("menu-select-entry")
                    break
                  case VisuMenuEntryEventType.LOAD_TRACK:
                    controller.send(new Event("load", {
                      manifest: $"{working_directory}{event.data.path}",
                      autoplay: true,
                    }))
                    controller.sfxService.play("menu-select-entry")
                    break
                  default:
                    throw new Exception("VisuMenuEntryEventType does not support '{this.event.type}'")
                }
              }),
              callbackData: entry.event,
              onMouseReleasedLeft: function() {
                this.callback()
              },
            },
            label: { 
              text: Language.get(entry.name),
              callback: new BindIntent(function() {
                var controller = Beans.get(BeanVisuController)
                var menu = controller.menu
                var event = this.callbackData
                var factoryMain = controller.menu.factories.get("menu-main")
                var factoryNode = controller.menu.factories.get("menu-node")
                var factoryTrackSetup = controller.menu.factories.get("menu-track-setup")
                switch (event.type) {
                  case VisuMenuEntryEventType.OPEN_NODE:
                    menu.send(Core.isType(menu.nodes.get(event.data.node), VisuMenuNode)
                      ? factoryNode()
                      : factoryMain())
                    controller.sfxService.play("menu-select-entry")
                    break
                  case VisuMenuEntryEventType.OPEN_TRACK_SETUP:
                    if (!Optional.is(Struct.getIfType(event.data, "title", String))) {
                      Struct.set(event.data, "title", this.text)
                    }

                    menu.send(factoryTrackSetup(event.data))
                    controller.sfxService.play("menu-select-entry")
                    break
                  case VisuMenuEntryEventType.LOAD_TRACK:
                    controller.send(new Event("load", {
                      manifest: $"{working_directory}{event.data.path}",
                      autoplay: true,
                    }))
                    controller.sfxService.play("menu-select-entry")
                    break
                  default:
                    throw new Exception("VisuMenuEntryEventType does not support '{this.event.type}'")
                }
              }),
              callbackData: entry.event,
              onMouseReleasedLeft: function() {
                this.callback()
              },
            },
          }
        }
      }, nodeName, Struct)
      .add(
        {
          name: $"{nodeName}_menu-button-entry_back",
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
              callbackData: node.back,
              onMouseReleasedLeft: function() {
                this.callback()
              },
              colorHoverOut: VisuTheme.color.deny,
            },
          }
        }
      ).getContainer()
    ),
  })

  return event
}