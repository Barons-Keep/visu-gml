///@package com.alkapivo.visu.service.grid.GridItem
show_debug_message("init GridItem.gml")


///@type {Struct}
global.__GRID_ITEM_DEFAULT_SPRITE = { name: "texture_missing" }
#macro GRID_ITEM_DEFAULT_SPRITE global.__GRID_ITEM_DEFAULT_SPRITE

///@type {Number}
#macro GRID_ITEM_SPEED_SCALE 1000.0

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

  ///@type {?String}
  freeReason = null

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
    this.damage = false
    this.bulletCollision = null
    this.shroomCollision = null
    this.playerCollision = null
    return this
  }
}


///@param {?Struct} [json]
///@param {Boolean} [useScale]
function GridItemMovement(json = null) constructor {
  
  ///@type {Number}
  speed = Struct.getIfType(json, "speed", Number, 0.0) / 100.0
  
  ///@type {Number}
  speedMax = Struct.getIfType(json, "speedMax", Number, 2.1) / 100.0

  ///@type {Number}
  speedMaxFocus = Struct.getIfType(json, "speedMaxFocus", Number, 0.66) / 100.0
  
  ///@type {Number}
  acceleration = Struct.getIfType(json, "acceleration", Number, 1.92) / GRID_ITEM_SPEED_SCALE
  
  ///@type {Number}
  friction = Struct.getIfType(json, "friction", Number, 9.3) / 10000.0

  ///@return {Struct}
  serialize = function() {
    return {
      speed: this.speed * 100.0,
      speedMax: this.speedMax * 100.0,
      acceleration: this.acceleration * GRID_ITEM_SPEED_SCALE,
      friction: this.friction * 10000.0,
    }
  }
}


