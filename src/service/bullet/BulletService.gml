///@package io.alkapivo.visu.service.bullet.BulletService

///@type {Number}
#macro BULLET_MAX_DISTANCE 3.0

global.BULLET_TEMPLATE = {
  name: "bullet_default",
  sprite: {
    name: "texture_test",
  },
  "gameModes": {
    "bulletHell": {
      "features": [
        {
          "feature": "AngleFeature",
          "value": {
            "value": 0.0,
            "target": 360.0,
            "factor": 1.0,
            "increase": 0.0
          }
        }
      ]
    }
  }
}


///@param {VisuController} _controller
///@param {Struct} [config]
function BulletService(_controller, config = {}): Service() constructor {

  ///@type {VisuController}
  controller = Assert.isType(_controller, VisuController)

  ///@type {Array<Bullet>}
  bullets = new Array(Bullet)

  ///@type {Map<String, BulletTemplate>}
  templates = new Map(String, BulletTemplate)
  
  ///@type {Stack<Number>}
  gc = new Stack(Number)

  ///@type {?GameMode}
  gameMode = null

  ///@type {GridItemChunkService}
  chunkService = new GridItemChunkService(GRID_ITEM_CHUNK_SERVICE_SIZE)

  ///@param {String} name
  ///@return {?BulletTemplate}
  getTemplate = function(name) {
    var template = this.templates.get(name)
    return template == null
      ? Visu.assets().bulletTemplates.get(name)
      : template
  }

  ///@type {EventPump}
  dispatcher = new EventPump(this, new Map(String, Callable, {
    "spawn-bullet": function (event, dispatcher) {
      var template = new BulletTemplate(event.data.template, this
        .getTemplate(event.data.template)
        .serialize())
        
      Struct.set(template, "x", event.data.x)
      Struct.set(template, "y", event.data.y)
      Struct.set(template, "angle", event.data.angle)
      Struct.set(template, "speed", event.data.speed / 1000)
      Struct.set(template, "producer", event.data.producer)
      Struct.set(template, "uid", this.controller.gridService.generateUID())

      if (event.data.producer == Shroom) {
        controller.sfxService.play("shroom-shoot")
      }
      
      var bullet = new Bullet(template)
      if (event.data.producer == Player) {
        this.chunkService.add(bullet)
      }
      //bullet.updateGameMode(this.controller.gameMode)

      this.bullets.add(bullet)

      
    },
    "clear-bullets": function(event) {
      this.bullets.clear()
      this.chunkService.clear()
    },
    "reset-templates": function(event) {
      this.templates.clear()
    },
  }))

  ///@param {Event} event
  ///@return {?Promise}
  send = function(event) {
    return this.dispatcher.send(event)
  }

  ///@override
  ///@return {BulletService}
  update = function() { 
    static updateGameMode = function(bullet, index, gameMode) {
      bullet.updateGameMode(gameMode)
    }

    static updateBullet = function (bullet, index, context) {
      bullet.update(context.controller)
      if (bullet.signals.kill) {
        context.gc.push(index)
        if (bullet.producer == Player) {
          context.chunkService.remove(bullet)
        }
      }
    }

    //if (controller.gameMode != this.gameMode) {
    //  this.gameMode = this.controller.gameMode
    //  this.bullets.forEach(updateGameMode, this.gameMode)
    //}

    this.dispatcher.update()
    this.bullets.forEach(updateBullet, this)
    if (this.gc.size() > 0) {
      this.bullets.removeMany(this.gc)
    }
    return this
  }

  this.send(new Event("reset-templates"))
}
