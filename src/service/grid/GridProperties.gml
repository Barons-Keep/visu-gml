///@package io.alkapivo.visu.service.grid

///@param {?Struct} [config]
function GridProperties(config = null) constructor {

  ///@type {Number}
  speed = Struct.getIfType(config, "properties.speed", Number, 1.0)

  #region channels
  ///@type {Number}
  channels = Struct.getIfType(config, "properties.channels", Number, 10.0)

  ///@type {Color}
  channelsPrimaryColor = ColorUtil.parse(Struct.get(config, "properties.channelsPrimaryColor"), "#ff12ac")

  ///@type {Color}
  channelsSecondaryColor = ColorUtil.fromHex(Struct.get(config, "properties.channelsSecondaryColor"), "#7daaff")

  ///@type {Number}
  channelsPrimaryAlpha = Struct.getIfType(config, "properties.channelsPrimaryAlpha", Number, 0.0)

  ///@type {Number}
  channelsSecondaryAlpha = Struct.getIfType(config, "properties.channelsSecondaryAlpha", Number, 0.0)

  ///@type {Number}
  channelsPrimaryThickness = Struct.getIfType(config, "properties.channelsPrimaryThickness", Number, 6.0)

  ///@type {Number}
  channelsSecondaryThickness = Struct.getIfType(config, "properties.channelsSecondaryThickness", Number, 6.0)

  ///@type {String}
  channelsMode = Struct.getIfType(config, "properties.channelsMode", String, "DUAL")
  #endregion

  #region separators
  ///@type {Number}
  separators = Assert.isType(Struct
    .getDefault(config, "properties.separators", 20.0), Number)

  ///@type {Color}
  separatorsPrimaryColor = Assert.isType(ColorUtil.fromHex(Struct
    .getDefault(config, "properties.separatorsPrimaryColor ", "#ff12ac")), Color)

  ///@type {Color}
  separatorsSecondaryColor = Assert.isType(ColorUtil.fromHex(Struct
    .getDefault(config, "properties.separatorsSecondaryColor ", "#7daaff")), Color)

  ///@type {Number}
  separatorsPrimaryAlpha = Assert.isType(Struct
    .getDefault(config, "properties.separatorsPrimaryAlpha", 0.0), Number)

  ///@type {Number}
  separatorsSecondaryAlpha = Assert.isType(Struct
    .getDefault(config, "properties.separatorsSecondaryAlpha", 0.0), Number)  

  ///@type {Number}
  separatorsPrimaryThickness = Assert.isType(Struct
      .getDefault(config, "properties.separatorsPrimaryThickness", 6), Number)

  ///@type {Number}
  separatorsSecondaryThickness = Assert.isType(Struct
    .getDefault(config, "properties.separatorsSecondaryThickness", 6), Number)

  ///@type {String}
  separatorsMode = Assert.isType(Struct
    .getDefault(config, "properties.separatorsMode", "DUAL"), String)
  #endregion

  #region borders
  ///@type {Color}
  borderVerticalColor = Assert.isType(ColorUtil.fromHex(Struct
    .getDefault(config, "properties.borderVerticalColor ", "#ff0000")), Color)

  ///@type {Number}
  borderVerticalAlpha = Assert.isType(Struct
    .getDefault(config, "properties.borderVerticalAlpha", 0.0), Number)

  ///@type {Number}
  borderVerticalThickness = Assert.isType(Struct
      .getDefault(config, "properties.borderVerticalThickness", 16), Number)

  ///@type {Color}
  borderHorizontalColor = Assert.isType(ColorUtil.fromHex(Struct
    .getDefault(config, "properties.borderHorizontalColor ", "#ff0000")), Color)

  ///@type {Number}
  borderHorizontalAlpha = Assert.isType(Struct
    .getDefault(config, "properties.borderHorizontalAlpha", 0.0), Number)  

  ///@type {Number}
  borderHorizontalThickness = Assert.isType(Struct
    .getDefault(config, "properties.borderHorizontalThickness", 16), Number)

  ///@type {Number}
  borderHorizontalLength = Assert.isType(Struct
    .getDefault(config, "properties.borderHorizontalLength", 1), Number)

  ///@type {Number}
  borderVerticalLength = Assert.isType(Struct
    .getDefault(config, "properties.borderVerticalLength", 1), Number)
  #endregion
  
  #region enable/disable rendering
  ///@type {Boolean}
  renderGrid = Assert.isType(Struct
    .getDefault(config, "properties.renderGrid", true), Boolean)
  
  ///@type {Boolean}
  renderElements = Assert.isType(Struct
    .getDefault(config, "properties.renderElements", true), Boolean)

  ///@type {Boolean}
  renderBullets = Assert.isType(Struct
    .getDefault(config, "properties.renderBullets", true), Boolean)

  ///@type {Boolean}
  renderShrooms = Assert.isType(Struct
    .getDefault(config, "properties.renderShrooms", true), Boolean)

  ///@type {Boolean}
  renderCoins = Assert.isType(Struct
    .getDefault(config, "properties.renderCoins", true), Boolean)

  ///@type {Boolean}
  renderPlayer = Struct.getIfType(config, "properties.renderPlayer", Boolean, true)

  ///@type {Boolean}
  renderBackground = Assert.isType(Struct
    .getDefault(config, "properties.renderBackground", true), Boolean)

  ///@type {Boolean}
  renderVideo = Assert.isType(Struct
    .getDefault(config, "properties.renderVideo", true), Boolean)

  ///@type {Boolean}
  renderVideoAfter = Assert.isType(Struct
    .getDefault(config, "properties.renderVideoAfter", false), Boolean)

  ///@type {Boolean}
  renderForeground = Assert.isType(Struct
    .getDefault(config, "properties.renderForeground", true), Boolean)

  ///@type {Boolean}
  renderGridShaders = Assert.isType(Struct
    .getDefault(config, "properties.renderGridShaders", true), Boolean)

  ///@type {Boolean}
  renderBackgroundShaders = Assert.isType(Struct
    .getDefault(config, "properties.renderBackgroundShaders", true), Boolean)

  ///@type {Boolean}
  renderCombinedShaders = Assert.isType(Struct
    .getDefault(config, "properties.renderCombinedShaders", true), Boolean)

  ///@type {Boolean}
  renderParticles = Assert.isType(Struct
    .getDefault(config, "properties.renderParticles", true), Boolean)

  ///@type {Boolean}
  renderSubtitles = Assert.isType(Struct
    .getDefault(config, "properties.renderSubtitles", true), Boolean)

  ///@type {Boolean}
  renderBackgroundGlitch = Struct.getIfType(config, "properties.renderBackgroundGlitch", Boolean, true)

  ///@type {Boolean}
  renderGridGlitch = Struct.getIfType(config, "properties.renderGridGlitch", Boolean, true)
  
  ///@type {Boolean}
  renderCombinedGlitch = Struct.getIfType(config, "properties.renderCombinedGlitch", Boolean, true)
  #endregion

  #region support-grid
  ///@type {Number}
  renderSupportGrid = Assert.isType(Struct
    .getDefault(config, "properties.renderSupportGrid", true), Boolean)

  ///@type {Number}
  supportGridTreshold = Assert.isType(Struct
    .getDefault(config, "properties.supportGridTreshold", 2), Number)

  ///@type {Number}
  supportGridAlpha = Assert.isType(Struct
    .getDefault(config, "properties.supportGridAlpha", 0.33), Number)

  ///@type {Color}
  supportGridBlendColor = Assert.isType(ColorUtil.fromHex(Struct
    .getDefault(config, "properties.supportGridColor", "#ffffff")), Color)

  ///@type {BlendConfig}
  supportGridBlendConfig = new BlendConfig(Struct
    .getIfType(config, "properties.supportGridBlendConfig", Struct))
  #endregion

  ///@type {Color}
  gridClearColor = Assert.isType(ColorUtil.fromHex(Struct
    .getDefault(config, "properties.gridClearColor", "#400421")), Color)

  ///@type {Boolean}
  gridClearFrame = Assert.isType(Struct
    .getDefault(config, "properties.gridClearFrame", true), Boolean)

  ///@type {Number}
  gridClearFrameAlpha = Assert.isType(Struct
    .getDefault(config, "properties.gridClearFrameAlpha", 0.0), Number)

  ///@type {BlendConfig}
  gridBlendConfig = new BlendConfig(Struct
    .getIfType(config, "properties.gridBlendConfig", Struct))

  ///@type {Color}
  shaderClearColor = Assert.isType(ColorUtil.fromHex(Struct
    .getDefault(config, "properties.shaderClearColor", "#00000000")), Color)

  ///@type {Boolean}
  shaderClearFrame = Assert.isType(Struct
    .getDefault(config, "properties.shaderClearFrame", true), Boolean)

  ///@type {Number}
  shaderClearFrameAlpha = Assert.isType(Struct
    .getDefault(config, "properties.shaderClearFrameAlpha", 0.0), Number)
  
  ///@type {Number}
  videoAlpha = Assert.isType(Struct
    .getDefault(config, "properties.videoAlpha", 1.0), Number)

  ///@type {Color}
  videoBlendColor = Assert.isType(ColorUtil.fromHex(Struct
    .getDefault(config, "properties.videoBlendColor", "#ffffff")), Color)
  
  ///@type {BlendConfig}
  videoBlendConfig = new BlendConfig(Struct.getIfType(config, "properties.videoBlendConfig", Struct))

  ///@type {Boolean}
  playerShadowEnable = Struct.getIfType(config, "properties.playerShadowEnable", Boolean, true)

  ///@type {Struct}
  depths = {
    gridZ: 2045,
    particleZ: 2100,//2047,
    bulletZ: 2048,
    shroomZ: 2049,
    coinZ: 2047,
    playerZ: 2051,
  }
  
  ///@private
  ///@type {Timer}
  separatorTimer = new Timer(FRAME_MS, { amount: this.speed / GRID_ITEM_SPEED_SCALE, loop: Infinity })

  ///@param {Struct} context
  ///@return {GridProperties}
  init = function(context) {
    var properties = this
    var pump = context.dispatcher
    var executor = context.executor
    pump.send(new Event("transform-property", {
      key: "channelsPrimaryAlpha",
      container: properties,
      executor: executor,
      transformer: new NumberTransformer({
        value: 0.0,
        target: 0.8,
        ease: EaseType.LINEAR,
        duration: 0.8,
      })
    }))
    pump.send(new Event("transform-property", {
      key: "channelsSecondaryAlpha",
      container: properties,
      executor: executor,
      transformer: new NumberTransformer({
        value: 0.0,
        target: 0.6,
        ease: EaseType.LINEAR,
        duration: 0.8,
      })
    }))
    pump.send(new Event("transform-property", {
      key: "separatorsPrimaryAlpha",
      container: properties,
      executor: executor,
      transformer: new NumberTransformer({
        value: 0.0,
        target: 0.8,
        ease: EaseType.LINEAR,
        duration: 0.8,
      })
    }))
    pump.send(new Event("transform-property", {
      key: "separatorsSecondaryAlpha",
      container: properties,
      executor: executor,
      transformer: new NumberTransformer({
        value: 0.0,
        target: 0.6,
        ease: EaseType.LINEAR,
        duration: 0.8,
      })
    }))

    return this
  }

  ///@param {GridService} gridService
  ///@return {GridProperties}
  update = function(gridService) {
    this.separatorTimer.duration = ((gridService.view.height * 2.0) / this.separators)
    this.separatorTimer.update()
    this.separatorTimer.amount = (this.speed / GRID_ITEM_SPEED_SCALE) - DeltaTime.apply(gridService.view.derivativeY)

    this.gridClearColor.alpha = this.gridClearFrameAlpha
    this.shaderClearColor.alpha = this.shaderClearFrameAlpha
    return this
  }
}

