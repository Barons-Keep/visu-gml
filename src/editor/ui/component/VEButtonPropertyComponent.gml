
///@package io.alkapivo.visu.editor.ui.component
show_debug_message("init VEButtonPropertyComponent.gml")


//@param {String} name
//@param {?Struct} [config]
function VEButtonPropertyComponent(name, config = null) {
  var button = Struct.get(config, "button")

  var hidden = Struct.get(config, "hidden")
  if (hidden != null) {
    Struct.set(button, "hidden", hidden)
  }

  var enable = Struct.get(config, "enable")
  if (enable != null) {
    Struct.set(button, "enable", enable)
  }
  
  var background = Struct.get(config, "background")
  if (background != null) {
    Struct.set(button, "backgroundColor", background)
    Struct.set(button, "backgroundColorOut", background)
  }

  var backgroundHover = Struct.get(config, "backgroundHover")
  if (backgroundHover != null) {
    Struct.set(button, "backgroundColorSelected", backgroundHover)
  }

  var component = {
    name: name,
    template: VEComponents.get("property-button"),
    layout: VELayouts.get("property-button"),
    config: { 
      layout: { type: UILayoutType.VERTICAL },
      button: button,
    },
  }

  return component
}
/** Template
VEButtonPropertyComponent("", {
  hidden: null,
  enable: null,
  background: null,
  backgroundHover: null,
  button: {
    label: null,
    callback: null,
  },
})
*/