///@param {?Struct} [json]
function GridItemEmitter(json = null) constructor {
  
  ///@type {Number}
  x = Struct.getIfType(json, "x", Number, 0)

  ///@type {Number}
  y = Struct.getIfType(json, "y", Number, 0)

  ///@type {Number}
  amount = Struct.getIfType(json, "amount", Number, 1)

  ///@type {Transformer}
  arrays = Struct.getIfType(json, "arrays", Struct)
    ? new NumberTransformer(json.arrays)
    : new Transformer(Struct.getDefault(json, "arrays", 1.0))

  ///@type {Transformer}
  angle = Struct.getIfType(json, "angle", Struct)
    ? new NumberTransformer(json.angle)
    : new Transformer(Struct.getDefault(json, "angle", 0.0))

  ///@type {Number}
  angleRng = Struct.getIfType(json, "angleRng", Number, 0.0)

  ///@type {Transformer}
  angleStep = Struct.getIfType(json, "angleStep", Struct)
    ? new NumberTransformer(json.angleStep)
    : new Transformer(Struct.getDefault(json, "angleStep", 0.0))

  ///@type {Number}
  perArray = Struct.getIfType(json, "perArray", Number, 1)

  ///@type {Number}
  anglePerArray = Struct.getIfType(json, "anglePerArray", Number, 0.)

  ///@type {Number}
  anglePerArrayRng = Struct.getIfType(json, "anglePerArrayRng", Number, 0.0)

  ///@type {Number}
  anglePerArrayStep = Struct.getIfType(json, "anglePerArrayStep", Number, 0.0)
  
  ///@type {NumberTransformer}
  speed = Struct.getIfType(json, "speed", Struct)
    ? new NumberTransformer(json.speed)
    : new Transformer(Struct.getDefault(json, "speed", 1.0))

  ///@type {Number}
  speedRng = Struct.getIfType(json, "speedRng", Number, 0.0)

  ///@type {Number}
  duration = Struct.getIfType(json, "duration", Number, 0)

  ///@type {Number}
  interval = this.amount <= 1 ? this.duration : (this.duration / (this.amount - 1))

  ///@type {NumberTransformer}
  offset = Struct.getIfType(json, "offset", Struct)
    ? new NumberTransformer(json.offset)
    : new Transformer(Struct.getDefault(json, "offset", 0.0))

  ///@type {NumberTransformer}
  offsetX = Struct.getIfType(json, "offsetX", Struct)
    ? new NumberTransformer(json.offsetX)
    : new Transformer(Struct.getDefault(json, "offsetX", 0.0))

  ///@type {NumberTransformer}
  offsetY = Struct.getIfType(json, "offsetY", Struct)
    ? new NumberTransformer(json.offsetY)
    : new Transformer(Struct.getDefault(json, "offsetY", 0.0))

  ///@type {Number}
  wiggleFrequency = Struct.getIfType(json, "wiggleFrequency", Number, 1.0)

  ///@type {NumberTransformer}
  wiggleAmplitude = Struct.getIfType(json, "wiggleAmplitude", Struct)
    ? new NumberTransformer(json.wiggleAmplitude)
    : new Transformer(Struct.getDefault(json, "wiggleAmplitude", 0.0))

  ///@type {any}
  state = Struct.get(json, "state")

  ///@type {Number}
  emitted = 0

  ///@type {Number}
  time = this.interval

  ///@type {Number}
  timeSum = 0.0

  ///@type {?Callable} function(item, controller, emitter)
  preCallback = Callable.get(Struct.get(json, "preCallback"), Struct.getIfType(json, "preCallback", Callable))

  ///@type {?Callable} function(item, controller, emitter, idx, arrIdx, x, y, angle, speed)
  callback = Callable.get(Struct.get(json, "callback"), Struct.getIfType(json, "callback", Callable))

  ///@type {?Callable} function(item, controller, emitter)
  postCallback = Callable.get(Struct.get(json, "postCallback"), Struct.getIfType(json, "postCallback", Callable))

  ///@param {GridItem} item
  ///@param {VisuController} controller
  ///@return {GridItemEmitter}
  static update = function(item, controller) {
    if (this.emitted >= this.amount) {
      return
    }

    this.offset.update()
    this.offsetX.update()
    this.offsetY.update()
    this.speed.update()
    this.angle.update()
    this.arrays.update()
    this.angleStep.update()
    this.wiggleAmplitude.update()

    this.time += DELTA_TIME * FRAME_MS
    if (this.time < this.interval) {
      return this
    }

    this.timeSum += this.time
    this.time = this.time - (floor(this.time / this.interval) * this.interval)
    this.emitted += 1
    if (this.preCallback != null) {
      this.preCallback(item, controller, this)
    }

    if (this.callback != null) {
      var _offset = this.offset.value * (SHROOM_SPAWN_SIZE / SHROOM_SPAWN_AMOUNT)
      var _offsetX = this.offsetX.value * (SHROOM_SPAWN_SIZE / SHROOM_SPAWN_AMOUNT)
      var _offsetY = this.offsetY.value * (SHROOM_SPAWN_SIZE / SHROOM_SPAWN_AMOUNT)
      var offsetLength = Math.fetchLength(0.0, 0.0, _offsetX, _offsetY)
      var offsetAngle = Math.fetchPointsAngle(0.0, 0.0, _offsetX, _offsetY)
      var posX = this.x + Math.fetchCircleX(offsetLength, offsetAngle)
      var posY = this.y + Math.fetchCircleY(offsetLength, offsetAngle)
      var startAngle = this.angle.value + item.angle
      var spd = this.speed.value + item.speed
      var wiggle = sin(this.wiggleFrequency * this.timeSum) * this.wiggleAmplitude.value
      for (var idx = 0; idx < floor(this.arrays.value); idx++) {
        var angle = startAngle + (idx * this.angleStep.value) + random(this.angleRng) + wiggle
        var _posX = Math.fetchCircleX(_offset, angle)
        var _posY = Math.fetchCircleY(_offset, angle)
        for (var arrIdx = 0; arrIdx < floor(this.perArray); arrIdx++) {
          this.callback(
            item, controller, this, idx, arrIdx, posX + _posX, posY + _posY,
            angle + this.anglePerArray + (arrIdx * this.anglePerArrayStep) + random(this.anglePerArrayRng),
            spd + random(this.speedRng)
          )
        }
      }
    }

    if (this.postCallback != null) {
      this.postCallback(item, controller, this)
    }

    return this
  }

  ///@return {GridItemEmitter}
  static reset = function() {
    this.time = 0.0
    this.timeSum = 0.0
    this.emitted = 0
    this.offset.reset()
    this.offsetX.reset()
    this.offsetY.reset()
    this.speed.reset()
    this.angle.reset()
    this.arrays.reset()
    this.angleStep.reset()
    this.wiggleAmplitude.reset()
    return this
  }

  ///@return {Boolean}
  static finished = function() {
    return this.emitted >= this.amount
  }
}


global.__GridItemSpawn = {
  uid: null,
  x: null,
  y: null,
  z: null,
  sprite: null,
  mask: null,
  speed: null,
  angle: null,
  lifespan: null,
  fadeIn: null,
  chunkPosition: null,
}
#macro GridItemSpawn global.__GridItemSpawn

