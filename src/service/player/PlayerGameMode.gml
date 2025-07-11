///@package io.alkapivo.visu.service.player

///@param {Struct} json
///@return {GridItemGameMode}
function PlayerBulletHellGameMode(json) {
  return new GridItemGameMode(Struct.append(json, {

    ///@type {Callable}
    type: PlayerBulletHellGameMode,

    ///@type {GridItemMovement}
    x: new GridItemMovement(Struct.getIfType(json, "x", Struct, {}), true),
    
    ///@type {GridItemMovement}
    y: new GridItemMovement(Struct.getIfType(json, "y", Struct, {}), true),

    ///@type {Boolean}
    focus: Struct.getIfType(json, "focus", Boolean, false),

    ///@type {Struct}
    focusCooldown: {
      time: 0.0,
      duration: Struct.getIfType(json, "focusCooldown", Number, FRAME_MS * 10),
      finished: false,
      increment: function() {
        this.finished = false
        this.time += DeltaTime.apply()
        if (this.time >= this.duration) {
          this.finished = true
          this.time = this.duration
        }

        return this
      },
      decrement: function() {
        this.finished = false
        this.time -= DeltaTime.apply()
        if (this.time <= 0.0) {
          this.time = 0.0
        }

        return this
      },
    },
    
    ///@type {Struct}
    previous: {
      x: {
        value: 0.0,
        prev: null,
        get: function() {
          return this.value - this.prev
        },
        update: function(value) {
          this.prev = this.prev == null ? value : this.value
          this.value = value
          return this
        },
        reset: function() {
          this.value = 0.0
          this.prev = this.value
          return this
        },
      },
    },

    ///@type {Array<Struct>}
    guns: new Array(Struct, Core.isType(Struct.get(json, "guns"), GMArray)
      ? GMArray.map(json.guns, function(gun) {
        return {
          cooldown: new Timer(FRAME_MS * Struct.getIfType(gun, "cooldown", Number, 8.0), { 
            loop: Infinity,
            time: Struct.getIfType(gun, "time", Number, 0.0),
          }),
          bullet: Struct.getIfType(gun, "bullet", String, "bullet-default"),
          angle: Struct.getIfType(gun, "angle", Number, 90.0),
          speed: Struct.getIfType(gun, "speed", Number, 10.0),
          offsetX: Struct.getIfType(gun, "offsetX", Number, 0.0),
          offsetY: Struct.getIfType(gun, "offsetY", Number, 0.0),
          minForce: Struct.getIfType(gun, "minForce", Number, 0.0),
          maxForce: Struct.getIfType(gun, "maxForce", Number, null),
          focus: Struct.getIfType(gun, "focus", Boolean, null),
        }
      })
      : []
    ),

    ///@override
    ///@param {GridItem} player
    ///@param {VisuController} controller
    ///@return {GridItemGameMode}
    onStart: function(player, controller) {
      this.x.speed = 0
      this.y.speed = 0
      this.guns.forEach(function(gun) {
        gun.cooldown.reset()
      })
      this.previous.x.reset()
      player.speed = 0
      player.angle = 90
      player.sprite.setAngle(player.angle)

      return this
    },

    ///@override
    ///@param {GridItem} player
    ///@param {VisuController} controller
    ///@return {GridItemGameMode}
    update: function(player, controller) {
      static calcSpeed = function(config, player, keyA, keyB, keyFocus) {
        var spdMax = config.speedMax
        if (keyFocus) {
          var factor = DeltaTime.apply(abs(config.speedMax - config.speedMaxFocus) / 15.0)
          spdMax = clamp(abs(config.speed) - factor, config.speedMaxFocus, config.speedMax)
        }

        var spd = 0.0
        if (keyA || keyB) {
          var dir = keyA ? -1.0 : 1.0
          config.speed += dir * DeltaTime.apply(config.acceleration) * 0.5
          spd = DeltaTime.apply(config.speed)
          config.speed += dir * DeltaTime.apply(config.acceleration) * 0.5
        } else if (abs(config.speed) - (DeltaTime.apply(config.friction) * 0.5) >= 0) {
          var dir = sign(config.speed)
          config.speed -= dir * DeltaTime.apply(config.friction) * 0.5
          spd = DeltaTime.apply(config.speed)
          config.speed -= dir * DeltaTime.apply(config.friction) * 0.5
          if (sign(config.speed) != dir) {
            config.speed = 0.0
          }
        } else {
          config.speed = 0.0
        }
        config.speed = sign(config.speed) * clamp(abs(config.speed), 0.0, spdMax)
        return spd

        //var speedMax = config.speedMax
        //if (keyFocus) {
        //  var factor = abs(config.speedMax - config.speedMaxFocus) / 15.0
        //  speedMax = clamp(abs(config.speed) - DeltaTime.apply(factor), 
        //    config.speedMaxFocus, config.speedMax)
        //}
        //speedMax = DeltaTime.apply(speedMax)
        //config.speed = keyA || keyB
        //  ? (config.speed + (keyA ? -1 : 1) 
        //    * DeltaTime.apply(config.acceleration))
        //  : (abs(config.speed) - DeltaTime.apply(config.friction) >= 0
        //    ? config.speed - sign(config.speed) 
        //      * DeltaTime.apply(config.friction) : 0)
        //config.speed = sign(config.speed) * clamp(abs(config.speed), 0, speedMax)
        //return config.speed
      }

      static updateKeyActionOnEnabled = function(gun, index, acc) {
        var forceLevel = acc.player.stats.forceLevel.get()
        if (!gun.cooldown.update().finished
          || (forceLevel < gun.minForce)
          || (gun.maxForce != null && forceLevel > gun.maxForce)
          || (gun.focus != null && gun.focus != acc.focus)) {
          return
        }

        acc.controller.bulletService.spawnBullet(
          gun.bullet, 
          Player,
          acc.player.x + (gun.offsetX / GRID_SERVICE_PIXEL_WIDTH), 
          acc.player.y + (gun.offsetY / GRID_SERVICE_PIXEL_HEIGHT),
          gun.angle,
          gun.speed
        )

        //acc.controller.bulletService.send(new Event("spawn-bullet", {
        //  template: gun.bullet,
        //  producer: Player,
        //  x: acc.player.x + (gun.offsetX / GRID_SERVICE_PIXEL_WIDTH),
        //  y: acc.player.y + (gun.offsetY / GRID_SERVICE_PIXEL_HEIGHT),
        //  angle: gun.angle,
        //  speed: gun.speed,
        //}))

        acc.controller.sfxService.play("player-shoot")
      }

      static updateKeyActionOnDisabled = function(gun) {
        if (!gun.cooldown.finished && gun.cooldown.update().finished) {
          gun.cooldown.reset()
        }
      }

      static updateGMTFContextFocused = function(key) {
        key.on = false
        key.pressed = false
        key.released = false
      }
      
      var keys = player.keyboard.keys
      this.focus = keys.focus.on
        ? this.focusCooldown.increment().finished
        : this.focusCooldown.decrement().finished

      if (GMTFContext.isFocused()) {
        Struct.forEach(keys, updateGMTFContextFocused)
      }

      if (keys.action.on) {
        this.guns.forEach(updateKeyActionOnEnabled, {
          controller: controller,
          player: player,
          focus: this.focus,
        })
      } else {
        this.guns.forEach(updateKeyActionOnDisabled)
      }

      if (keys.bomb.pressed) {
        player.stats.dispatchBomb()
      }

      if (Optional.is(player.signals.shroomCollision) 
        || Optional.is(player.signals.bulletCollision)) {
        this.x.speed = 0.0
        this.y.speed = 0.0
        player.stats.dispatchDeath()
      }

      player.x = clamp(
        player.x + calcSpeed(this.x, player, keys.left.on, keys.right.on, keys.focus.on),
        0.0,
        controller.gridService.width
      )

      player.y = clamp(
        player.y + calcSpeed(this.y, player, keys.up.on, keys.down.on, keys.focus.on), 
        0.0, 
        controller.gridService.height
      )

      this.previous.x.update(player.x)

      return this
    },
  }))
}


