///@package io.alkapivo.visu.service.grid
show_debug_message("init GridItemCondition.gml")


///@static
///@type {Struct}
global.__VISU_GRID_CONDITIONS = {
  "kill": function(shroom, controller, context) {
    return shroom.signals.kill
  },
  "damage": function(shroom, controller, context) {
    return shroom.signals.damage
  },
  "boolean": function(item, controller, context) {
    return Struct.inject(item, context.data.field, false) == context.data.value
  },
  "logic-gate": function(item, controller, context) {
    var a = Struct.get(item, context.data.fieldA)
    var b = Struct.get(item, context.data.fieldB)
    switch (context.data.operator) {
      case "and": return a && b
      case "or": return a || b
      case "not": return !a
      case "nor": return !(a || b)
      case "nand": return !(a && b)
      case "xor": return (a || b) && !(a && b)
      case "xnor": return (a && b) || (!a && !b)
      default: throw new Exception($"Found unsupported operator for 'logic-gate': {context.data.operator}")
    }
  },
  "fact": function(item, controller, context) {
    return controller.getFact(context.data.fact) == Struct.getIfType(context.data, "value", Boolean, true)
  },
  "fact-logic-gate": function(item, controller, context) {
    var a = controller.getFact(context.data.factA)
    var b = controller.getFact(context.data.factB)
    switch (context.data.operator) {
      case "and": return a && b
      case "or": return a || b
      case "not": return !a
      case "nor": return !(a || b)
      case "nand": return !(a && b)
      case "xor": return (a || b) && !(a && b)
      case "xnor": return (a && b) || (!a && !b)
      default: throw new Exception($"Found unsupported operator for 'fact-logic-gate': {context.data.operator}")
    }
  },
  "numeric": function(item, controller, context) {
    var value = Struct.get(item, context.data.field)
    switch (context.data.operator) {
      case "equal": return context.data.value == value
      case "greater": return context.data.value > value
      case "greaterOrEqual": return context.data.value >= value
      case "less": return context.data.value < value
      case "lessOrEqual": return context.data.value <= value
      default: throw new Exception($"Found unsupported operator for 'numeric': {context.data.operator}")
    }
  },
  "lifespan": function(item, controller, context) {
    var value = context.data.value
    switch (context.data.operator) {
      case "equal": return item.lifespan == value
      case "greater": return item.lifespan > value
      case "less": return item.lifespan < value
      case "greaterOrEqual": return item.lifespan >= value
      case "lessOrEqual": return item.lifespan <= value
      default: throw new Exception($"Found unsupported operator for 'lifespan': {context.data.operator}")
    }
  },
  "speed": function(item, controller, context) {
    var value = context.data.value
    switch (context.data.operator) {
      case "equal": return item.speed * 1000 == value
      case "greater": return item.speed * 1000 > value
      case "less": return item.speed * 1000 < value
      case "greaterOrEqual": return item.speed * 1000 >= value
      case "lessOrEqual": return item.speed * 1000 <= value
      default: throw new Exception($"Found unsupported operator for 'speed': {context.data.operator}")
    }
  },
  "player-distance": function(item, controller, context) {
    var player = controller.playerService.player
    if (player == null) {
      return false
    }

    var length = Math.fetchLength(item.x, item.y, player.x, player.y)
    var value = context.data.value
    switch (context.data.operator) {
      case "equal": return value == length
      case "greater": return value > length
      case "less": return value < length
      case "greaterOrEqual": return value >= length
      case "lessOrEqual": return value <= length
      default: throw new Exception($"Found unsupported operator for 'player-distance'")
    }
  },
  "player-collision": function(item, controller, context) {
    return item.signals.playerCollision
  },
  "bullet-collision": function(item, controller, context) {
    return item.signals.bulletCollision
  },
}
#macro VISU_GRID_CONDITIONS global.__VISU_GRID_CONDITIONS


///@param {Struct} json
function GridItemCondition(json) constructor {

  ///@type {String}
  type = Assert.isType(json.type, String,
    "GridItemCondition::type must be type of String")

  ///@type {any}
  data = Struct.get(json, "data")

  ///@param {GridItem} item
  ///@param {VisuController} controller
  ///@return {Boolean}
  check = Assert.isType(Struct.get(VISU_GRID_CONDITIONS, this.type), Callable,
    "GridItemCondition::check must be type of Callable")
}
