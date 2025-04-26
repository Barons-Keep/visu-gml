///@package io.alkapivo.visu.service.grid.feature

///@param {Struct} json
///@return {GridItemFeature}
function FollowPlayerFeature(json = {}) {
  var data = Struct.map(Assert.isType(Struct
    .getDefault(json, "data", {}), Struct), GMArray
    .resolveRandom)
  
  if (Struct.contains(data, "value")) {
    data.value = Struct.map(data.value, GMArray.resolveRandom)
  }

  return new GridItemFeature(Struct.append(json, {

    ///@param {Callable}
    type: FollowPlayerFeature,

    ///@type {NumberTransformer}
    value: new NumberTransformer(data.value),


    ///@type {NumberTransformer}
    transformer: new NumberTransformer(),

    ///@override
    ///@param {GridItem} item
    ///@param {VisuController} controller
    update: function(item, controller) {
      var player = controller.playerService.player
      if (!Optional.is(player)) {
        return
      }

      ///@todo This will not work
      this.transformer.startValue = 0.0
      this.transformer.target = Math.fetchPointsAngleDiff(item.angle, Math.fetchPointsAngle(item.x, item.y, player.x, player.y))
      this.transformer.startFactor = abs(this.value.factor) * sign(this.transformer.target)
      this.transformer.reset()
      item.setAngle(item.angle - this.transformer.update().value)
    },
  }))
}