///@param {Struct} json
///@return {GridItemGameMode}
function PlayerRacingGameMode(json) {
  return new GridItemGameMode(Struct.append(json, {

    ///@param {Callable}
    type: PlayerRacingGameMode,

    ///@type {GridItemMovement}
    throttle: new GridItemMovement(Struct.getDefault(json, "throttle", {
      acceleration: 0.5,
      speedMax: 2,
      friction: 0.5,
    }), true),

    ///@type {GridItemMovement}
    nitro: new GridItemMovement(Struct.getDefault(json, "nitro", {
      acceleration: 0.5,
      speedMax: 1,
      friction: 1,
    }), true),

    ///@type {GridItemMovement}
    wheel: new GridItemMovement(Struct.getDefault(json, "wheel", {
      acceleration: 0.1,
      speedMax: 3.5,
      friction: 0.1,
    }), false),

    ///@override
    ///@param {GridItem} player
    ///@param {VisuController} controller
    ///@return {GridItemGameMode}
    onStart: function(player, controller) {
      this.throttle.speed = 0
      this.nitro.speed = 0
      this.wheel.speed = 0
      player.speed = 0
      player.angle = 90
      player.sprite.setAngle(player.angle)

      return this
    },

    ///@override
    ///@param {GridItem} player
    ///@param {VisuController} controller
    ///@return {GridItemGameMode}
    update: function(player, controller) {
      static calcSpeed = function(movement, keyA, keyB) { 
        var spd = 0.0
        if (keyA || keyB) {
          var dir = keyA ? -1.0 : 1.0
          movement.speed += dir * DeltaTime.apply(movement.acceleration) * 0.5
          spd = DeltaTime.apply(movement.speed)
          movement.speed += dir * DeltaTime.apply(movement.acceleration) * 0.5
        } else if (abs(movement.speed) - (DeltaTime.apply(movement.friction) * 0.5) >= 0) {
          var dir = sign(movement.speed)
          movement.speed -= dir * DeltaTime.apply(movement.friction) * 0.5
          spd = DeltaTime.apply(movement.speed)
          movement.speed -= dir * DeltaTime.apply(movement.friction) * 0.5
          if (sign(movement.speed) != dir) {
            movement.speed = 0.0
          }
        } else {
          movement.speed = 0.0
        }
        movement.speed = sign(movement.speed) * clamp(abs(movement.speed), 0.0, movement.speedMax)
        return spd

        //movement.speed = keyA || keyB
        //  ? (movement.speed + (keyA ? -1 : 1) 
        //    * DeltaTime.apply(movement.acceleration))
        //  : (abs(movement.speed) - DeltaTime.apply(movement.friction) >= 0
        //    ? movement.speed - sign(movement.speed) 
        //      * DeltaTime.apply(movement.friction) : 0)
        //movement.speed = sign(movement.speed) * clamp(abs(movement.speed), 0, DeltaTime.apply(movement.speedMax))
        //return movement.speed
      }

      var keys = player.keyboard.keys
      if (GMTFContext.isFocused()) {
        keys.left.on = false
        keys.right.on = false
        keys.up.on = false
        keys.down.on = false
        keys.action.on = false
      }

      var speedMax = this.throttle.speedMax
      this.throttle.speedMax = speedMax + calcSpeed(this.nitro, false, keys.action.on)
      player.speed = calcSpeed(this.throttle, keys.down.on, keys.up.on)
      this.throttle.speedMax = speedMax

      player.angle += calcSpeed(this.wheel, keys.right.on, keys.left.on)
      player.sprite.setAngle(player.angle)
      player.y = clamp(player.y, 0.0, controller.gridService.height)
      /*
      var gridService = controller.gridService
      player.x = clamp(
        player.x, 
        gridService.view.x - gridService.targetLocked.margin.left, 
        gridService.view.x + gridService.view.width + gridService.targetLocked.margin.right
      )
      player.y = clamp(
        player.y, 
        gridService.view.y - gridService.targetLocked.margin.top, 
        gridService.view.y + gridService.view.height + gridService.targetLocked.margin.bottom
      )
      */

      return this
    },
  }))
}


