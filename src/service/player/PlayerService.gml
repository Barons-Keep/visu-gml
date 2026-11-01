///@package io.alkapivo.visu.service.player
show_debug_message("init PlayerService.gml")


///@param {?Struct} [config]
function PlayerService(config = null): Service(config) constructor {

  ///@type {?Player}
  player = null

  ///@type {?Player}
  playerB = null

  ///@type {?Player}
  playerContext = null

  ///@type {?Player}
  playerBContext = null

  statistics = {
    lives: 0,
    usedLives: 0,
    bombs: 0,
    usedBombs: 0,
    force: 0,
    maxForce: 0,
    points: 0,
    normalTime: 0,
    focusedTime: 0,
    aliveTime: 0,
    maxAliveTime: 0,
    report: function() {
      return {
        lives: this.lives,
        usedLives: this.usedLives,
        bombs: this.bombs,
        usedBombs: this.usedBombs,
        force: this.force,
        maxForce: this.maxForce,
        points: this.points,
        normalTime: this.normalTime,
        focusedTime: this.focusedTime,
        maxAliveTime: this.maxAliveTime
      }
    },
    reset: function() {
      this.lives = 0
      this.usedLives = 0
      this.bombs = 0
      this.usedBombs = 0
      this.force = 0
      this.maxForce = 0
      this.points = 0
      this.normalTime = 0
      this.focusedTime = 0
      this.aliveTime = 0
      this.maxAliveTime = 0
      return this
    },
    factoryPlayer: function(player) {
      this.reset()
      return this
    },
    freePlayer: function(player, reason) {
      switch (reason) {
        case "life":
          this.usedLives += 1
          this.aliveTime = 0.0
          break
        case "bomb":
          this.usedBombs += 1
          break
        case "force":
          this.maxForce = max(this.maxForce, player.stats.force.value)
          break
        default:
          this.lives = player.stats.life.value
          this.bombs = player.stats.bomb.value
          this.force = player.stats.force.value
          this.points = player.stats.point.value
          this.aliveTime += FRAME_MS * DELTA_TIME
          this.maxAliveTime = max(this.aliveTime, this.maxAliveTime)
          if (player.handler.focus) {
            this.focusedTime += FRAME_MS * DELTA_TIME
          } else {
            this.normalTime += FRAME_MS * DELTA_TIME
          }
          break
      }
      return this
    },
    validate: function() {
      Logger.debug("PlayerService", "PlayerStatistics are OK")
      return this
    },
  }

  statisticsB = {
    lives: 0,
    usedLives: 0,
    bombs: 0,
    usedBombs: 0,
    force: 0,
    maxForce: 0,
    points: 0,
    normalTime: 0,
    focusedTime: 0,
    aliveTime: 0,
    maxAliveTime: 0,
    report: function() {
      return {
        lives: this.lives,
        usedLives: this.usedLives,
        bombs: this.bombs,
        usedBombs: this.usedBombs,
        force: this.force,
        maxForce: this.maxForce,
        points: this.points,
        normalTime: this.normalTime,
        focusedTime: this.focusedTime,
        maxAliveTime: this.maxAliveTime
      }
    },
    reset: function() {
      this.lives = 0
      this.usedLives = 0
      this.bombs = 0
      this.usedBombs = 0
      this.force = 0
      this.maxForce = 0
      this.points = 0
      this.normalTime = 0
      this.focusedTime = 0
      this.aliveTime = 0
      this.maxAliveTime = 0
      return this
    },
    factoryPlayer: function(player) {
      this.reset()
      return this
    },
    freePlayer: function(player, reason) {
      switch (reason) {
        case "life":
          this.usedLives += 1
          this.aliveTime = 0.0
          break
        case "bomb":
          this.usedBombs += 1
          break
        case "force":
          this.maxForce = max(this.maxForce, player.stats.force.value)
          break
        default:
          this.lives = player.stats.life.value
          this.bombs = player.stats.bomb.value
          this.force = player.stats.force.value
          this.points = player.stats.point.value
          this.aliveTime += FRAME_MS * DELTA_TIME
          this.maxAliveTime = max(this.aliveTime, this.maxAliveTime)
          if (player.handler.focus) {
            this.focusedTime += FRAME_MS * DELTA_TIME
          } else {
            this.normalTime += FRAME_MS * DELTA_TIME
          }
          break
      }
      return this
    },
    validate: function() {
      Logger.debug("PlayerService", "PlayerStatistics are OK")
      return this
    },
  }

  isPlayerB = true

  ///@type {EventPump}
  dispatcher = new EventPump(this, new Map(String, Callable, {
    "spawn-player": function(event) {
      static spawnPlayer = function(playerService, isB, event) {
        var contextPlayer = isB ? playerService.playerB : playerService.player
        var contextPlayerName = isB ? "playerB" : "player"
        var template = new PlayerTemplate({
          name: "player_default",
          sprite: Struct.getDefault(event.data, "sprite", {
            name: "texture_player",
            animate: true,
          }),
          mask: Struct.get(event.data, "mask"),
          stats: Struct.get(event.data, "stats"),
          keyboard: Beans.get(BeanVisuIO).keyboards.get(contextPlayerName),
          mouse: Beans.get(BeanVisuIO).mouses.get(contextPlayerName),
          handler: Struct.getIfType(event.data, "handler", Struct, {}),
          isB: isB,
        })

        var controller = Beans.get(BeanVisuController)
        var gridService = controller.gridService
        var view = gridService.view

        var _x = view.x + (view.width / 2.0) + (playerService.isPlayerB ? (isB ? 0.25 : -0.25) : 0.0)
        var _y = gridService.height - (view.height * 3.25)//0.25)
        Core.print(contextPlayerName, "111", _x, view.width, view.x)
        if (Core.isType(contextPlayer, Player)) {
          if (Struct.get(event.data, "reset-position") != true) {
            Core.print(contextPlayerName, "222", _x, contextPlayer.x, view.width, view.x)
            _x = contextPlayer.x
            _y = contextPlayer.y
          }

          if (!Optional.is(Struct.get(template, "stats"))) {
            Struct.set(template, "stats", contextPlayer.stats)
          }
        }

        Struct.set(template, "x", _x)
        Struct.set(template, "y", _y)
        Struct.set(template, "uid", controller.gridService.generateUID())
        Struct.set(template, "speed", 0.0)
        Struct.set(template, "angle", 0.0)
        var visuPlayer = new Player(template)
        playerService.set(visuPlayer)
      }

      spawnPlayer(this, false, event)
      if (this.isPlayerB) {
        spawnPlayer(this, true, event)
      }
    },
    "clear-player": function(event) {
      this.remove(false).remove(true)
    },
  }))

  ///@param {Player} player
  ///@return {PlayerService}
  set = function(player) {
    if (!Core.isType(player, Player)) {
      return this
    }

    this.remove(player.isB)
    Struct.set(this, (player.isB ? "playerB" : "player"), player)
    Struct.set(this, (player.isB ? "playerBContext" : "playerContext"), player)
    return this
  }

  ///@param {Boolean} [isB]
  ///@return {PlayerService}
  remove = function(isB = false) {
    Struct.set(this, (isB ? "playerB" : "player"), null)
    return this
  }


  ///@param {Event} event
  ///@return {Promise}
  send = function(event) {
    if (!Core.isType(event.promise, Promise)) {
      event.promise = new Promise()
    }

    return this.dispatcher.send(event)
  }

  ///@param {GridItem} item
  ///@return {?Player}
  getCloserPlayer = function(item) {
    if (this.playerB == null) {
      return this.player
    } 

    if (this.player == null) {
      return this.playerB
    }

    var playerLength = Math.fetchLength(item.x, item.y, this.player.x, this.player.y)
    var playerBLength = Math.fetchLength(item.x, item.y, this.playerB.x, this.playerB.y)
    return playerLength < playerBLength ? this.player : this.playerB
  }

  ///@override
  ///@return {PlayerService}
  update = function() {
    this.dispatcher.update()
    var controller = Beans.get(BeanVisuController)
    if (this.player != null) {
      this.player.update(controller)
    }

    if (this.playerB != null) {
      this.playerB.update(controller)
    }

    return this
  }
}
