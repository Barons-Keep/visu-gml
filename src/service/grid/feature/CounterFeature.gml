///@package io.alkapivo.visu.service.grid.feature

///@param {Struct} json 
function CounterFeature(json): GridItemFeature(json) constructor {
  var data = Struct.get(json, "data")
  
  ///@override
  ///@type {String}
  type = "CounterFeature"

  ///@type {String}
  field = Assert.isType(GMArray.resolveRandom(Struct.get(data, "field")), String, "field must be type of String")

  ///@type {Number}
  value = Core.getIfType(GMArray.resolveRandom(Struct.get(data, "value")), Number, 0.0)

  ///@type {Number}
  amount = Core.getIfType(GMArray.resolveRandom(Struct.get(data, "amount")), Number, 1.0)

  ///@type {Number}
  minValue = Core.getIfType(GMArray.resolveRandom(Struct.get(data, "minValue")), Number, 0.0)

  ///@type {Number}
  maxValue = Core.getIfType(GMArray.resolveRandom(Struct.get(data, "maxValue")), Number, 1.0)

  ///@override
  ///@param {GridItem} item
  ///@param {VisuController} controller
  static update = function(item, controller) {
    Struct.inject(item, this.field, this.value)
    this.value = clamp(Struct.get(item, this.field) + this.amount, this.minValue, this.maxValue)
    Struct.set(item, this.field, this.value)
  }
}

///@param {Struct} json
///@return {GridItemFeature}
function _CounterFeature(json = {}) {
  var data = Struct.map(Assert.isType(Struct
    .getDefault(json, "data", {}), Struct), GMArray
    .resolveRandom)
  
  return new GridItemFeature(Struct.append(json, {

    ///@param {Callable}
    type: CounterFeature,

    ///@type {Number}
    value: Assert.isType(Struct.getDefault(data, "value", 0), Number),

    ///@type {Number}
    amount: Assert.isType(Struct.getDefault(data, "amount", 1), Number),

    ///@type {Number}
    minValue: Assert.isType(Struct.getDefault(data, "minValue", 0), Number),

    ///@type {Number}
    maxValue: Assert.isType(Struct.getDefault(data, "maxValue", 1), Number),

    ///@type {String}
    field: Assert.isType(data.field, String),

    ///@override
    ///@param {GridItem} item
    ///@param {VisuController} controller
    update: function(item, controller) {
      Struct.inject(item, this.field, this.value)
      this.value = clamp(Struct.get(item, this.field) + this.amount, this.minValue, this.maxValue)
      Struct.set(item, this.field, this.value)
    },
  }))
}
