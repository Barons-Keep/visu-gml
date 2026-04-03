///@package io.alkapivo.visu.service.grid.feature

function FactFeature(json): GridItemFeature(json) constructor {
  var data = Struct.get(json, "data")

  ///@override
  ///@type {String}
  type = "FactFeature"

  ///@type {String}
  key = Assert.isType(Struct.get(data, "key"), String, "key must be type of String")

  ///@type {Boolean}
  value = Struct.getIfType(data, "value", Boolean, false)

  ///@override
  ///@param {GridItem} item
  ///@param {VisuController} controller
  static update = function(item, controller) {
    controller.setFact(this.key, this.value)
  }
}