///@param {Struct} json
///@return {GridItemGameMode}
function PlayerPlatformerGameMode(json) {
  return new GridItemGameMode(Struct.append(json, {

    ///@param {Callable}
    type: PlayerPlatformerGameMode,

    ///@param {GridItemMovement}
    x: new GridItemMovement(Struct.getDefault(json, "x", { }), true),

    ///@param {GridItemMovement}
    y: new GridItemMovement(Struct.getDefault(json, "y", { speedMax: 25.0 }), true),

    ///@type {Struct}
    jump: {
      size: Assert.isType(Struct.getDefault(Struct
        .get(json, "jump"), "size", 3.5), Number) / 100.0,
    },

    ///@type {?Shroom}
    shroomLanded: null,

    ///@type {Boolean}
    doubleJumped: false,

    ///@override
    ///@param {GridItem} player
    ///@param {VisuController} controller
    ///@return {GridItemGameMode}
    onStart: function(player, controller) {
      this.x.speed = 0
      this.y.speed = 0
      this.shroomLanded = null
      this.doubleJumped = false
      player.speed = 0
      player.angle = 90
      player.sprite.setAngle(player.angle)
      
      return this
    },

    ///@override
    ///@param {GridItem} player
    ///@param {VisuController} controller
    ///@return {GridItemGameMode}
    update: function(player, controller) {
      static calcSpeed = function(config, player, keyA, keyB) {
        var spd = 0.0
        if (keyA || keyB) {
          var dir = keyA ? -1.0 : 1.0
          config.speed += dir * DeltaTime.apply(config.acceleration) * 0.5
          spd = DeltaTime.apply(config.speed)
          config.speed += dir * DeltaTime.apply(config.acceleration) * 0.5
        } else if (abs(config.speed) - (DeltaTime.apply(config.friction) * 0.5) >= 0) {
          var dir = sign(config.speed)
          config.speed -= dir * DeltaTime.apply(config.friction) * 0.5
          spd = DeltaTime.apply(config.speed)
          config.speed -= dir * DeltaTime.apply(config.friction) * 0.5
          if (sign(movement.speed) != dir) {
            movement.speed = 0.0
          }
        } else {
          config.speed = 0.0
        }
        config.speed = sign(config.speed) * clamp(abs(config.speed), 0.0, spdMax)
        return spd
      }

      var gridService = controller.gridService
      var view = gridService.view
      var keys = player.keyboard.keys
      if (GMTFContext.isFocused()) {
        keys.left.on = false
        keys.right.on = false
        keys.up.on = false
        keys.down.on = false
        keys.action.on = false
      }
      player.x += calcSpeed(this.x, player, keys.left.on, keys.right.on)

      var shroomCollision = player.signals.shroomCollision
      if (!Optional.is(shroomCollision)) {
        if ((keys.up.pressed || keys.action.pressed) && player.y == gridService.height) {
          this.y.speed = -1 * this.jump.size
        }

        if (Optional.is(this.shroomLanded)) {
          this.shroomLanded.signal("playerLeave")
          this.shroomLanded = null
        }

        if (this.doubleJumped && player.y == gridService.height) {
          this.doubleJumped = false
        }

        if (!this.doubleJumped && player.y != gridService.height) {
          if (keys.up.pressed || keys.action.pressed) {
            this.y.speed = -1 * this.jump.size
            this.doubleJumped = true
          }
        }

        player.y += calcSpeed(this.y, player, false, true)
      } else {
        if ((keys.up.pressed || keys.action.pressed) && this.y.speed > 0) {
          this.y.speed = -1 * this.jump.size
        }

        if (!this.doubleJumped && !Optional.is(this.shroomLanded)) {
          if (keys.up.pressed || keys.action.pressed) {
            this.y.speed = -1 * this.jump.size
            this.doubleJumped = true
          }
        }

        if (this.y.speed < 0.0) {
          player.y += calcSpeed(this.y, player, false, true)
        } else {
          if (!Optional.is(this.shroomLanded)) {
            this.shroomLanded = shroomCollision
            this.shroomLanded.signal("playerLanded")
            this.doubleJumped = false

            if (keys.down.pressed) {
              shroomCollision.signal("kill")
              this.y.speed = 0.0
            }
          } else {
            player.x += (((this.shroomLanded.angle > 270.0 && this.shroomLanded.angle < 90) ? -1 : 1) 
              * Math.fetchCircleX(DeltaTime.apply(this.shroomLanded.speed), this.shroomLanded.angle))
            player.y += (((this.shroomLanded.angle > 180.0 && this.shroomLanded.angle < 0) ? -1 : 1) 
              * Math.fetchCircleY(DeltaTime.apply(this.shroomLanded.speed), this.shroomLanded.angle))

            if (keys.down.pressed) {
              this.shroomLanded.signal("kill")
              this.y.speed = 0.0
            }
          } 
        }
      }

      // ground
      player.y = clamp(player.y, 0.0, gridService.height)
      if (player.y == 0.0 || player.y == gridService.height) {
        this.y.speed = 0.0
        if (Optional.is(this.shroomLanded)) {
          this.shroomLanded.signal("playerLeave")
          this.shroomLanded = null
          this.doubleJumped = false
        }
      }

      return this
    },
  }))
}


///@static
///@type {Struct}
global.__PLAYER_GAME_MODES = {
  "racing": PlayerRacingGameMode,
  "bulletHell": PlayerBulletHellGameMode,
  "platformer": PlayerPlatformerGameMode,
}
#macro PLAYER_GAME_MODES global.__PLAYER_GAME_MODES


