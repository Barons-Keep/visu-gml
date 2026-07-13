///@package io.alkapivo.visu.renderer
show_debug_message("init VisuHUDRenderer.gml")


function VisuHUDRenderer() constructor {

  ///@type {Boolean}
  enabled = false

  ///@private
  ///@type {Timer}
  glitchCooldown = new Timer(0.33)

  ///@private
  ///@type {BKTGlitch}
  glitchService = new BKTGlitchService()

  ///@private
  ///@type {Timer}
  refreshTimer = new Timer(0.2, { loop: Infinity })

  ///@private
  ///@type {Struct}
  cachedText = {
    label: "",
    point: "",
    force: "",
    mask: "",
    life: "",
    bomb: "",
  }

  ///@private
  ///@type {Boolean}
  enableGlitch = false

  ///@private
  ///@type {Number}
  lastGodMode = 0.0

  ///@private
  ///@type {Font}
  font = new Font(font_kodeo_mono_28_bold)

  ///@private
  ///@type {Font}
  fontGodMode = new Font(font_kodeo_mono_48_bold)

  ///@type {Number}
  fadeIn = 0.0

  hudPosition = {
    x: 0.0,
    y: 0.0,
    width: 1.0,
    height: 1.0,
  }

  ///@private
  ///@return {VisuHUDRenderer}
  setGlitchServiceConfig = function(factor = 0.0, useConfig = true) {
    if (!this.enableGlitch) {
      return this
    }

    var config = {
      lineSpeed: {
        defValue: 0.01,
        minValue: 0.0,
        maxValue: 0.5,
      },
      lineShift: {
        defValue: 0.0,
        minValue: 0.0,
        maxValue: 0.05,
      },
      lineResolution: {
        defValue: 0.0,
        minValue: 0.0,
        maxValue: 3.0,
      },
      lineVertShift: {
        defValue: 0.0,
        minValue: 0.0,
        maxValue: 1.0,
      },
      lineDrift: {
        defValue: 0.0,
        minValue: 0.0,
        maxValue: 1.0,
      },
      jumbleSpeed: {
        defValue: 4.5,
        minValue: 0.0,
        maxValue: 25.0,
      },
      jumbleShift: {
        defValue: 0.059999999999999998,
        minValue: 0.0,
        maxValue: 1.0,
      },
      jumbleResolution: {
        defValue: 0.25,
        minValue: 0.0,
        maxValue: 1.0,
      },
      jumbleness: {
        defValue: 0.10000000000000001,
        minValue: 0.0,
        maxValue: 1.0,
      },
      dispersion: {
        defValue: 0.002,
        minValue: 0.0,
        maxValue: 0.5,
      },
      channelShift: {
        defValue: 0.00050000000000000001,
        minValue: 0.0,
        maxValue: 0.05,
      },
      noiseLevel: {
        defValue: 0.10000000000000001,
        minValue: 0.0,
        maxValue: 1.0,
      },
      shakiness: {
        defValue: 0.5,
        minValue: 0.0,
        maxValue: 10.0,
      },
      rngSeed: {
        defValue: 0.66600000000000004,
        minValue: 0.0,
        maxValue: 1.0,
      },
      intensity: {
        defValue: 0.40000000000000002,
        minValue: 0.0,
        maxValue: 5.0,
      },
    }

    if (useConfig) {
      this.glitchService.dispatcher
        .execute(new Event("load-config", config))
    }

    this.glitchService.dispatcher
      .execute(new Event("spawn-glitch", { 
        factor: factor, 
        rng: !useConfig
      }))
    
      return this
  }

  ///@param {?Number} [value]
  ///@return {VisuHUDRenderer}
  sendGlitchEvent = function(value = null) {
    var factor = Core.isType(value, Number)
      ? value
      : (choose(0.3, 0.4, 0.5, 0.6, 0.7) / 100.0)
    this.setGlitchServiceConfig(factor, false)
    this.glitchCooldown.reset()
    return this
  }

  ///@return {VisuHUDRenderer}
  sendPointParticleEvent = function() {
    var controller = Beans.get(BeanVisuController)
    var system = controller.particleService.systems.get("hud")
    if (system == null) {
      return this
    }
 
    var width = this.hudPosition.width / 2.0
    var height = this.hudPosition.height / 4.0
    controller.particleService.spawnParticleEmitter(
      "hud",
      "particle-hud-point",
      this.hudPosition.x + this.hudPosition.height,
      this.hudPosition.y + height * 1.0 - height,
      this.hudPosition.x + this.hudPosition.height + this.hudPosition.height,
      this.hudPosition.y + height * 1.0,
      FRAME_MS,
      1.0,
      FRAME_MS
    )

    var progress = this.glitchCooldown.getProgress()
    if (progress > 0.5) {
      this.glitchCooldown.reset()
      this.glitchCooldown.time = clamp(progress - 0.5, 0.0, 1.0) * this.glitchCooldown.duration
    }

    return this
  }

  ///@return {VisuHUDRenderer}
  sendForceParticleEvent = function() {
    var controller = Beans.get(BeanVisuController)
    var system = controller.particleService.systems.get("hud")
    if (system == null) {
      return this
    }
 
    var width = this.hudPosition.width / 2.0
    var height = this.hudPosition.height / 4.0
    controller.particleService.spawnParticleEmitter(
      "hud",
      "particle-hud-force",
      this.hudPosition.x + this.hudPosition.height,
      this.hudPosition.y + height * 2.0 - height,
      this.hudPosition.x + this.hudPosition.height + this.hudPosition.height,
      this.hudPosition.y + height * 2.0,
      FRAME_MS,
      3.0,
      FRAME_MS
    )

    var progress = this.glitchCooldown.getProgress()
    if (progress > 0.5) {
      this.glitchCooldown.reset()
      this.glitchCooldown.time = clamp(progress - 0.5, 0.0, 1.0) * this.glitchCooldown.duration
    }

    return this
  }

  ///@return {VisuHUDRenderer}
  sendLifeParticleEvent = function() {
    var controller = Beans.get(BeanVisuController)
    var system = controller.particleService.systems.get("hud")
    if (system == null) {
      return this
    }
 
    var width = this.hudPosition.width / 2.0
    var height = this.hudPosition.height / 4.0
    controller.particleService.spawnParticleEmitter(
      "hud",
      "particle-hud-life",
      this.hudPosition.x + this.hudPosition.height,
      this.hudPosition.y + height * 3.0 - height,
      this.hudPosition.x + this.hudPosition.height + this.hudPosition.height,
      this.hudPosition.y + height * 3.0,
      FRAME_MS,
      1.0,
      FRAME_MS
    )

    return this
  }

  ///@return {VisuHUDRenderer}
  sendBombParticleEvent = function() {
    var controller = Beans.get(BeanVisuController)
    var system = controller.particleService.systems.get("hud")
    if (system == null) {
      return this
    }
 
    var width = this.hudPosition.width / 2.0
    var height = this.hudPosition.height / 4.0
    controller.particleService.spawnParticleEmitter(
      "hud",
      "particle-hud-bomb",
      this.hudPosition.x + this.hudPosition.height,
      this.hudPosition.y + height * 4.0 - height,
      this.hudPosition.x + this.hudPosition.height + this.hudPosition.height,
      this.hudPosition.y + height * 4.0,
      FRAME_MS,
      1.0,
      FRAME_MS
    )

    return this
  }

  ///@private
  ///@return {VisuHUDRenderer}
  init = function() {
    this.setGlitchServiceConfig()
    return this
  }

  ///@private
  ///@type {UILayout} layout
  ///@return {VisuHUDRenderer}
  renderHUD = function(layout) {
    if (!this.enabled && this.fadeIn == 0.0) {
      this.renderParticleHUDSystem()
      return this
    }

    if (!this.glitchCooldown.finished 
        && this.glitchCooldown.update().finished) {
      this.glitchCooldown.time = this.glitchCooldown.duration
      this.setGlitchServiceConfig(0.0, true)
    }

    var controller = Beans.get(BeanVisuController)
    var player = controller.playerService.player
    if (player != null) {
      var _x = layout.x()
      var _y = layout.y()
      var _width = layout.width()
      var _height = layout.height()
      var xStart = _width * 0.061
      var yStart = _height * 0.08
      var offset = (this.glitchCooldown.duration - this.glitchCooldown.time) * 64.0
      var scale = clamp((min(_width, _height) / 1536), 0.33, 1.5)
      var factor = 1.0 - (ceil(player.stats.godModeCooldown) - player.stats.godModeCooldown)

      if (this.refreshTimer.update().finished) {
        var lifeString = ""
        repeat (player.stats.life.get()) {
          lifeString = $"{lifeString}L "
        }

        var bombString = ""
        repeat (player.stats.bomb.get()) {
          bombString = $"{bombString}B "
        }

        var point = string(player.stats.point.get())
        repeat (4 - String.size(point)) {
          point = $"0{point}"
        }

        var forceLevel = player.stats.forceLevel
        var forceTreshold = forceLevel.level < forceLevel.tresholds.size() - 1
          ? forceLevel.tresholds.get(forceLevel.level + 1)
          : (forceLevel.tresholds.size() == 0 ? 0 : forceLevel.tresholds.getLast())
        var force = forceLevel.level == forceLevel.tresholds.size() - 1
          ? "MAX"
          : $"{player.stats.force.get()} / {forceTreshold}"

        this.cachedText.mask = $"POINT: {point}\nFORCE: {force}\n LIFE: {lifeString}\n BOMB: {bombString}"
        this.cachedText.label = $"POINT:        \nFORCE:        \n LIFE:\n BOMB:"
        this.cachedText.point = $"       {point}\n              \n      \n      "
        this.cachedText.force = $"              \n       {force}\n      \n      "
        this.cachedText.life = $"\n\n       {lifeString}\n\n"
        this.cachedText.bomb = $"\n\n\n       {bombString}"
      }

      GPU.render.text(_x + xStart + offset, _y + _height - yStart, this.cachedText.mask,  scale, 0.0, 1.00 * this.fadeIn, c_white,   this.font, HAlign.LEFT, VAlign.BOTTOM)
      GPU.render.text(_x + xStart + offset, _y + _height - yStart, this.cachedText.label, scale, 0.0, 0.10 * this.fadeIn, c_fuchsia, this.font, HAlign.LEFT, VAlign.BOTTOM)  
      GPU.render.text(_x + xStart, _y + _height - yStart - offset, this.cachedText.point, scale, 0.0, 0.50 * this.fadeIn, c_blue,    this.font, HAlign.LEFT, VAlign.BOTTOM)  
      GPU.render.text(_x + xStart, _y + _height - yStart - offset, this.cachedText.force, scale, 0.0, 0.50 * this.fadeIn, c_red,     this.font, HAlign.LEFT, VAlign.BOTTOM)  
      GPU.render.text(_x + xStart, _y + _height - yStart + offset, this.cachedText.life,  scale, 0.0, 0.50 * this.fadeIn, c_lime,    this.font, HAlign.LEFT, VAlign.BOTTOM)  
      GPU.render.text(_x + xStart, _y + _height - yStart + offset, this.cachedText.bomb,  scale, 0.0, 0.50 * this.fadeIn, c_yellow,  this.font, HAlign.LEFT, VAlign.BOTTOM)

      this.hudPosition.width = string_width(this.cachedText.mask) * scale
      this.hudPosition.height = string_height(this.cachedText.mask) * scale
      this.hudPosition.x = _x + xStart
      this.hudPosition.y = _y + _height - yStart - this.hudPosition.height

      if (player.stats.godModeCooldown > 0.0) {
        if (this.lastGodMode == 0.0) {
          this.lastGodMode = player.stats.godModeCooldown
        }

        GPU.render.text(
          _x + (_width / 2.0),
          //_y + _height - yStart - (this.hudPosition.height / 2.0),
          _y + yStart + (yStart * factor) + (this.hudPosition.height / 2.0),
          $"{ceil(player.stats.godModeCooldown)}",
          1.0 + factor,
          0.0,
          this.fadeIn * factor,
          c_white,
          this.fontGodMode,
          HAlign.CENTER,
          VAlign.CENTER,
          c_black
        )

        GPU.render.text(
          _x + (_width / 2.0),
          //_y + _height - yStart,
          _y + yStart + yStart,
          Language.get("visu.gameplay.absolute-protection"),
          1.0 + clamp(player.stats.godModeCooldown / this.lastGodMode, 0.0, 1.0),
          0.0,
          this.fadeIn * (player.stats.godModeCooldown < 1.0 ? factor : 1.0) * 2.0,
          c_white,
          this.font,
          HAlign.CENTER,
          VAlign.BOTTOM,
          c_black
        )
      } else {
        this.lastGodMode = 0.0
      }
    }

    this.renderParticleHUDSystem()
    return this
  }

  ///@return {VisuHUDRenderer}
  renderParticleHUDSystem = function() {
    var controller = Beans.get(BeanVisuController)
    var system = controller.particleService.systems.get("hud")
    if (system == null
        || !Visu.settings.getValue("visu.graphics.particle")) {
      return this
    }

    system.render()

    return this
  }

  ///@type {UILayout} layout
  ///@return {VisuHUDRenderer}
  update = function(layout) {
    if (this.enableGlitch) {
      this.glitchService.update(layout.width(), layout.height())
    }

    if (this.enabled) {
      if (this.fadeIn < 1.0) {
        this.fadeIn = clamp(this.fadeIn + VISU_FADE_FACTOR, 0.0, 1.0)
      }
    } else {
      if (this.fadeIn > 0.0) {
        this.fadeIn = clamp(this.fadeIn - VISU_FADE_FACTOR, 0.0, 1.0)
      }
    }
    
    return this
  }

  ///@type {UILayout} layout
  ///@return {VisuHUDRenderer}
  renderGUI = function(layout) {
    if (this.enableGlitch) {
      this.glitchService.renderOn(this.renderHUD, layout)
    } else {
      this.renderHUD(layout)
    }
    
    return this
  }

  this.init()
}
