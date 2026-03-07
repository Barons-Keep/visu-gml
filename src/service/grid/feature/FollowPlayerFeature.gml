///@package io.alkapivo.visu.service.grid.feature

///@param {Struct} json
function FollowPlayerFeature(json): GridItemFeature(json) constructor {
  var data = Struct.get(json, "data")

  ///@override
  ///@type {String}
  type = "FollowPlayerFeature"

  ///@type {NumberTransformer}
  factor = new NumberTransformer(Struct.get(data, "factor"))

  ///@override
  ///@param {GridItem} item
  ///@param {VisuController} controller
  static update = function(item, controller) {
    var player = controller.playerService.player
    if (player == null) {
      return
    }

    var angle = Math.fetchPointsAngleDiff(item.angle, Math.fetchPointsAngle(item.x, item.y, player.x, player.y))
    item.setAngle(item.angle - (angle * this.factor.update().value))
  }
}
