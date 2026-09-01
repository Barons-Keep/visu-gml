
///@package io.alkapivo.visu.editor.ui.component
show_debug_message("init VEButtonPropertyComponent.gml")


//@param {String} name
//@param {?Struct} [config]
function VEButtonPropertyComponent(name, config = null) {
  var input = Struct.get(config, "input")

  var hidden = Struct.get(config, "hidden")
  if (hidden != null) {
    Struct.set(input, "hidden", hidden)
  }
  
  var background = Struct.get(config, "background")
  if (background != null) {
    Struct.set(input, "backgroundColor", background)
  }

  var component = {
    name: name,
    template: VEComponents.get("property-button"),
    layout: VELayouts.get("property"),
    config: { 
      layout: { type: UILayoutType.VERTICAL },
      input: input,
    },
  }

  Core.print("buttonpropertycomponent")
  Core.print(component)
  return component
}
/** Template
VEButtonPropertyComponent("", {
  hidden: null,
  enable: null,
  background: null,
  input: {
    label: null,
    callback: null,
  },
})
*/
