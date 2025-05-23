///@package com.alkapivo.visu.service.grid.GridItem

///@param {?Struct} [json]
///@param {Boolean} [useScale]
function GridItemMovement(json = null, _useScale = true) constructor {
  
  ///@todo Make it deprecated
  ///@type {Boolean}
  useScale = _useScale

  ///@type {Number}
  speed = Struct.getIfType(json, "speed", Number, 0.0) / (this.useScale ? 100.0 : 1.0)
  
  ///@type {Number}
  speedMax = Struct.getIfType(json, "speedMax", Number, 2.1) / (this.useScale ? 100.0 : 1.0)

  ///@type {Number}
  speedMaxFocus = Struct.getIfType(json, "speedMaxFocus", Number, 0.66) / (this.useScale ? 100.0 : 1.0)
  
  ///@type {Number}
  acceleration = Struct.getIfType(json, "acceleration", Number, 1.92) / (this.useScale ? 1000.0 : 1.0)
  
  ///@type {Number}
  friction = Struct.getIfType(json, "friction", Number, 9.3) / (this.useScale ? 10000.0 : 1.0)

  ///@return {Struct}
  serialize = function() {
    return {
      speed: this.speed * (this.useScale ? 100.0 : 1.0),
      speedMax: this.speedMax * (this.useScale ? 100.0 : 1.0),
      acceleration: this.acceleration * (this.useScale ? 1000.0 : 1.0),
      friction: this.friction * (this.useScale ? 10000.0 : 1.0),
    }
  }
}


function GridItemSignals() constructor {
  
  ///@type {Boolean}
  kill = false

  ///@type {Boolean}
  damage = false
  
  ///@type {?GridItem}
  bulletCollision = null
  
  ///@type {?GridItem}
  shroomCollision = null
  
  ///@type {?GridItem}
  playerCollision = null

  ///@type {Boolean}
  playerLanded = false

  ///@type {Boolean}
  playerLeave = false

  ///@param {String} key
  ///@param {any} value
  ///@return {GridItemSignals}
  static set = function(key, value) {
    gml_pragma("forceinline")
    Struct.set(this, key, value)
    return this
  }

  ///@return {GridItemSignals}
  static reset = function() {
    gml_pragma("forceinline")
    //this.kill = false
    this.damage = false
    this.bulletCollision = null
    this.shroomCollision = null
    this.playerCollision = null
    this.playerLanded = false
    this.playerLeave = false
    return this
  }
}

global.__GRID_ITEM_DEFAULT_SPRITE = { name: "texture_missing" }
#macro GRID_ITEM_DEFAULT_SPRITE global.__GRID_ITEM_DEFAULT_SPRITE

///@interface
///@param {Struct} [config]
///@return {GridItem}
function GridItem(config = {}) constructor {

  ///@type {String}
  uid = Assert.isType(config.uid, String, "GridItem.uid must be type of String")

  ///@type {Number}
  x = Assert.isType(Struct.get(config, "x"), Number, "GridItem.x must be type of Number")

  ///@type {Number}
  y = Assert.isType(Struct.get(config, "y"), Number, "GridItem.y must be type of Number")

  ///@type {Number}
  z = Struct.getIfType(config, "z", Number, 0.0)

  ///@type {Sprite}
  sprite = SpriteUtil.parse(Struct.get(config, "sprite"), GRID_ITEM_DEFAULT_SPRITE)

  ///@type {Rectangle}
  mask = Core.isType(Struct.get(config, "mask"), Struct)
    ? new Rectangle(config.mask)
    : new Rectangle({ 
      x: 0, 
      y: 0, 
      width: this.sprite.getWidth(), 
      height: this.sprite.getHeight()
  })

  ///@type {Number}
  speed = Struct.getIfType(config, "speed", Number, 0.0)

  ///@type {Number}
  angle = Struct.getIfType(config, "angle", Number, 0.0)

  ///@type {Number}
  lifespan = Struct.getIfType(config, "lifespan", Number, 0.0)

  ///@type {GridItemSignals}
  signals = new GridItemSignals()

  ///@type {Map<String, GridItemGameMode>}
  gameModes = new Map(String, GridItemGameMode)
  
  ///@type {?GridItemGameMode}
  gameMode = null

  ///@type {Number}
  fadeIn = 0.0

  ///@type {Number}
  fadeInFactor = 0.03

  ///@type {?Struct}
  chunkPosition = Struct.getIfType(config, "chunkPosition", Struct)
    
  ///@param {Number} angle
  ///@return {GridItem}
  static setAngle = function(angle) {
    gml_pragma("forceinline")
    this.angle = angle
    return this
  }

  ///@param {Number} speed
  ///@return {GridItem}
  static setSpeed = function(speed) {
    gml_pragma("forceinline")
    if (speed > 0) {
      this.speed = speed
    }
    return this
  }

  ///@param {Sprite} sprite
  ///@return {GridItem}
  static setSprite = function(sprite) {
    gml_pragma("forceinline")
    this.sprite = sprite
    return this
  }

  ///@param {Rectangle} mask
  ///@return {GridItem}
  static setMask = function(mask) {
    gml_pragma("forceinline")
    this.mask = mask
    return this
  }

  ///@param {GameMode} mode
  ///@return {GridItem}
  static updateGameMode = function(mode) {
    gml_pragma("forceinline")
    this.gameMode = this.gameModes.get(mode)
    this.gameMode.onStart(this, Beans.get(BeanVisuController))
    return this
  }

  ///@param {any} name
  ///@param {any} [value]
  ///@return {GridItem}
  static signal = function(name, value = true) {
    gml_pragma("forceinline")
    this.signals.set(name, value)
    return this
  }

  ///@param {GridItem} target
  ///@return {Bollean} collide?
  static collide = function(target) {
    gml_pragma("forceinline")
    var halfSourceWidth = (this.mask.z * this.sprite.scaleX) / 2.0
    var halfSourceHeight = (this.mask.a * this.sprite.scaleY) / 2.0
    var halfTargetWidth = (target.mask.z * target.sprite.scaleX) / 2.0
    var halfTargetHeight = (target.mask.a * target.sprite.scaleY) / 2.0
    var sourceX = this.x * GRID_SERVICE_PIXEL_WIDTH
    var sourceY = this.y * GRID_SERVICE_PIXEL_HEIGHT
    var targetX = target.x * GRID_SERVICE_PIXEL_WIDTH
    var targetY = target.y * GRID_SERVICE_PIXEL_HEIGHT
    return Math.rectangleOverlaps(
      sourceX - halfSourceWidth, sourceY - halfSourceHeight,
      sourceX + halfSourceWidth, sourceY + halfSourceHeight,
      targetX - halfTargetWidth, targetY - halfTargetHeight,
      targetX + halfTargetWidth, targetY + halfTargetHeight
    )
  }

  ///@param {VisuController} controller
  ///@return {GridItem}
  static move = function() {
    gml_pragma("forceinline")
    this.signals.reset()
    this.x += Math.fetchCircleX(DeltaTime.apply(this.speed), this.angle)
    this.y += Math.fetchCircleY(DeltaTime.apply(this.speed), this.angle)
    return this
  }

  ///@param {VisuController} controller
  ///@return {GridItem}
  static update = function(controller) { 
    gml_pragma("forceinline")
    if (this.gameMode != null) {
      gameMode.update(this, controller)
    }

    if (this.fadeIn < 1.0) {
      this.fadeIn = clamp(this.fadeIn + this.fadeInFactor, 0.0, 1.0)
    }

    return this
  }
}
