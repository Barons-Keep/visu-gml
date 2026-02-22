///@package io.alkapivo.visu.editor.service.brush.entity

///@param {Struct} json
///@return {Struct}
function brush_entity_bullet(json) {
  static sortEmitter =  function(key, index, emitter) {
    var value = Struct.get(emitter.json, key)
    var json = Struct.set({}, key, value)
    var array = String.split(JSON.stringify(json, true), "\n")
    emitter.array.add(array.remove(0).remove(array.size() - 1).join("\n"))
  }

  var emitterConfig = Struct.getIfType(json, "en-blt_em-cfg", Struct)
  var emitter = {
    json: emitterConfig != null
      ? emitterConfig
      : {
          amount: 1,
          duration: 0,
          arrays: {
            value: 1,
            target: 1,
            duration: 0,
            ease: "LINEAR",
          },
          perArray: 1,
          angle: {
            value: 0,
            target: 0,
            duration: 0,
            ease: "LINEAR",
          },
          angleRng: 0,
          angleStep: {
            value: 0,
            target: 0,
            duration: 0,
            ease: "LINEAR",
          },
          anglePerArray: 0,
          anglePerArrayRng: 0,
          anglePerArrayStep: 0,
          speed: {
            value: 0,
            target: 0,
            duration: 0,
            ease: "LINEAR",
          },
          speedRng: 0,
          offset: {
            value: 0.0,
            target: 0.0,
            duration: 0.0,
            ease: "LINEAR",
          },
          offsetX: {
            value: 0.0,
            target: 0.0,
            duration: 0.0,
            ease: "LINEAR",
          },
          offsetY: {
            value: 0.0,
            target: 0.0,
            duration: 0.0,
            ease: "LINEAR",
          },
          wiggleFrequency: 0.0,
          wiggleAmplitude: {
            value: 0.0,
            target: 0.0,
            duration: 0.0,
            ease: "LINEAR",
          },
        },
    array: new Array(String),
  }
  
  GMArray.forEach(GMArray.sort(Struct.keys(emitter.json)), sortEmitter, emitter)
  var text = emitter.array.join(",\n")
  var emitterJSON = $"\{\n{text}\n\}"

  var store = {
    "en-blt_preview": {
      type: Boolean,
      value: Struct.get(json, "en-blt_preview"),
    },
    "en-blt_template": {
      type: String,
      value: Struct.get(json, "en-blt_template"),
      passthrough: UIUtil.passthrough.getCallbackValue(),
      data: {
        callback: Beans.get(BeanVisuController).bulletTemplateExists,
        defaultValue: "bullet-default",
      },
    },
    "en-blt_use-lifespan": {
      type: Boolean,
      value: Struct.get(json, "en-blt_use-lifespan")
    },
    "en-blt_lifespan": {
      type: Number,
      value: Struct.get(json, "en-blt_lifespan"),
      passthrough: UIUtil.passthrough.getClampedStringNumber(),
      data: new Vector2(0.0, 999.9),
    },
    "en-blt_use-dmg": {
      type: Boolean,
      value: Struct.get(json, "en-blt_use-dmg"),
    },
    "en-blt_dmg": {
      type: Number,
      value: Struct.get(json, "en-blt_dmg"),
      passthrough: UIUtil.passthrough.getClampedStringNumber(),
      data: new Vector2(0.0, 9999999.9),
    },
    "en-blt_spd": {
      type: Number,
      value: Struct.get(json, "en-blt_spd"),
      passthrough: UIUtil.passthrough.getClampedStringNumber(),
      data: new Vector2(0.0, 99.9),
    },
    "en-blt_spd-grid": {
      type: Boolean,
      value: Struct.get(json, "en-blt_spd-grid"),
    },
    "en-blt_use-spd-rng": {
      type: Boolean,
      value: Struct.get(json, "en-blt_use-spd-rng"),
    },
    "en-blt_spd-rng": {
      type: Number,
      value: Struct.get(json, "en-blt_spd-rng"),
      passthrough: UIUtil.passthrough.getClampedStringNumber(),
      data: new Vector2(0.0, 99.9),
    },
    "en-blt_dir": {
      type: Number,
      value: Struct.get(json, "en-blt_dir"),
      passthrough: UIUtil.passthrough.getClampedStringNumber(),
      data: new Vector2(0.0, 360.0),
    },
    "en-blt_use-dir-rng": {
      type: Boolean,
      value: Struct.get(json, "en-blt_use-dir-rng"),
    },
    "en-blt_dir-rng": {
      type: Number,
      value: Struct.get(json, "en-blt_dir-rng"),
      passthrough: UIUtil.passthrough.getClampedStringNumber(),
      data: new Vector2(0.0, 360.0),
    },
    "en-blt_x": {
      type: Number,
      value: Struct.get(json, "en-blt_x", Number, 0),
      passthrough: UIUtil.passthrough.getClampedStringNumber(),
      data: new Vector2(
        -1.0 * (SHROOM_SPAWN_AMOUNT / 2.0), 
        SHROOM_SPAWN_AMOUNT / 2.0
      ),
    },
    "en-blt_snap-x": {
      type: Boolean,
      value: Struct.get(json, "en-blt_snap-x"),
    },
    "en-blt_use-rng-x": {
      type: Boolean,
      value: Struct.get(json, "en-blt_use-rng-x"),
    },
    "en-blt_rng-x": {
      type: Number,
      value: Struct.get(json, "en-blt_rng-x", Number, 0),
      passthrough: UIUtil.passthrough.getClampedStringNumber(),
      data: new Vector2(
        0.0, 
        SHROOM_SPAWN_AMOUNT / 2.0
      ),
    },
    "en-blt_y": {
      type: Number,
      value: Struct.get(json, "en-blt_y", Number, 0),
      passthrough: UIUtil.passthrough.getClampedStringNumber(),
      data: new Vector2(
        -1.0 * (SHROOM_SPAWN_AMOUNT / 2.0), 
        SHROOM_SPAWN_AMOUNT / 2.0
      ),
    },
    "en-blt_snap-y": {
      type: Boolean,
      value: Struct.get(json, "en-blt_snap-y"),
    },
    "en-blt_use-rng-y": {
      type: Boolean,
      value: Struct.get(json, "en-blt_use-rng-y"),
    },
    "en-blt_rng-y": {
      type: Number,
      value: Struct.get(json, "en-blt_rng-y", Number, 0),
      passthrough: UIUtil.passthrough.getClampedStringNumber(),
      data: new Vector2(
        0.0, 
        SHROOM_SPAWN_AMOUNT / 2.0
      ),
    },
    "en-blt_use-texture": {
      type: Boolean,
      value: Struct.get(json, "en-blt_use-texture"),
    },
    "en-blt_texture": {
      type: Sprite,
      value: Struct.get(json, "en-blt_texture"),
    },
    "en-blt_use-mask": {
      type: Boolean,
      value: Struct.get(json, "en-blt_use-mask"),
    },
    "en-blt_mask": {
      type: Rectangle,
      value: Struct.get(json, "en-blt_mask"),
    },
    "en-blt_spawn-map": {
      type: TextureTemplate,
      value: new TextureTemplate("texture_shroom_spawn_map", { asset: texture_shroom_spawn_map, file: "" }),
    },
    "en-blt_hide": {
      type: Boolean,
      value: Struct.get(json, "en-blt_hide"),
    },
    "en-blt_hide-spawn": {
      type: Boolean,
      value: Struct.get(json, "en-blt_hide-spawn"),
    },
    "en-blt_hide-em": {
      type: Boolean,
      value: Struct.get(json, "en-blt_hide-em"),
    },
    "en-blt_hide-em-cfg": {
      type: Boolean,
      value: Struct.get(json, "en-blt_hide-em-cfg"),
    },
    "en-blt_hide-em-angle": {
      type: Boolean,
      value: Struct.get(json, "en-blt_hide-em-angle"),
    },
    "en-blt_hide-em-per-array": {
      type: Boolean,
      value: Struct.get(json, "en-blt_hide-em-per-array"),
    },
    "en-blt_hide-em-spd": {
      type: Boolean,
      value: Struct.get(json, "en-blt_hide-em-spd"),
    },
    "en-blt_hide-em-offset-x": {
      type: Boolean,
      value: Struct.get(json, "en-blt_hide-em-offset-x"),
    },
    "en-blt_hide-em-offset-y": {
      type: Boolean,
      value: Struct.get(json, "en-blt_hide-em-offset-y"),
    },
    "en-blt_hide-em-wiggle-freq": {
      type: Boolean,
      value: Struct.get(json, "en-blt_hide-em-wiggle-freq"),
    },
    "en-blt_hide-em-wiggle-amp": {
      type: Boolean,
      value: Struct.get(json, "en-blt_hide-em-wiggle-amp"),
    },
    "en-blt_use-em": {
      type: Boolean,
      value: Struct.get(json, "en-blt_use-em"),
    },
    "en-blt_em-cfg": {
      type: String,
      value: emitterJSON,
      serialize: UIUtil.serialize.getStringStruct(),
      passthrough: UIUtil.passthrough.getStringStruct(),
    },
  }

  var components = new Array(Struct, [
    {
      name: "en-blt_hide",
      template: VEComponents.get("property"),
      layout: VELayouts.get("property"),
      config: { 
        layout: { type: UILayoutType.VERTICAL },
        label: { 
          text: "Properties",
          //backgroundColor: VETheme.color.accentShadow,
        },
        checkbox: { 
          spriteOn: { name: "visu_texture_checkbox_show" },
          spriteOff: { name: "visu_texture_checkbox_hide" },
          store: { key: "en-blt_hide" },
          //backgroundColor: VETheme.color.accentShadow,
        },
        input: {
          //backgroundColor: VETheme.color.accentShadow,
        },
      },
    },
    {
      name: "en-blt_template",  
      template: VEComponents.get("text-field"),
      layout: VELayouts.get("text-field"),
      config: { 
        layout: { 
          type: UILayoutType.VERTICAL,
          //margin: { top: 2, bottom: 2 },
        },
        label: {
          text: "Template",
          hidden: { key: "en-blt_hide" },
        },
        field: {
          store: { key: "en-blt_template" },
          hidden: { key: "en-blt_hide" },
        },
      },
    },
    {
      name: "en-blt_lifespan",
      template: VEComponents.get("numeric-input"),
      layout: VELayouts.get("div"),
      config: { 
        layout: { type: UILayoutType.VERTICAL },
        label: { 
          text: "Lifespan",
          enable: { key: "en-blt_use-lifespan" },
          hidden: { key: "en-blt_hide" },
        },  
        field: { 
          store: { key: "en-blt_lifespan" },
          enable: { key: "en-blt_use-lifespan" },
          hidden: { key: "en-blt_hide" },
        },
        decrease: {
          store: { key: "en-blt_lifespan" },
          enable: { key: "en-blt_use-lifespan" },
          factor: -0.1,
          hidden: { key: "en-blt_hide" },
        },
        increase: {
          store: { key: "en-blt_lifespan" },
          enable: { key: "en-blt_use-lifespan" },
          factor: 0.1,
          hidden: { key: "en-blt_hide" },
        },
        stick: {
          store: { key: "en-blt_lifespan" },
          enable: { key: "en-blt_use-lifespan" },
          factor: 0.1,
          step: 10.0,
          hidden: { key: "en-blt_hide" },
        },
        checkbox: {
          store: { key: "en-blt_use-lifespan" },
          spriteOn: { name: "visu_texture_checkbox_on" },
          spriteOff: { name: "visu_texture_checkbox_off" },
          hidden: { key: "en-blt_hide" },
        },
        title: {
          text: "Override",
          enable: { key: "en-blt_use-lifespan" },
          hidden: { key: "en-blt_hide" },
        }
      },
    },
    {
      name: "en-blt_dmg",
      template: VEComponents.get("numeric-input"),
      layout: VELayouts.get("div"),
      config: { 
        layout: { type: UILayoutType.VERTICAL },
        label: { 
          text: "Damage",
          enable: { key: "en-blt_use-dmg" },
          hidden: { key: "en-blt_hide" },
        },  
        field: { 
          store: { key: "en-blt_dmg" },
          enable: { key: "en-blt_use-dmg" },
          hidden: { key: "en-blt_hide" },
        },
        decrease: {
          store: { key: "en-blt_dmg" },
          enable: { key: "en-blt_use-dmg" },
          factor: -0.1,
          hidden: { key: "en-blt_hide" },
        },
        increase: {
          store: { key: "en-blt_dmg" },
          enable: { key: "en-blt_use-dmg" },
          factor: 0.1,
          hidden: { key: "en-blt_hide" },
        },
        stick: {
          store: { key: "en-blt_dmg" },
          enable: { key: "en-blt_use-dmg" },
          factor: 0.1,
          step: 10.0,
          hidden: { key: "en-blt_hide" },
        },
        checkbox: {
          store: { key: "en-blt_use-dmg" },
          spriteOn: { name: "visu_texture_checkbox_on" },
          spriteOff: { name: "visu_texture_checkbox_off" },
          hidden: { key: "en-blt_hide" },
        },
        title: {
          text: "Override",
          enable: { key: "en-blt_use-dmg" },
          hidden: { key: "en-blt_hide" },
        }
      },
    },
    {
      name: "en-blt-template-line-h",
      template: VEComponents.get("line-h"),
      layout: VELayouts.get("line-h"),
      config: {
        layout: { type: UILayoutType.VERTICAL },
        image: { hidden: { key: "en-blt_hide" } },
      },
    },
    {
      name: "en-blt_hide-spawn",
      template: VEComponents.get("property"),
      layout: VELayouts.get("property"),
      config: { 
        layout: { type: UILayoutType.VERTICAL },
        label: { 
          text: "Spawner",
          //backgroundColor: VETheme.color.accentShadow,
        },
        checkbox: { 
          spriteOn: { name: "visu_texture_checkbox_show" },
          spriteOff: { name: "visu_texture_checkbox_hide" },
          store: { key: "en-blt_hide-spawn" },
          //backgroundColor: VETheme.color.accentShadow,
        },
        input: {
          //backgroundColor: VETheme.color.accentShadow,
        },
      },
    },
    {
      name: "en-blt_preview",
      template: VEComponents.get("property"),
      layout: VELayouts.get("property"),
      config: { 
        layout: { type: UILayoutType.VERTICAL },
        label: { 
          text: "Show spawner",
          enable: { key: "en-blt_preview" },
          backgroundColor: VETheme.color.side,
          updateCustom: function() {
            this.preRender()
            if (Core.isType(this.context.updateTimer, Timer)) {
              var inspectorType = this.context.state.get("inspectorType")
              switch (inspectorType) {
                case VEEventInspector:
                  var shroomService = Beans.get(BeanVisuController).shroomService
                  if (shroomService.spawnerEvent != null) {
                    shroomService.spawnerEvent.timeout = ceil(this.context.updateTimer.duration * 60)
                  }
                  break
                case VEBrushToolbar:
                  var shroomService = Beans.get(BeanVisuController).shroomService
                  if (shroomService.spawner != null) {
                    shroomService.spawner.timeout = ceil(this.context.updateTimer.duration * 60)
                  }
                  break
              }
            }
          },
          preRender: function() {
            var store = null
            if (Core.isType(this.context.state.get("brush"), VEBrush)) {
              store = this.context.state.get("brush").store
              if (store == null || !store.getValue("en-blt_preview")) {
                Beans.get(BeanVisuController).shroomService.spawner = null
              }
            }
            
            if (Core.isType(this.context.state.get("event"), VEEvent)) {
              store = this.context.state.get("event").store
              if (store == null || !store.getValue("en-blt_preview")) {
                Beans.get(BeanVisuController).shroomService.spawnerEvent = null
              }
            }

            if (!Optional.is(store) || !store.getValue("en-blt_preview")) {
              return
            }

            var controller = Beans.get(BeanVisuController)
            var locked = controller.gridService.targetLocked
            var view = controller.gridService.view

            if (!Struct.contains(this, "spawnerXTimer")) {
              Struct.set(this, "spawnerXTimer", new Timer(pi * 2, { 
                loop: Infinity,
                amount: FRAME_MS * 4,
                shuffle: true
              }))
            }

            var _x = store.getValue("en-blt_x") * (SHROOM_SPAWN_SIZE / SHROOM_SPAWN_AMOUNT) + 0.5
            if (store.getValue("en-blt_use-rng-x")) {
              _x += sin(this.spawnerXTimer.update().time) * (store.getValue("en-blt_rng-x") * (SHROOM_SPAWN_SIZE / SHROOM_SPAWN_AMOUNT) / 2.0)
            }

            if (store.getValue("en-blt_snap-x")) {
              _x = _x - (view.x - locked.snapH)
            }

            if (!Struct.contains(this, "spawnerYTimer")) {
              Struct.set(this, "spawnerYTimer", new Timer(pi * 2, { 
                loop: Infinity,
                amount: FRAME_MS * 4,
                shuffle: true
              }))
            }

            var _y = store.getValue("en-blt_y") * (SHROOM_SPAWN_SIZE / SHROOM_SPAWN_AMOUNT) - 0.5
            if (store.getValue("en-blt_use-rng-y")) {
              _y += sin(this.spawnerYTimer.update().time) * (store.getValue("en-blt_rng-y") * (SHROOM_SPAWN_SIZE / SHROOM_SPAWN_AMOUNT) / 2.0)
            }

            if (store.getValue("en-blt_snap-y")) {
              _y = _y - (view.y - locked.snapV)
            }

            if (!Struct.contains(this, "spawnerAngleTimer")) {
              Struct.set(this, "spawnerAngleTimer", new Timer(pi * 2, { 
                loop: Infinity,
                amount: FRAME_MS * 4,
                shuffle: true
              }))
            }

            var angle = store.getValue("en-blt_dir")
            if (store.getValue("en-blt_use-dir-rng")) {
              angle += sin(this.spawnerAngleTimer.update().time) * (store.getValue("en-blt_dir-rng") / 2.0)
            }

            var inspectorType = this.context.state.get("inspectorType")
            switch (inspectorType) {
              case VEEventInspector:
                var shroomService = Beans.get(BeanVisuController).shroomService
                shroomService.spawnerEvent = shroomService.factorySpawner({ 
                  x: _x, 
                  y: _y, 
                  sprite: SpriteUtil.parse({ 
                    name: "texture_visu_shroom_spawner", 
                    blend: "#43abfa",
                    angle: angle,
                  })
                })
                break
              case VEBrushToolbar:
                var shroomService = Beans.get(BeanVisuController).shroomService
                shroomService.spawner = shroomService.factorySpawner({ 
                  x: _x, 
                  y: _y, 
                  sprite: SpriteUtil.parse({
                    name: "texture_visu_shroom_spawner",
                    blend: "#f757ef",
                    angle: angle,
                  })
                })
                break
            }
          },
          hidden: { key: "en-blt_hide-spawn" },
        },
        checkbox: { 
          spriteOn: { name: "visu_texture_checkbox_on" },
          spriteOff: { name: "visu_texture_checkbox_off" },
          store: { key: "en-blt_preview" },
          backgroundColor: VETheme.color.side,
          hidden: { key: "en-blt_hide-spawn" },
        },
        input: {
          backgroundColor: VETheme.color.side,
          hidden: { key: "en-blt_hide-spawn" },
        }
      },
    },
    {
      name: "en-blt_spawn-map",
      template: VEComponents.get("texture-field-intent"),
      layout: VELayouts.get("texture-field-intent-simple"),
      config: { 
        layout: { 
          type: UILayoutType.VERTICAL,
        },
        preview: {
          image: {
            name: "texture_shroom_spawn_map",
            disableTextureService: true,
          },
          store: { key: "en-blt_spawn-map" },
          hidden: { key: "en-blt_hide-spawn" },
          origin: "en-blt_spawn-map",
          onMousePressedLeft: function(event) {
            var editorIO = Beans.get(BeanVisuEditorIO)
            var mouse = editorIO.mouse
            if (Optional.is(mouse.getClipboard())) {
              return
            }

            var _x = event.data.x - this.context.area.getX() - this.area.getX() - this.context.offset.x
            var _y = event.data.y - this.context.area.getY() - this.area.getY() - this.context.offset.y
            var areaWidth = this.area.getWidth()
            var areaHeight = this.area.getHeight()
            var scaleX = this.image.getScaleX()
            var scaleY = this.image.getScaleY()
            this.image.scaleToFit(areaWidth, areaHeight)

            var width = this.image.getWidth() * this.image.getScaleX()
            var height = this.image.getHeight() * this.image.getScaleY()
            this.image.setScaleX(scaleX).setScaleY(scaleY)

            var marginH = (areaWidth - width) / 2.0
            var marginV = (areaHeight - height) / 2.0
            if ((_x >= marginH && _x <= areaWidth - marginH)
              && (_y >= marginV && _y <= areaHeight - marginV)) {
              mouse.setClipboard(this)  
            }
          },
          onMouseOnLeft: function(event) {
            if (!Optional.is(this.store)) {
              return
            }

            var editorIO = Beans.get(BeanVisuEditorIO)
            var mouse = editorIO.mouse
            if (mouse.getClipboard() != this) {
              return
            }

            var _x = event.data.x - this.context.area.getX() - this.area.getX() - this.context.offset.x
            var _y = event.data.y - this.context.area.getY() - this.area.getY() - this.context.offset.y
            var areaWidth = this.area.getWidth()
            var areaHeight = this.area.getHeight()
            var scaleX = this.image.getScaleX()
            var scaleY = this.image.getScaleY()
            this.image.scaleToFit(areaWidth, areaHeight)

            var width = this.image.getWidth() * this.image.getScaleX()
            var height = this.image.getHeight() * this.image.getScaleY()
            this.image.setScaleX(scaleX).setScaleY(scaleY)

            var marginH = (areaWidth - width) / 2.0
            var marginV = (areaHeight - height) / 2.0

            var originX = round(this.image.getWidth() * ((clamp(_x, marginH, areaWidth - marginH) - marginH) / width))
            var originY = round(this.image.getHeight() * ((clamp(_y, marginV, areaHeight - marginV) - marginV) / height))

            var textureIntent = this.store.getValue()
            if (textureIntent.originX != originX
                || textureIntent.originY != originY) {
              textureIntent.originX = originX
              textureIntent.originY = originY
              this.store.get().set(textureIntent)

              var store = this.store.getStore()
              if (Optional.is(store)) {
                var horizontal = round(((originX / this.image.getWidth()) * SHROOM_SPAWN_AMOUNT) - (SHROOM_SPAWN_AMOUNT / 2.0))
                var vertical = round(((originY / this.image.getHeight()) * SHROOM_SPAWN_AMOUNT) - (SHROOM_SPAWN_AMOUNT / 2.0))
                store.get("en-blt_x").set(horizontal)
                store.get("en-blt_y").set(vertical)
              }
            }

            return this
          },
          preRender: function() {
            if (!Optional.is(this.store)) {
              return
            }

            var store = this.store.getStore()
            if (!Optional.is(store)) {
              return
            }

            var horizontal = (store.getValue("en-blt_x") + (SHROOM_SPAWN_AMOUNT / 2.0)) / SHROOM_SPAWN_AMOUNT
            var vertical = (store.getValue("en-blt_y") + (SHROOM_SPAWN_AMOUNT / 2.0)) / SHROOM_SPAWN_AMOUNT
            var originX = round(horizontal * this.image.getWidth())
            var originY = round(vertical * this.image.getHeight())
            var textureIntent = this.store.getValue()
            if (textureIntent.originX != originX
              || textureIntent.originY != originY) {
              textureIntent.originX = originX
              textureIntent.originY = originY
              this.store.get().set(textureIntent)
            }
                    
            if (mouse_check_button(mb_left)) {
              Beans.get(BeanVisuEditorController).uiService.send(new Event("MouseOnLeft", { 
                x: MouseUtil.getMouseX(), 
                y: MouseUtil.getMouseY(),
              }))
            }
          },
          postRender: function() {              
            if (!Optional.is(this.store)) {
              return
            }

            var store = this.store.getStore()
            if (!Optional.is(this.origin) || !Optional.is(store)) {
              return
            }

            if (!Struct.contains(this, "spawnerAngleTimer")) {
              Struct.set(this, "spawnerAngleTimer", new Timer(pi * 2, { 
                loop: Infinity,
                amount: FRAME_MS * 4,
                shuffle: true
              }))
            }

            var angle = store.getValue("en-blt_dir")
            if (store.getValue("en-blt_use-dir-rng")) {
              angle += sin(this.spawnerAngleTimer.update().time) * (store.getValue("en-blt_dir-rng") / 2.0)
            }

            var textureTemplate = store.getValue(this.origin)
            var originX = textureTemplate.originX
            var originY = textureTemplate.originY
            var scaleX = this.image.getScaleX()
            var scaleY = this.image.getScaleY()
            this.image.scaleToFit(this.area.getWidth(), this.area.getHeight())
            var _x = this.context.area.getX() 
              + this.area.getX()
              + (this.area.getWidth() / 2.0)
              - ((this.image.getWidth() * this.image.getScaleX()) / 2.0)
              + (originX * this.image.getScaleX())
              + Math.fetchCircleX(8, angle)
            var _y = this.context.area.getY() 
              + this.area.getY()
              + (this.area.getHeight() / 2.0)
              - ((this.image.getHeight() * this.image.getScaleY()) / 2.0)
              + (originY * this.image.getScaleY())
              + Math.fetchCircleY(8, angle)
            this.image.setScaleX(scaleX).setScaleY(scaleY)

            var width = sprite_get_width(visu_texture_ui_angle_arrow)
            var height = sprite_get_height(visu_texture_ui_angle_arrow)
            draw_sprite_ext(visu_texture_ui_angle_arrow, 0, _x, _y, 32.0 / width, 32.0 / height, angle, c_white, 1.0)
          },
        },
        resolution: { 
          store: { 
            key: "en-blt_spawn-map",
            callback: function(value, data) { 
              if (!Core.isType(value, TextureTemplate)) {
                return
              }
              
              data.label.text = ""//$"width: {sprite_get_width(value.asset)} height: {sprite_get_height(value.asset)}"
            },
          },
          hidden: { key: "en-blt_hide-spawn" },
        },
      },
    },
    //{
    //  name: "en-blt-spawn-map-line-h",
    //  template: VEComponents.get("line-h"),
    //  layout: VELayouts.get("line-h"),
    //  config: { 
    //    layout: {
    //      type: UILayoutType.VERTICAL,
    //      margin: { top: 8, bottom: 4 },
    //    },
    //    image: { hidden: { key: "en-blt_hide-spawn" } },
    //  },
    //},
    {
      name: "en-blt_x-slider",  
      template: VEComponents.get("numeric-slider"),
      layout: VELayouts.get("numeric-slider"),
      config: { 
        layout: { 
          type: UILayoutType.VERTICAL,
          margin: { top: 2 },
        },
        label: { 
          text: "X",
          color: VETheme.color.textShadow,
          font: "font_inter_10_bold",
          offset: { y: 14 },
          hidden: { key: "en-blt_hide-spawn" },
        },
        slider: {
          minValue: -1.0 * (SHROOM_SPAWN_AMOUNT / 2.0),
          maxValue: SHROOM_SPAWN_AMOUNT / 2.0,
          snapValue: 1.0 / SHROOM_SPAWN_AMOUNT,
          store: { key: "en-blt_x" },
          hidden: { key: "en-blt_hide-spawn" },
        },
      },
    },
    {
      name: "en-blt_x",
      template: VEComponents.get("numeric-input"),
      layout: VELayouts.get("div"),
      config: { 
        layout: { 
          type: UILayoutType.VERTICAL,
          //margin: { top: 2 },
        },
        label: {
          text: "",
          hidden: { key: "en-blt_hide-spawn" },
        },
        //label: { 
        //  text: "X",
        //  color: VETheme.color.textShadow,
        //  font: "font_inter_10_bold",
        //  hidden: { key: "en-blt_hide-spawn" },
        //},
        field: {
          store: { key: "en-blt_x" },
          hidden: { key: "en-blt_hide-spawn" },
        },
        decrease: {
          store: { key: "en-blt_x" },
          factor: -0.25,
          hidden: { key: "en-blt_hide-spawn" },
        },
        increase: {
          store: { key: "en-blt_x" },
          factor: 0.25,
          hidden: { key: "en-blt_hide-spawn" },
        },
        stick: {
          factor: 0.25,
          step: 10,
          store: { key: "en-blt_x" },
          hidden: { key: "en-blt_hide-spawn" },
        },
        checkbox: { 
          spriteOn: { name: "visu_texture_checkbox_on" },
          spriteOff: { name: "visu_texture_checkbox_off" },
          store: { key: "en-blt_snap-x" },
          hidden: { key: "en-blt_hide-spawn" },
        },
        title: { 
          text: "Snap",
          enable: { key: "en-blt_snap-x" },
          hidden: { key: "en-blt_hide-spawn" },
        },
      },
    },
    {
      name: "en-blt_rng-x",
      template: VEComponents.get("numeric-input"),
      layout: VELayouts.get("div"),
      config: { 
        layout: { 
          type: UILayoutType.VERTICAL,
          //margin: { top: 2, bottom: 4 },
        },
        label: { 
          text: "Random",
          enable: { key: "en-blt_use-rng-x" },
          hidden: { key: "en-blt_hide-spawn" },
        },  
        field: { 
          store: { key: "en-blt_rng-x" },
          enable: { key: "en-blt_use-rng-x" },
          hidden: { key: "en-blt_hide-spawn" },
        },
        decrease: {
          store: { key: "en-blt_rng-x" },
          enable: { key: "en-blt_use-rng-x" },
          factor: -0.25,
          hidden: { key: "en-blt_hide-spawn" },
        },
        increase: {
          store: { key: "en-blt_rng-x" },
          enable: { key: "en-blt_use-rng-x" },
          factor: 0.25,
          hidden: { key: "en-blt_hide-spawn" },
        },
        stick: {
          factor: 0.25,
          step: 10.0,
          store: { key: "en-blt_rng-x" },
          enable: { key: "en-blt_use-rng-x" },
          hidden: { key: "en-blt_hide-spawn" },
        },
        checkbox: { 
          spriteOn: { name: "visu_texture_checkbox_on" },
          spriteOff: { name: "visu_texture_checkbox_off" },
          store: { key: "en-blt_use-rng-x" },
          hidden: { key: "en-blt_hide-spawn" },
        },
        title: { 
          text: "Enable",
          enable: { key: "en-blt_use-rng-x" },
          hidden: { key: "en-blt_hide-spawn" },
        },
      },
    },
    {
      name: "en-blt-rng-x-line-h",
      template: VEComponents.get("line-h"),
      layout: VELayouts.get("line-h"),
      config: { 
        layout: { type: UILayoutType.VERTICAL },
        image: { hidden: { key: "en-blt_hide-spawn" } },
      },
    },
    {
      name: "en-blt_y-slider",  
      template: VEComponents.get("numeric-slider"),
      layout: VELayouts.get("numeric-slider"),
      config: { 
        layout: { 
          type: UILayoutType.VERTICAL,
          //margin: { top: 2 },
        },
        label: { 
          text: "Y",
          color: VETheme.color.textShadow,
          font: "font_inter_10_bold",
          offset: { y: 14 },
          hidden: { key: "en-blt_hide-spawn" },
        },
        slider: {
          minValue: -1.0 * (SHROOM_SPAWN_AMOUNT / 2.0),
          maxValue: SHROOM_SPAWN_AMOUNT / 2.0,
          snapValue: 1.0 / SHROOM_SPAWN_AMOUNT,
          store: { key: "en-blt_y" },
          hidden: { key: "en-blt_hide-spawn" },
        },
      },
    },
    {
      name: "en-blt_y",
      template: VEComponents.get("numeric-input"),
      layout: VELayouts.get("div"),
      config: { 
        layout: { 
          type: UILayoutType.VERTICAL,
          //margin: { top: 2 },
        },
        label: {
          text: "",
          hidden: { key: "en-blt_hide-spawn" }
        },
        //label: { 
        //  text: "Y",
        //  color: VETheme.color.textShadow,
        //  font: "font_inter_10_bold",
        //  hidden: { key: "en-blt_hide-spawn" },
        //},
        field: {
          store: { key: "en-blt_y" },
          hidden: { key: "en-blt_hide-spawn" }
        },
        decrease: {
          store: { key: "en-blt_y" },
          factor: -0.25,
          hidden: { key: "en-blt_hide-spawn" },
        },
        increase: {
          store: { key: "en-blt_y" },
          factor: 0.25,
          hidden: { key: "en-blt_hide-spawn" },
        },
        stick: {
          factor: 0.25,
          step: 10.0,
          store: { key: "en-blt_y" },
          hidden: { key: "en-blt_hide-spawn" },
        },
        checkbox: { 
          spriteOn: { name: "visu_texture_checkbox_on" },
          spriteOff: { name: "visu_texture_checkbox_off" },
          store: { key: "en-blt_snap-y" },
          hidden: { key: "en-blt_hide-spawn" },
        },
        title: { 
          text: "Snap",
          enable: { key: "en-blt_snap-y" },
          hidden: { key: "en-blt_hide-spawn" },
        },
      },
    },
    {
      name: "en-blt_rng-y",
      template: VEComponents.get("numeric-input"),
      layout: VELayouts.get("div"),
      config: { 
        layout: { 
          type: UILayoutType.VERTICAL,
          //margin: { top: 2, bottom: 4 },
        },
        label: { 
          text: "Random",
          enable: { key: "en-blt_use-rng-y" },
          hidden: { key: "en-blt_hide-spawn" },
        },  
        field: { 
          store: { key: "en-blt_rng-y" },
          enable: { key: "en-blt_use-rng-y" },
          hidden: { key: "en-blt_hide-spawn" },
        },
        decrease: {
          store: { key: "en-blt_rng-y" },
          enable: { key: "en-blt_use-rng-y" },
          factor: -0.25,
          hidden: { key: "en-blt_hide-spawn" },
        },
        increase: {
          store: { key: "en-blt_rng-y" },
          enable: { key: "en-blt_use-rng-y" },
          factor: 0.25,
          hidden: { key: "en-blt_hide-spawn" },
        },
        stick: {
          factor: 0.25,
          step: 10.0,
          store: { key: "en-blt_rng-y" },
          enable: { key: "en-blt_use-rng-y" },
          hidden: { key: "en-blt_hide-spawn" },
        },
        checkbox: { 
          spriteOn: { name: "visu_texture_checkbox_on" },
          spriteOff: { name: "visu_texture_checkbox_off" },
          store: { key: "en-blt_use-rng-y" },
          hidden: { key: "en-blt_hide-spawn" },
        },
        title: { 
          text: "Enable",
          enable: { key: "en-blt_use-rng-y" },
          hidden: { key: "en-blt_hide-spawn" },
        },
      },
    },
    {
      name: "en-blt-rng-y-line-h",
      template: VEComponents.get("line-h"),
      layout: VELayouts.get("line-h"),
      config: {
        layout: { type: UILayoutType.VERTICAL },
        image: { hidden: { key: "en-blt_hide-spawn" } },
      },
    },
    {
      name: "en-blt_dir-slider",  
      template: VEComponents.get("numeric-slider"),
      layout: VELayouts.get("numeric-slider"),
      config: { 
        layout: { 
          type: UILayoutType.VERTICAL,
          //margin: { top: 2 },
        },
        label: {
          text: "Angle",
          font: "font_inter_10_bold",
          offset: { y: 14 },
          hidden: { key: "en-blt_hide-spawn" },
        },
        slider: {
          minValue: 0.0,
          maxValue: 360.0,
          snapValue: 1.0 / 360.0,
          store: { key: "en-blt_dir" },
          hidden: { key: "en-blt_hide-spawn" },
        },
      },
    },
    {
      name: "en-blt_dir",
      template: VEComponents.get("numeric-input"),
      layout: VELayouts.get("div"),
      config: { 
        layout: { 
          type: UILayoutType.VERTICAL,
          //margin: { top: 2 },
        },
        label: {
          text: "",
          font: "font_inter_10_bold",
          hidden: { key: "en-blt_hide-spawn" },
        },
        field: {
          store: { key: "en-blt_dir" },
          hidden: { key: "en-blt_hide-spawn" },
        },
        decrease: {
          store: { key: "en-blt_dir" },
          hidden: { key: "en-blt_hide-spawn" },
          factor: -0.1,
        },
        increase: {
          store: { key: "en-blt_dir" },
          hidden: { key: "en-blt_hide-spawn" },
          factor: 0.1,
        },
        stick: {
          factor: 0.1,
          //step: 10.0,
          store: { key: "en-blt_dir" },
          hidden: { key: "en-blt_hide-spawn" },
        },
        checkbox: {
          hidden: { key: "en-blt_hide-spawn" },
          store: { 
            key: "en-blt_dir",
            callback: function(value, data) { 
              var sprite = Struct.get(data, "sprite")
              if (!Core.isType(sprite, Sprite)) {
                sprite = SpriteUtil.parse({ name: "visu_texture_ui_spawn_arrow" })
                Struct.set(data, "sprite", sprite)
              }
              sprite.setAngle(value)
            },
            set: function(value) { return },
          },
          render: function() {
            if (this.backgroundColor != null) {
              var _x = this.context.area.getX() + this.area.getX()
              var _y = this.context.area.getY() + this.area.getY()
              var color = this.backgroundColor
              draw_rectangle_color(
                _x, _y, 
                _x + this.area.getWidth(), _y + this.area.getHeight(),
                color, color, color, color,
                false
              )
            }

            var sprite = Struct.get(this, "sprite")
            if (!Core.isType(sprite, Sprite)) {
              sprite = SpriteUtil.parse({ name: "visu_texture_ui_angle_arrow" })
              Struct.set(this, "sprite", sprite)
            }

            if (!Struct.contains(this, "spawnerAngleTimer")) {
              Struct.set(this, "spawnerAngleTimer", new Timer(pi * 2, { 
                loop: Infinity,
                amount: FRAME_MS * 4,
                shuffle: true
              }))
            }

            var angle = sprite.getAngle()
            if (this.store != null && this.store.getStore() != null && this.store.getStore().getValue("en-blt_use-dir-rng")) {
              sprite.setAngle(angle + sin(this.spawnerAngleTimer.update().time) * (this.store.getStore().getValue("en-blt_dir-rng") / 2.0))
            }
            
            var size = min(this.area.getWidth(), this.area.getHeight()) + 2
            sprite
              .scaleToFit(size, size)              
              .render(
                this.context.area.getX() + this.area.getX() + sprite.texture.offsetX * sprite.getScaleX(),
                this.context.area.getY() + this.area.getY() + sprite.texture.offsetY * sprite.getScaleY()
              )
              .setAngle(angle)
            
            return this
          },
        },
        title: {
          text: "",
          hidden: { key: "en-blt_hide-spawn" },
        },
      },
    },
    {
      name: "en-blt_dir-rng",
      template: VEComponents.get("numeric-input"),
      layout: VELayouts.get("div"),
      config: { 
        layout: { 
          type: UILayoutType.VERTICAL,
          //margin: { top: 2, bottom: 4 },
        },
        label: { 
          text: "Random",
          enable: { key: "en-blt_use-dir-rng" },
          hidden: { key: "en-blt_hide-spawn" },
        },  
        field: { 
          store: { key: "en-blt_dir-rng" },
          enable: { key: "en-blt_use-dir-rng" },
          hidden: { key: "en-blt_hide-spawn" },
        },
        decrease: {
          store: { key: "en-blt_dir-rng" },
          enable: { key: "en-blt_use-dir-rng" },
          hidden: { key: "en-blt_hide-spawn" },
          factor: -0.1,
        },
        increase: {
          store: { key: "en-blt_dir-rng" },
          enable: { key: "en-blt_use-dir-rng" },
          hidden: { key: "en-blt_hide-spawn" },
          factor: 0.1,
        },
        stick: {
          store: { key: "en-blt_dir-rng" },
          enable: { key: "en-blt_use-dir-rng" },
          hidden: { key: "en-blt_hide-spawn" },
          factor: 0.1,
          //step: 10.0,
        },
        checkbox: { 
          spriteOn: { name: "visu_texture_checkbox_on" },
          spriteOff: { name: "visu_texture_checkbox_off" },
          store: { key: "en-blt_use-dir-rng" },
          hidden: { key: "en-blt_hide-spawn" },
        },
        title: { 
          text: "Enable",
          enable: { key: "en-blt_use-dir-rng" },
          hidden: { key: "en-blt_hide-spawn" },
        },
      },
    },
    {
      name: "en-blt_dir-line-h",
      template: VEComponents.get("line-h"),
      layout: VELayouts.get("line-h"),
      config: {
        layout: { type: UILayoutType.VERTICAL },
        image: { hidden: { key: "en-blt_hide-spawn" } },
      },
    },
    {
      name: "en-blt_spd-slider",  
      template: VEComponents.get("numeric-slider"),
      layout: VELayouts.get("numeric-slider"),
      config: { 
        layout: { 
          type: UILayoutType.VERTICAL,
          //margin: { top: 2 },
        },
        label: { 
          text: "Speed",
          font: "font_inter_10_bold",
          offset: { y: 14 },
          hidden: { key: "en-blt_hide-spawn" },
        },
        slider: {
          mminValue: 0.0,
          maxValue: 99.9,
          snapValue: 1.0 / 99.9,
          store: { key: "en-blt_spd" },
          hidden: { key: "en-blt_hide-spawn" },
        },
      },
    },
    {
      name: "en-blt_spd",  
      template: VEComponents.get("numeric-input"),
      layout: VELayouts.get("div"),
      config: { 
        layout: { 
          type: UILayoutType.VERTICAL,
          //margin: { top: 2 },
        },
        label: {
          text: "",
          font: "font_inter_10_bold",
          hidden: { key: "en-blt_hide-spawn" },
        },
        field: {
          store: { key: "en-blt_spd" },
          hidden: { key: "en-blt_hide-spawn" },
        },
        decrease: { 
          store: { key: "en-blt_spd" },
          hidden: { key: "en-blt_hide-spawn" },
          factor: -0.1,
        },
        increase: { 
          store: { key: "en-blt_spd" },
          hidden: { key: "en-blt_hide-spawn" },
          factor: 0.1,
        },
        stick: {
          factor: 0.1,
          //step: 10.0,
          store: { key: "en-blt_spd" },
          hidden: { key: "en-blt_hide-spawn" },
        },
        checkbox: {
          spriteOn: { name: "visu_texture_checkbox_on" },
          spriteOff: { name: "visu_texture_checkbox_off" },
          store: { key: "en-blt_spd-grid" },
          hidden: { key: "en-blt_hide-spawn" },
        },
        title: {
          text: "Add grid speed",
          enable: { key: "en-blt_spd-grid" },
          hidden: { key: "en-blt_hide-spawn" },
        },
      },
    },
    {
      name: "en-blt_spd-rng",
      template: VEComponents.get("numeric-input"),
      layout: VELayouts.get("div"),
      config: { 
        layout: { 
          type: UILayoutType.VERTICAL,
          //margin: { top: 2, bottom: 4 },
        },
        label: { 
          text: "Random",
          enable: { key: "en-blt_use-spd-rng" },
          hidden: { key: "en-blt_hide-spawn" },
        },  
        field: { 
          store: { key: "en-blt_spd-rng" },
          enable: { key: "en-blt_use-spd-rng" },
          hidden: { key: "en-blt_hide-spawn" },
        },
        decrease: {
          store: { key: "en-blt_spd-rng" },
          enable: { key: "en-blt_use-spd-rng" },
          hidden: { key: "en-blt_hide-spawn" },
          factor: -0.1,
        },
        increase: {
          store: { key: "en-blt_spd-rng" },
          enable: { key: "en-blt_use-spd-rng" },
          hidden: { key: "en-blt_hide-spawn" },
          factor: 0.1,
        },
        stick: {
          factor: 0.1,
          //step: 10.0,
          store: { key: "en-blt_spd-rng" },
          enable: { key: "en-blt_use-spd-rng" },
          hidden: { key: "en-blt_hide-spawn" },
        },
        checkbox: { 
          spriteOn: { name: "visu_texture_checkbox_on" },
          spriteOff: { name: "visu_texture_checkbox_off" },
          store: { key: "en-blt_use-spd-rng" },
          hidden: { key: "en-blt_hide-spawn" },
        },
        title: { 
          text: "Enable",
          enable: { key: "en-blt_use-spd-rng" },
          hidden: { key: "en-blt_hide-spawn" },
        },
      },
    },
    {
      name: "en-spd-line-h",
      template: VEComponents.get("line-h"),
      layout: VELayouts.get("line-h"),
      config: {
        layout: { type: UILayoutType.VERTICAL },
        image: { hidden: { key: "en-blt_hide-spawn" } },
      },
    },
    {
      name: "en-blt_em-title",
      template: VEComponents.get("property"),
      layout: VELayouts.get("property"),
      config: { 
        layout: { type: UILayoutType.VERTICAL },
        label: {
          text: "Emitter",
          //backgroundColor: VETheme.color.accentShadow,
          enable: { key: "en-blt_use-em"},
        },
        input: {
          //backgroundColor: VETheme.color.accentShadow,
          spriteOn: { name: "visu_texture_checkbox_switch_on" },
          spriteOff: { name: "visu_texture_checkbox_switch_off" },
          store: { key: "en-blt_use-em" },
        },
        checkbox: {
          //backgroundColor: VETheme.color.accentShadow,
          store: { key: "en-blt_hide-em" },
          spriteOn: { name: "visu_texture_checkbox_show" },
          spriteOff: { name: "visu_texture_checkbox_hide" },
        },
      },
    },
    {
      name: "en-blt_em-cfg",
      template: VEComponents.get("text-area"),
      layout: VELayouts.get("text-area"),
      config: { 
        layout: { type: UILayoutType.VERTICAL },
        field: { 
          v_grow: true,
          w_min: 570,
          store: { key: "en-blt_em-cfg" },
          enable: { key: "en-blt_use-em"},
          updateCustom: UIItemUtils.textField.getUpdateJSONTextArea(),
          hidden: { key: "en-blt_hide-em" },
        },
      },
    },
    {
      name: "en-blt_em-cfg-line-h",
      template: VEComponents.get("line-h"),
      layout: VELayouts.get("line-h"),
      config: {
        layout: {
          type: UILayoutType.VERTICAL,
          margin: { top: 0, bottom: 0 },
          height: function() { return 0 },
        },
        image: { 
          hidden: { key: "en-blt_hide-em" },
          backgroundAlpha: 0.0,
        },
      },
    }
  ])

  return {
    name: "brush_entity_bullet",
    store: new Map(String, Struct, store),
    components: components,
  }
}