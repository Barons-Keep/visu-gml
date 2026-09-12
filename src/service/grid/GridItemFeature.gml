///@package io.alkapivo.visu.service.grid
show_debug_message("init GridItemFeature.gml")


///@param {Struct} json
function GridItemFeature(json) constructor {

  ///@type {String}
  type = "GridItemFeature"
  
  ///@type {?Array<GridItemCondition>}
  conditions = Struct.getIfType(json, "conditions", GMArray) != null
    ? GMArray.createGMArray(GMArray.size(json.conditions))
    : null
  if (this.conditions != null) {
    var size = GMArray.size(json.conditions)
    for (var idx = 0; idx < size; idx++) {
      conditions[idx] = new GridItemCondition(json.conditions[idx])
    }
  }

  ///@type {?Timer}
  timer = Struct.getIfType(json, "timer", Number) != null
    ? new Timer(json.timer, { loop: Infinity }) 
    : null

  ///@return {Boolean}
  static checkConditions = function(gridItem, controller) {
    gml_pragma("forceinline")
    if (this.conditions == null) {
      return true
    }

    var size = GMArray.size(this.conditions)
    for (var index = 0; index < size; index++) { 
      var condition = this.conditions[index]
      if (!condition.check(gridItem, controller)) {
        return false
      }
    }

    return true
  }

  ///@return {Boolean}
  static updateTimer = function() {
    gml_pragma("forceinline")
    return this.timer == null ? true : this.timer.update().finished
  }

  ///@param {GridItem} gridItem
  ///@param {VisuController} controller
  static update = function(gridItem, controller) { }
}
