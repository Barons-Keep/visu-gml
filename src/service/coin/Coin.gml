///@package io.alkapivo.visu.service.coin
show_debug_message("init Coin.gml")

global.__CoinTemplateSpawn = {
  name: null,
  category: null,
  sprite: null,
  useSpeed: null,
  changeSpeed: null,
  mask: null,
  amount: null,
  x: null,
  y: null,
  angle: null,
  speed: null,
}
#macro CoinTemplateSpawn global.__CoinTemplateSpawn

function _CoinCategory(): Enum() constructor {
  FORCE = "force"
  POINT = "point"
  BOMB = "bomb"
  LIFE = "life"
}
global.__CoinCategory = new _CoinCategory()
#macro CoinCategory global.__CoinCategory


///@param {String} _name
///@param {Struct} json
function CoinTemplate(_name, json) constructor {

  ///@type {String}
  name = Assert.isType(_name, String,
    "CoinTemplate::name must be type of String")

  ///@type {CoinCategory}
  category = Assert.isEnum(json.category, CoinCategory,
    "CoinTemplate::category must be type of CoinCategory")

  ///@type {Struct}
  sprite = Assert.isType(json.sprite, Struct,
    "CoinTemplate::sprite must be type of Struct")

  ///@type {?Struct}
  mask = Struct.getIfType(json, "mask", Struct)

  ///@type {?Number}
  amount = Struct.getIfType(json, "amount", Number)

  ///@type {?Struct}
  speed = Struct.getIfType(json, "speed", Struct)

  ///@type {Boolean}
  useSpeed = Struct.getIfType(json, "useSpeed", Boolean, false)

  ///@type {Boolean}
  changeSpeed = Struct.getIfType(json, "changeSpeed", Boolean, false)

  //@return {Struct}
  serialize = function() {
    return {
      name: this.name,
      category: this.category,
      sprite: this.sprite,
      useSpeed: this.useSpeed,
      changeSpeed: this.changeSpeed,
      mask: this.mask,
      amount: this.amount,
      speed: this.speed,
    }
  }

  ///@param {Number} x
  ///@param {Number} y
  ///@param {?Number} [angle]
  ///@param {?Struct} [speed]
  serializeSpawn = function(x, y, angle = null, speed = null) {
    var speedConfig = this.speed
    var speedValue = this.useSpeed
      ? Struct.getDefault(speedConfig, "value", -3.0)
      : -3.0
    var _speed = this.changeSpeed
      ? {
        value: speedValue,
        target: Struct.getDefault(speedConfig, "target", 1.0),
        duration: Struct.getDefault(speedConfig, "duration", 0.6666667),
        ease: Struct.getDefault(speedConfig, "ease", EaseType.LINEAR),
      }
      : {
        value: speedValue,
        target: 1.0,
        duration: 0.6666667,
        ease: EaseType.LINEAR,
      }

    CoinTemplateSpawn.name = this.name
    CoinTemplateSpawn.category = this.category
    CoinTemplateSpawn.sprite = this.sprite
    CoinTemplateSpawn.useSpeed = this.useSpeed
    CoinTemplateSpawn.changeSpeed = this.changeSpeed
    CoinTemplateSpawn.mask = this.mask
    CoinTemplateSpawn.amount = this.amount
    CoinTemplateSpawn.x = x
    CoinTemplateSpawn.y = y
    CoinTemplateSpawn.angle = angle != null ? angle : 90.0
    CoinTemplateSpawn.speed = speed != null ? Struct.append(_speed, speed) : _speed

    return CoinTemplateSpawn
  }
}


///@param {Struct} config
function Coin(config) constructor {

  ///@type {CoinCategory}
  category = config.category

  ///@type {Number}
  x = config.x

  ///@type {Number}
  y = config.y

  ///@type {Number}
  z = 0.0

  ///@type {Sprite}
  sprite = SpriteUtil.parse(Struct.get(config, "sprite"), GRID_ITEM_DEFAULT_SPRITE)

  ///@type {Rectangle}
  mask = new Rectangle(Struct.get(config, "mask") != null 
    ? config.mask 
    : {
        x: 0,
        y: 0,
        width: this.sprite.getWidth(),
        height: this.sprite.getHeight(),
      })

  ///@type {Number}
  amount = Struct.getIfType(config, "amount", Number, 1)

  ///@type {Number}
  angle = Struct.getIfType(config, "angle", Number, 90.0)

  ///@type {?String}
  freeReason = "expired"

  ///@type {NumberTransformer}
  speed = new NumberTransformer(Struct.get(config, "speed"))

  ///@private
  ///@type {Boolean}
  simpleAngle = this.angle == 90.0
  
  ///@private
  ///@type {Boolean}
  magnet = false

  ///@private
  ///@type {Number}
  magnetSpeed = 0.0

  ///@param {Player} target
  ///@return {Boolean}
  static collide = function(target) {
    gml_pragma("forceinline")
    return Math.rectangleOverlaps(
      (this.x * GRID_SERVICE_PIXEL_WIDTH) - ((this.sprite.texture.width * this.sprite.scaleX) / 2.0) + (this.mask.x * this.sprite.scaleX),
      (this.y * GRID_SERVICE_PIXEL_HEIGHT) - ((this.sprite.texture.height * this.sprite.scaleY) / 2.0) + (this.mask.y * this.sprite.scaleY),
      this.mask.z * this.sprite.scaleX,
      this.mask.a * this.sprite.scaleY,
      (target.x * GRID_SERVICE_PIXEL_WIDTH) - ((target.sprite.texture.width * target.sprite.scaleX) / 2.0) + (target.mask.x * target.sprite.scaleX),
      (target.y * GRID_SERVICE_PIXEL_HEIGHT) - ((target.sprite.texture.height * target.sprite.scaleY) / 2.0) + (target.mask.y * target.sprite.scaleY),
      target.mask.z * target.sprite.scaleX,
      target.mask.a * target.sprite.scaleY
    )
  }

  ///@param {?Player} player
  ///@return {Coin}
  static move = function(player = null) {
    gml_pragma("forceinline")
    var value = (this.speed.update().value / 100.0)
    if (player != null && Math.fetchLength(this.x, this.y, player.x, player.y) < 0.5) {
      this.magnet = true
      this.magnetSpeed = clamp(this.magnetSpeed + DELTA_TIME * 0.000004, 0.0, 0.008)
      this.angle = Math.lerpAngle(this.angle, Math.fetchPointsAngle(this.x, this.y, player.x, player.y), 0.12)
      this.speed.value = (abs(value) * 100.0)
    } else {
      var dir = value < 0.0 ? 90.0 : 270.0
      this.magnetSpeed = clamp(this.magnetSpeed - DELTA_TIME * 0.0005, 0.0, 0.008)
      this.angle = this.simpleAngle && !this.magnet ? dir : Math.lerpAngle(this.angle, dir, 0.06)
    }

    value = DELTA_TIME * (abs(value) + this.magnetSpeed)
    this.x += Math.fetchCircleX(value, this.angle)
    this.y += Math.fetchCircleY(value, this.angle)

    return this
  }
}