///@interface
///@param {Struct} config
///@return {GridItem}
function GridItem(config) constructor {

  ///@type {String}
  uid = config.uid//Assert.isType(config.uid, String, "GridItem::uid must be type of String")

  ///@type {Number}
  x = config.x//Assert.isType(Struct.get(config, "x"), Number, "GridItem::x must be type of Number")

  ///@type {Number}
  y = config.y//Assert.isType(Struct.get(config, "y"), Number, "GridItem::y must be type of Number")

  ///@type {Number}
  z = 0.0;//Struct.getIfType(config, "z", Number, 0.0)

  ///@type {Sprite}
  sprite = SpriteUtil.parse(Struct.get(config, "sprite"), GRID_ITEM_DEFAULT_SPRITE)

  ///@type {Rectangle}
  /*
  mask = new Rectangle(Core.isType(Struct.get(config, "mask"), Struct)
    ? config.mask
    : { 
        x: 0, 
        y: 0, 
        width: this.sprite.getWidth(), 
        height: this.sprite.getHeight()
    })
  */
  mask = Struct.get(config, "mask") != null
    ? new RectangleSimple(config.mask.x, config.mask.y, config.mask.width, config.mask.height)
    : new RectangleSimple(0.0, 0.0, this.sprite.getWidth(), this.sprite.getHeight())

  ///@type {Number}
  speed = config.speed//Struct.getIfType(config, "speed", Number, 0.0)

  ///@type {Number}
  angle = config.angle//Struct.getIfType(config, "angle", Number, 0.0)

  ///@type {Number}
  lifespan = Struct.getIfType(config, "lifespan", Number, 0.0)

  ///@type {Number}
  fadeIn = Struct.getIfType(config, "fadeIn", Number, 0.0)

  ///@type {?Struct}
  chunkPosition = Struct.getIfType(config, "chunkPosition", Struct)

  ///@type {GridItemSignals}
  //signals = new GridItemSignals()

  signals = {
    kill: null,
    damage: null,
    bulletCollision: null,
    shroomCollision: null,
    playerCollision: null,
    freeReason: null,
  }

  static signalKill = function() {
    this.signals.kill = true
  }

  static signalBulletCollision = function(item) {
    this.signals.bulletCollision = item
  }

  static signalDamage = function(damage) {
    this.signals.damage = damage
  }

  static signalShroomCollision = function(item) {
    this.signals.shroomCollision = item
  }

  static signalBulletCollision = function(item) {
    this.signals.bulletCollision = item
  }

  static signalPlayerCollision = function(item) {
    this.signals.playerCollision = item
  }

  static resetSignals = function() {
    gml_pragma("forceinline")
    this.signals.damage = false
    this.signals.bulletCollision = null
    this.signals.shroomCollision = null
    this.signals.playerCollision = null
    return this
  }
    
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

  ///@param {any} name
  ///@param {any} [value]
  ///@return {GridItem}
  //static signal = function(name, value = true) {
  //  gml_pragma("forceinline")
  //  this.signals.set(name, value)
  //  return this
  //}

  ///@param {GridItem} target
  ///@return {Bollean}
  static collide = function(target) {
    gml_pragma("forceinline")
    var sourceX = this.x * GRID_SERVICE_PIXEL_WIDTH
    var sourceY = this.y * GRID_SERVICE_PIXEL_HEIGHT
    var targetX = target.x * GRID_SERVICE_PIXEL_WIDTH
    var targetY = target.y * GRID_SERVICE_PIXEL_HEIGHT
    return Math.ellipseOverlaps(
      sourceX - ((this.sprite.getWidth() * this.sprite.scaleX) / 2.0) + (this.mask.x * this.sprite.scaleX),
      sourceY - ((this.sprite.getHeight() * this.sprite.scaleY) / 2.0) + (this.mask.y * this.sprite.scaleY),
      this.mask.z * this.sprite.scaleX,
      this.mask.a * this.sprite.scaleY,
      targetX - ((target.sprite.getWidth() * target.sprite.scaleX) / 2.0) + (target.mask.x * target.sprite.scaleX),
      targetY - ((target.sprite.getHeight() * target.sprite.scaleY) / 2.0) + (target.mask.y * target.sprite.scaleY),
      target.mask.z * target.sprite.scaleX,
      target.mask.a * target.sprite.scaleY
    )
  }

  ///@param {VisuController} controller
  ///@return {GridItem}
  static move = function() {
    gml_pragma("forceinline")
    //this.signals.reset()
    this.resetSignals()
    //var _speed = DeltaTime.apply(controller.gridService.properties.bulletTime * this.speed)
    var _speed = DELTA_TIME * GRID_SERVICE_BULLET_TIME * this.speed
    //var _speed = DeltaTime.apply(GRID_SERVICE_BULLET_TIME * this.speed)
    this.x += Math.fetchCircleX(_speed, this.angle)
    this.y += Math.fetchCircleY(_speed, this.angle)
    return this
  }

  ///@param {VisuController} controller
  ///@return {GridItem}
  static update = function(controller) { 
    gml_pragma("forceinline")
    if (this.fadeIn < 1.0) {
      this.fadeIn = clamp(this.fadeIn + (DELTA_TIME * VISU_FADE_FACTOR), 0.0, 1.0)
    }

    return this
  }

  ///@return {GridItem}
  static free = function() {
    if (this.chunkPosition != null) {
      this.chunkPosition.keys.free()
      delete this.chunkPosition
      this.chunkPosition = null
    }

    return this
  }
}

