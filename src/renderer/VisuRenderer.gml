///@package io.alkapivo.visu.renderer
show_debug_message("init VisuRenderer.gml")

global.fpsReportPath = null

///@enum
function _WallpaperType(): Enum() constructor {
  BACKGROUND = "BACKGROUND"
  GRID = "GRID"
  FOREGROUND = "FOREGROUND"
}
global.__WallpaperType = new _WallpaperType()
#macro WallpaperType global.__WallpaperType


///@type {GMArray<String>}
global.__VISU_FONT = [
  "font_kodeo_mono_10_bold",
  "font_kodeo_mono_12_bold",
  "font_kodeo_mono_18_bold",
  "font_kodeo_mono_28_bold",
  "font_kodeo_mono_48_bold",

  "font_inter_8_regular",
  "font_inter_10_regular",
  "font_inter_28_regular",

  "font_inter_8_bold",
  "font_inter_10_bold",
  "font_inter_28_bold",

  "font_consolas_10_regular",
  "font_consolas_28_regular",

  "font_consolas_10_bold",
  "font_consolas_28_bold"
]
#macro VISU_FONT global.__VISU_FONT


function VisuRenderer() constructor {

  ///@type {TaskExecutor}
  executor = new TaskExecutor(this, {
    loggerPrefix: "VisuRenderer",
    enableLogger: true,
    catchException: false,
  })

  ///@type {GridRenderer}
  gridRenderer = new GridRenderer()

  ///@type {SubtitleRenderer}
  subtitleRenderer = new SubtitleRenderer()

  ///@type {VisuHUDRenderer}
  hudRenderer = new VisuHUDRenderer()

  ///@type {DialogueRenderer}
  dialogueRenderer = new DialogueRenderer()

  ///@type {UILayout}
  layout = new UILayout({
    name: "visu-game-layout",
    x: function() { return 0 },
    y: function() { return 0 },
    width: GuiWidth,
    height: GuiHeight,
  })

  ///@type {Number}
  spinnerFactor = 0

  ///@type {Number}
  spinnerTime = 0
  
  ///@type {Timer}
  initTimer = new Timer(0.5)

  ///@type {Timer}
  fadeTimer = new Timer(0.25)

  ///@type {NumberTransformer}
  blur = new NumberTransformer({
    value: 0.0,
    target: 24.0,
    factor: 0.5,
    increase: 0.002,
  })

  ///@private
  ///@type {Sprite}
  spinner = Assert.isType(SpriteUtil.parse({ 
    name: "texture_spinner", 
    scaleX: 0.5, 
    scaleY: 0.5,
  }), Sprite, "VisuRenderer::spiner must be type of Sprite")

  ///@private
  ///@type {Font}
  font = new Font(font_kodeo_mono_18_bold)

  ///@private
  ///@type {Font}
  fontFps = new Font(font_kodeo_mono_12_bold)

  ///@private
  ///@type {Number}
  debugFPSLowCooldown = 0.0

  ///@private
  ///@type {Number}
  debugMinFPS = GAME_FPS

  ///@private
  ///@type {Number}
  debugDeltaHighCooldown = 0.0

  ///@private
  ///@type {Number}
  debugMaxDelta = 1.0

  ///@private
  ///@type {Number}
  debugMinFPSReal = fps_real

  ///@private
  ///@type {Number}
  debugMinFPSRealValue = fps_real

  ///@private
  ///@type {Number}
  debugMinFPSRealCooldown = GAME_FPS

  ///@private
  ///@type {Struct}
  shaderGaussianBlur = ShaderUtil.fetch("shader_gaussian_blur")

  ///@private
  ///@type {Boolean}
  renderEditorMode = Core.getProperty("visu.editor.renderEditorMode", false)

  ///@private
  ///@type {Boolean}
  menuInitialized = false

  ///@private
  ///@type {Boolean}
  menuOpen = false

  ///@private
  ///@param {UILayout} layout
  ///@return {VisuRenderer}
  renderSpinner = function(layout) {
    var controller = Beans.get(BeanVisuController)
    var loaderState = controller.loader.fsm.getStateName()
    if (loaderState == "clear-state") {
      var color = c_black
      var alpha = clamp(1.0 - (this.spinnerFactor / 100), 0.0, 1.0)
      if (alpha > 0) {
        GPU.render.rectangle(0, 0, GuiWidth(), GuiHeight(), false, 
          color, color, color, color, alpha)
      }
    }

    if (loaderState != "idle" && loaderState != "clear-state" && loaderState != "cooldown" && loaderState != "loaded") {
      //this.spinnerFactor = lerp(this.spinnerFactor, 100.0, 0.08)
      var ease = Ease.get(EaseType.IN_OUT_SINE)
      this.spinnerTime = clamp(this.spinnerTime + 0.016, 0.0, 1.0)
      this.spinnerFactor = ease(this.spinnerTime) * 100.0
      var color = c_black
      var alpha = clamp((this.spinnerFactor / 100) * 0.85, 0.0, 1.0)
      if (alpha > 0) {
        GPU.render.rectangle(0, 0, GuiWidth(), GuiHeight(), false, 
          color, color, color, color, alpha * 0.5)
      }

      this.spinner
        .setAngle(30.0 * (this.spinnerFactor / 100))
        .setAlpha(alpha)
        .render(GuiWidth() / 2.0, (GuiHeight() * 0.75) - this.spinnerFactor)
    } else if (this.spinnerFactor > 0.0) {
      //this.spinnerFactor = lerp(this.spinnerFactor, 0.0, 0.08)
      var ease = Ease.get(EaseType.IN_OUT_SINE)
      this.spinnerTime = clamp(this.spinnerTime - 0.016, 0.0, 1.0)
      this.spinnerFactor = ease(this.spinnerTime) * 100.0

      var color = c_black
      var alpha = clamp((this.spinnerFactor / 100) * 0.85, 0.0, 1.0)
      if (alpha > 0) {
        GPU.render.rectangle(
          0, 0, 
          GuiWidth(), GuiHeight(), 
          false, 
          color, color, color, color, 
          alpha * 0.5
        )
      }

      this.spinner
        .setAngle(-30.0 * (this.spinnerFactor / 100.0))
        .setAlpha(alpha)
        .render(GuiWidth() / 2.0, (GuiHeight() * 0.75) - this.spinnerFactor)
    }

    return this
  }

  
  fpsReport = ""
  fpsTimer = new Timer(2.0, { loop: Infinity })
  fpsReportTimer = new Timer(10.0, { loop: Infinity })
  generateRow = function(message) {
    var z = function(v) {
      return (v < 10 ? "0" : "") + string(v)
    }

    var date =
          string(current_year) + "-"
        + z(current_month) + "-"
        + z(current_day)   + "_"
        + z(current_hour)  + "-"
        + z(current_minute)+ "-"
        + z(current_second)

    return $"{date},{message}"
  }

  initFpsReport = function(filename) {
    global.fpsReportPath = $"{program_directory}{filename}"
    var file = file_text_open_write(global.fpsReportPath);
    var row = this.generateRow($"{abs(this.debugMinFPS)},{abs(this.debugMaxDelta)}")
    file_text_write_string(file, $"timestamp,FPS_MIN,DELTA_MAX\n{row}\n");
    file_text_close(file); 
  }
  
  
  ///@private
  ///@param {UILayout} layout
  ///@return {VisuRenderer}
  renderDebugGUI = function(layout) {
    var controller = Beans.get(BeanVisuController)
    var editor = Beans.get(Visu.modules().editor.controller)
    var gridService = controller.gridService
    var enableEditor = editor != null && editor.renderUI
    var enableDebugOverlay = is_debug_overlay_open()

    if (this.debugFPSLowCooldown > 0) {
      this.debugFPSLowCooldown--
    } else {
      this.debugMinFPS = GAME_FPS
    }

    var fpsReal = round(fps_real)
    if (fpsReal < this.debugMinFPS) {
      this.debugMinFPS = fpsReal
      this.debugFPSLowCooldown = GAME_FPS
    }

    if (this.debugDeltaHighCooldown > 0) {
      this.debugDeltaHighCooldown--
    } else {
      this.debugMaxDelta = DELTA_TIME
    }

    var deltaTime = DELTA_TIME
    if (deltaTime >= this.debugMaxDelta) {
      this.debugMaxDelta = deltaTime
      this.debugDeltaHighCooldown = GAME_FPS * 2
    }

    if (global.fpsReportPath != null && this.fpsTimer.update().finished) {
      var row = this.generateRow($"{abs(this.debugMinFPS)},{abs(this.debugMaxDelta)}")
      this.fpsReport = this.fpsReport == "" ? row : $"{this.fpsReport}\n{row}"
    }
    
    var gridCameraMessage = ""
    if (enableDebugOverlay) {
      var gridCamera = this.gridRenderer.camera
      if (enableEditor && (gridCamera.enableKeyboardLook || gridCamera.enableMouseLook)) {

        var g1 = String.format(gridCamera.x + (sin(this.gridRenderer.camera.breathTimer2.time) * GRID_SERVICE_PIXEL_WIDTH * -1.0), 4, 2)
        var g2 = String.format(gridCamera.y, 4, 2)
        var g3 = String.format(gridCamera.z, 4, 2)
        var g4 = String.format(gridCamera.pitch + (sin(this.gridRenderer.camera.breathTimer1.time) * BREATH_TIMER_FACTOR_1), 4, 2)
        var g5 = String.format(gridCamera.angle + (sin(this.gridRenderer.camera.breathTimer2.time / 4.0) * BREATH_TIMER_FACTOR_2), 4, 2)
        var h1 = String.format(gridService.view.x, 4, 2)
        var h2 = String.format(gridService.view.y, 4, 2)
        gridCameraMessage += ""
          + $"______________________\n"
          + $"|_______CAMERA_______|\n"
          + $"| x:         {   g1} |\n"
          + $"| y:         {   g2} |\n"
          + $"| z:         {   g3} |\n"
          + $"| pitch:     {   g4} |\n"
          + $"| angle:     {   g5} |\n"
          + $"|--------------------|\n"
          + $"| view.x:    {   h1} |\n"
          + $"| view.y:    {   h2} |\n"

        /*
              | x:         xxxx.xx
              | y:         xxxx.xx
              | z:         xxxx.xx
              | pitch:     xxxx.xx
              | angle:     xxxx.xx
              |-------------------
              | view.x:    xxxx.xx
              | view.y:    xxxx.xx
        */

        var player = controller.playerService.player
        var i1 = String.format((player == null ? 0.0 : player.x), 4, 2)
        var i2 = String.format((player == null ? 0.0 : player.y), 4, 2)
        gridCameraMessage += player == null ? "" :
          + $"|--------------------|\n"
          + $"| player.x:  {   i1} |\n"
          + $"| player.y:  {   i2} |\n"
        /*
              |-------------------
              | player.x:  xxxx.xx
              | player.y:  xxxx.xx
        */

        gridCameraMessage += $"|____________________|\n"
      }

      var shrooms = controller.shroomService.shrooms.size()
      var bullets = controller.bulletService.bullets.size()
  
      var renderSum = controller.renderTimer.getValue() + controller.renderGUITimer.getValue()
      var updateSum = controller.updateDebugTimer.getValue() + (enableEditor ? editor.updateDebugTimer.getValue() : 0.0)
      var timeSum = renderSum + updateSum
      gridService.avgTime.add(timeSum)
      gridService.avgCircular.add(fpsReal)

      var a1 = String.format(fps, 4, 0)
      var a2 = String.format(this.debugMinFPS, 4, 0)
      var b1 = String.format(fpsReal, 4, 0)
      var b2 = String.format(gridService.avgCircular.value, 4, 0)
      var c1 = String.format(updateSum, 2, 2)
      var c2 = String.format(renderSum, 2, 2)
      var d1 = String.format(timeSum, 2, 2)
      var d2 = String.format(gridService.avgTime.get(), 2, 2)
      var e1 = String.format(shrooms, 4, 0)
      var e2 = String.format(bullets, 4, 0)
      var f1 = String.format(deltaTime, 1, 5)
      var f2 = String.format(this.debugMaxDelta, 1, 5)
      var text = "\n"
        + $"_________________________________________\n"
        + $"|________________DEBUG__________________|\n" 
        + $"| fps:     {a1}    | fps-real:     {b1} |\n"
        + $"| fps-min: {a2}    | fps-real-avg: {b2} |\n"    
        +  "| -----------------|------------------- |\n"
        + $"| update: { c1} ms | total:    { d1} ms |\n"
        + $"| render: { c2} ms | avg:      { d2} ms |\n"
        +  "| -----------------|------------------- |\n"
        + $"| shrooms: {e1}    | dt:        {   f1} |\n"
        + $"| bullets: {e2}    | dt-max:    {   f2} |\n"
        + $"|__________________|____________________|\n"
        + gridCameraMessage
      
      /*
            fps:     xxxx    | fps-real:     xxxx
            fps-min: xxxx    | fps-real-avg: xxxx    
            -----------------|-------------------
            update: xxxxx ms | total:    xxxxx ms
            render: xxxxx ms | avg:      xxxxx ms
            -----------------|-------------------
            shrooms: xxxx    | dt:        xxxxxxx
            bullets: xxxx    | dt-max:    xxxxxxx
      */

      GPU.render.text(
        layout.x() + layout.width() - 32, 
        layout.y() + 4, 
        text, 
        1.0, 
        0.0, 
        1.0, 
        c_white, 
        this.fontFps, 
        HAlign.RIGHT, 
        VAlign.TOP, 
        c_black, 
        1.0
      )
    }



    return this
  }

  
  ///@private
  ///@param {UILayout} layout
  ///@return {VisuRenderer}
  renderFPS = function(layout) {
    var enableFPS = Visu.settings.getValue("visu.debug.render-fps")
    if (!enableFPS) {
      return this
    }

    this.debugMinFPSRealValue = min(this.debugMinFPSRealValue, fps_real)
    this.debugMinFPSRealCooldown--
    if (this.debugMinFPSRealCooldown < 0) {
      this.debugMinFPSRealCooldown = GAME_FPS
      this.debugMinFPSReal = this.debugMinFPSRealValue
      this.debugMinFPSRealValue = 9999
    }

    var fpsValue = String.format(fps, 4, 0)
    var fpsMin = String.format(min(fps, this.debugMinFPS), 4, 0)
    var fpsReal = String.format(fps_real, 4, 0)
    var fpsRealMin = String.format(this.debugMinFPSReal, 4, 0)

    var text = $"FPS: {fpsValue} | FPS min: {fpsMin} | FPS real: {fpsReal} | FPS real min: {fpsRealMin}"
    GPU.render.text(
      layout.x() + layout.width() - 32, 
      layout.y() + 4, 
      text, 
      1.0, 
      0.0, 
      1.0, 
      c_white, 
      this.fontFps, 
      HAlign.RIGHT, 
      VAlign.TOP, 
      c_black, 
      1.0
    )

    return this
  }

  ///@private
  ///@param {UILayout} layout
  ///@return {VisuRenderer}
  renderUI = function(layout) {
    var controller = Beans.get(BeanVisuController)
    controller.uiService.render()

    var editor = Beans.get(Visu.modules().editor.controller)
    if (editor != null && editor.renderUI) {
      editor.uiService.render()
    }

    return this
  }

  ///@private
  ///@param {Task} task
  ///@param {Number|String} iterator
  ///@param {UILayout} layout
  renderSplashscreen = function(task, iterator, layout) {
    if (task.name == "splashscreen") {
      task.state.render(task, layout)
    }
  }

  ///@private
  ///@param {Task} task
  ///@param {Number|String} iterator
  ///@param {UILayout} layout
  renderSceneClose = function(task, iterator, layout) {
    if (task.name == "scene-close") {
      task.state.render(task, layout)
    }
  }

  ///@private
  ///@param {Task} task
  ///@param {Number|String} iterator
  ///@param {UILayout} layout
  renderTextureLoad = function(task, iterator, layout) {
    if (task.name == "texture-load-task") {
      task.state.render(task, layout)
    }
  }

  ///@private
  ///@param {UILayout} layout
  ///@return {VisuRenderer}
  renderMenu = function(layout) {
    var controller = Beans.get(BeanVisuController)
    if (controller.menu.enabled) {
      return this
    }

    if (this.blur.target != 0.0) {
      this.blur.target = 0.0
      this.blur.startValue = this.blur.value
      this.blur.reset()
    }
    
    this.gridRenderer.renderGUI(layout)
    this.subtitleRenderer.renderGUI(layout)  
    if (Visu.settings.getValue("visu.interface.render-hud")) {
      this.hudRenderer.renderGUI(layout)
    }

    var state = controller.fsm.getStateName() 
    if (state == "idle") {
      var player = controller.playerService.player
      var keyboard = Beans.get(BeanVisuIO).keyboards.get("player")
      if (player == null) {
        keyboard.update()
      }

      var up = keyboard.keys.up.pressed || keyboard_check_pressed(vk_up)
      var down = keyboard.keys.down.pressed || keyboard_check_pressed(vk_down)
      var action = keyboard.keys.action.pressed || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space) || mouse_check_button_pressed(mb_left)
      this.dialogueRenderer.render(layout, up, down, action)
    }

    var editor = Beans.get(Visu.modules().editor.controller)
    if (this.renderEditorMode 
        && editor != null 
        && !editor.renderUI 
        && (state == "idle"
          || state == "play"
          || state == "pause"
          || state == "paused")) {
      var _x = layout.x()
      var _y = layout.y()
      var _width = layout.width()
      var _height = layout.height()
      var xStart = _width * (1.0 - 0.061)
      var yStart = _height * (1.0 - 0.08)
      var text = Language.get("visu.editor.hud.show-editor")
      GPU.render.text(_x + xStart, _y + yStart, text, 1.0, 0.0, 0.6, c_white, this.font, HAlign.RIGHT, VAlign.BOTTOM, c_lime, 8.0)
    }
    return this
  }

  ///@private
  ///@return {GrindRenderer}
  renderDebugSurfaces = function() {
    var width = round(GuiWidth() / 2.0)
    var height = round(GuiHeight() / 2.0)
    var marginX = 28
    var marginY = 28
    var alpha = 1.0
    var angle = 0.0
    var scale = 1.0
    var color = c_white
    var font = GPU_DEFAULT_FONT_BOLD
    var alignH = HAlign.LEFT
    var alignV = VAlign.TOP
    var outlineColor = c_black
    var outlineFactor = 1.0
    var renderGridItemSurface = Visu.settings.getValue("visu.graphics.grid-item-surface")

    this.gridRenderer.gridSurface
      .renderStretched(width, height, width * 0.0, height * 0.0)

    this.gridRenderer.backgroundSurface
      .renderStretched(width, height, width * 1.0, height * 0.0)
    
    if (renderGridItemSurface) {
      this.gridRenderer.gridItemSurface
        .renderStretched(width, height, width * 0.0, height * 1.0)
    }

    this.gridRenderer.gameSurface
      .renderStretched(width, height, width * 1.0, height * 1.0)

    
    GPU.render.text(marginX + (width * 0.0), marginY + (height * 0.0), "gridSurface",
      scale, angle, alpha, color, font, alignH, alignV, outlineColor, outlineFactor)

    GPU.render.text(marginX + (width * 1.0), marginY + (height * 0.0), "backgroundSurface",
      scale, angle, alpha, color, font, alignH, alignV, outlineColor, outlineFactor)
    
    if (renderGridItemSurface) {
      GPU.render.text(marginX + (width * 0.0), marginY + (height * 1.0), "gridItemSurface",
      scale, angle, alpha, color, font, alignH, alignV, outlineColor, outlineFactor)
    }

    GPU.render.text(marginX + (width * 1.0), marginY + (height * 1.0), "gameSurface",
      scale, angle, alpha, color, font, alignH, alignV, outlineColor, outlineFactor)
    
    return this
  }

  ///@param {UILayout} layout
  ///@return {GridRenderer}
  renderGUIGameSurface = function(layout) {
    var _width = layout.width()
    var _height = layout.height()
    var _x = layout.x()
    var _y = layout.y()
    this.gridRenderer.gameSurface.renderStretched(_width, _height, _x, _y)
    return this
  }

  ///@private
  ///@param {UILayout} layout
  ///@return {VisuRenderer}
  renderGame = function(layout) {
    if (!Beans.get(BeanVisuController).menu.enabled) {
      return this
    }

    var blur = this.blur.update().value
    var enableBlur = Visu.settings.getValue("visu.graphics.menu-blur")
    var renderBlur = Visu.settings.getValue("visu.debug.render-surfaces")
      ? this.renderDebugSurfaces
      : this.renderGUIGameSurface

    if (enableBlur && blur > 0.0) {
      GPU.set.shader(this.shaderGaussianBlur)
      var uniform = this.shaderGaussianBlur.uniforms.get("u_resolution")
      uniform.setter(uniform.asset, layout.width(), layout.height())
      this.shaderGaussianBlur.uniforms.get("u_size").set(blur)
      renderBlur(layout)
      GPU.reset.shader()
    } else {
      renderBlur(layout)
    }
    return this
  }

  ///@private
  ///@param {Timer} timer
  ///@return {VisuRenderer}
  renderFadeBackground = function (timer) {
    if (timer.finished) {
      return this
    }

    var alpha = clamp(timer.duration - timer.time, 0.0, 1.0)
    if (alpha <= 0) {
      return this
    }

    GPU.render.rectangle(0, 0, GuiWidth(), GuiHeight(), false, c_black, c_black, c_black, c_black, alpha)
    return this
  }

  ///@return {VisuRenderer}
  update = function() {
    var controller = Beans.get(BeanVisuController)
    var editor = Beans.get(Visu.modules().editor.controller)
    var layout = editor == null ? this.layout : editor.layout.nodes.preview
    var stateName = controller.fsm.getStateName()
    if (stateName != "splashscreen") {
      this.initTimer.update()
      this.fadeTimer.update()
      this.gridRenderer.update(layout)
      this.hudRenderer.update(layout)
      this.dialogueRenderer.update()
    }

    if (!this.menuInitialized) {
      if (!this.menuOpen) {
        var factory = controller.menu.factories.get("menu-main")
        controller.menu.send(factory())
        controller.menu.update()
        controller.updateUIService()
        this.menuOpen = true
      } else {
        controller.menu.send(new Event("close"))
        controller.menu.update()
        controller.updateUIService()
        this.menuInitialized = true
      }
    }

    this.executor.update()

    if (global.fpsReportPath != null && this.fpsReportTimer.update().finished) {
      var file = file_text_open_append(global.fpsReportPath)
      if (file != -1) {
        file_text_write_string(file, this.fpsReport)
        file_text_writeln(file)
        file_text_close(file)
        this.fpsReport = ""
      }
    }

    return this
  }
  
  ///@return {VisuRenderer}
  render = function() {
    var controller = Beans.get(BeanVisuController)
    var editor = Beans.get(Visu.modules().editor.controller)
    var layout = editor == null ? this.layout : editor.layout.nodes.preview
    var stateName = controller.fsm.getStateName()
    if (stateName != "splashscreen") {
      this.gridRenderer.render(layout)
    }

    return this
  }

  ///@return {VisuRenderer}
  renderGUI = function() {
    var controller = Beans.get(BeanVisuController)
    var editor = Beans.get(Visu.modules().editor.controller)
    var layout = editor == null ? this.layout : editor.layout.nodes.preview
    var stateName = controller.fsm.getStateName()
    if (stateName == "splashscreen") {
      this.executor.tasks.forEach(this.renderSplashscreen, layout)
    } else {
      if (stateName == "load") {
        this.executor.tasks.forEach(this.renderTextureLoad, layout)
      }
      
      this.renderMenu(layout)
      this.renderGame(layout)
      this.renderUI(layout)
      this.renderSpinner(layout)
      this.renderDebugGUI(layout)
      this.renderFadeBackground(this.initTimer)
      this.renderFadeBackground(this.fadeTimer)
      this.renderFPS(layout)
      
      if (stateName == "scene-close") {
        this.executor.tasks.forEach(this.renderSceneClose, layout)
      }
    }

    return this
  }

  ///@return {VisuRenderer}
  free = function() {
    this.gridRenderer.free()
    return this
  }
}
