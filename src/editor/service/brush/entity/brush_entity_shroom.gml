///@package io.alkapivo.visu.editor.service.brush.entity

///@param {Struct} json
///@return {Struct}
function brush_entity_shroom(json) {
  static sortEmitter =  function(key, index, emitter) {
    var value = Struct.get(emitter.json, key)
    var json = Struct.set({}, key, value)
    var array = String.split(JSON.stringify(json, true), "\n")
    emitter.array.add(array.remove(0).remove(array.size() - 1).join("\n"))
  }

  var emitterConfig = Struct.getIfType(json, "en-shr_em-cfg", Struct)
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
    "en-shr_preview": {
      type: Boolean,
      value: Struct.get(json, "en-shr_preview"),
    },
    "en-shr_template": {
      type: String,
      value: Struct.get(json, "en-shr_template"),
      passthrough: UIUtil.passthrough.getCallbackValue(),
      data: {
        callback: Beans.get(BeanVisuController).shroomTemplateExists,
        defaultValue: "shroom-default",
      },
    },
    "en-shr_use-lifespan": {
      type: Boolean,
      value: Struct.get(json, "en-shr_use-lifespan")
    },
    "en-shr_lifespan": {
      type: Number,
      value: Struct.get(json, "en-shr_lifespan"),
      passthrough: UIUtil.passthrough.getClampedStringNumber(),
      data: new Vector2(0.0, 999.9),
    },
    "en-shr_use-hp": {
      type: Boolean,
      value: Struct.get(json, "en-shr_use-hp"),
    },
    "en-shr_hp": {
      type: Number,
      value: Struct.get(json, "en-shr_hp"),
      passthrough: UIUtil.passthrough.getClampedStringNumber(),
      data: new Vector2(0.0, 9999999.9),
    },
    "en-shr_spd": {
      type: Number,
      value: Struct.get(json, "en-shr_spd"),
      passthrough: UIUtil.passthrough.getClampedStringNumber(),
      data: new Vector2(0.0, 99.9),
    },
    "en-shr_spd-grid": {
      type: Boolean,
      value: Struct.get(json, "en-shr_spd-grid"),
    },
    "en-shr_use-spd-rng": {
      type: Boolean,
      value: Struct.get(json, "en-shr_use-spd-rng"),
    },
    "en-shr_spd-rng": {
      type: Number,
      value: Struct.get(json, "en-shr_spd-rng"),
      passthrough: UIUtil.passthrough.getClampedStringNumber(),
      data: new Vector2(0.0, 99.9),
    },
    "en-shr_dir": {
      type: Number,
      value: Struct.get(json, "en-shr_dir"),
      passthrough: UIUtil.passthrough.getClampedStringNumber(),
      data: new Vector2(0.0, 360.0),
    },
    "en-shr_use-dir-rng": {
      type: Boolean,
      value: Struct.get(json, "en-shr_use-dir-rng"),
    },
    "en-shr_dir-rng": {
      type: Number,
      value: Struct.get(json, "en-shr_dir-rng"),
      passthrough: UIUtil.passthrough.getClampedStringNumber(),
      data: new Vector2(0.0, 360.0),
    },
    "en-shr_x": {
      type: Number,
      value: Struct.get(json, "en-shr_x", Number, 0),
      passthrough: UIUtil.passthrough.getClampedStringNumber(),
      data: new Vector2(
        -1.0 * (SHROOM_SPAWN_AMOUNT / 2.0), 
        SHROOM_SPAWN_AMOUNT / 2.0
      ),
    },
    "en-shr_snap-x": {
      type: Boolean,
      value: Struct.get(json, "en-shr_snap-x"),
    },
    "en-shr_use-rng-x": {
      type: Boolean,
      value: Struct.get(json, "en-shr_use-rng-x"),
    },
    "en-shr_rng-x": {
      type: Number,
      value: Struct.get(json, "en-shr_rng-x", Number, 0),
      passthrough: UIUtil.passthrough.getClampedStringNumber(),
      data: new Vector2(
        0.0, 
        SHROOM_SPAWN_AMOUNT / 2.0
      ),
    },
    "en-shr_y": {
      type: Number,
      value: Struct.get(json, "en-shr_y", Number, 0),
      passthrough: UIUtil.passthrough.getClampedStringNumber(),
      data: new Vector2(
        -1.0 * (SHROOM_SPAWN_AMOUNT / 2.0), 
        SHROOM_SPAWN_AMOUNT / 2.0
      ),
    },
    "en-shr_snap-y": {
      type: Boolean,
      value: Struct.get(json, "en-shr_snap-y"),
    },
    "en-shr_use-rng-y": {
      type: Boolean,
      value: Struct.get(json, "en-shr_use-rng-y"),
    },
    "en-shr_rng-y": {
      type: Number,
      value: Struct.get(json, "en-shr_rng-y", Number, 0),
      passthrough: UIUtil.passthrough.getClampedStringNumber(),
      data: new Vector2(
        0.0, 
        SHROOM_SPAWN_AMOUNT / 2.0
      ),
    },
    "en-shr_use-inherit": {
      type: Boolean,
      value: Struct.get(json, "en-shr_use-inherit"),
    },
    "en-shr_inherit": {
      type: String,
      value: JSON.stringify(Struct.getIfType(json, "en-shr_inherit", GMArray, []), true),
      serialize: UIUtil.serialize.getStringGMArray(),
      passthrough: UIUtil.passthrough.getStringGMArray(),
    },
    "en-shr_use-texture": {
      type: Boolean,
      value: Struct.get(json, "en-shr_use-texture"),
    },
    "en-shr_texture": {
      type: Sprite,
      value: Struct.get(json, "en-shr_texture"),
    },
    "en-shr_use-mask": {
      type: Boolean,
      value: Struct.get(json, "en-shr_use-mask"),
    },
    "en-shr_mask": {
      type: Rectangle,
      value: Struct.get(json, "en-shr_mask"),
    },
    "en-shr_spawn-map": {
      type: TextureTemplate,
      value: new TextureTemplate("texture_shroom_spawn_map", { asset: texture_shroom_spawn_map, file: "" }),
    },
    "en-shr_hide": {
      type: Boolean,
      value: Struct.get(json, "en-shr_hide"),
    },
    "en-shr_hide-spawn": {
      type: Boolean,
      value: Struct.get(json, "en-shr_hide-spawn"),
    },
    "en-shr_hide-inherit": {
      type: Boolean,
      value: Struct.get(json, "en-shr_hide-inherit"),
    },
    "en-shr_hide-em": {
      type: Boolean,
      value: Struct.get(json, "en-shr_hide-em"),
    },
    "en-shr_hide-em-cfg": {
      type: Boolean,
      value: Struct.get(json, "en-shr_hide-em-cfg"),
    },
    "en-shr_hide-em-angle": {
      type: Boolean,
      value: Struct.get(json, "en-shr_hide-em-angle"),
    },
    "en-shr_hide-em-per-array": {
      type: Boolean,
      value: Struct.get(json, "en-shr_hide-em-per-array"),
    },
    "en-shr_hide-em-spd": {
      type: Boolean,
      value: Struct.get(json, "en-shr_hide-em-spd"),
    },
    "en-shr_hide-em-offset-x": {
      type: Boolean,
      value: Struct.get(json, "en-shr_hide-em-offset-x"),
    },
    "en-shr_hide-em-offset-y": {
      type: Boolean,
      value: Struct.get(json, "en-shr_hide-em-offset-y"),
    },
    "en-shr_hide-em-wiggle-freq": {
      type: Boolean,
      value: Struct.get(json, "en-shr_hide-em-wiggle-freq"),
    },
    "en-shr_hide-em-wiggle-amp": {
      type: Boolean,
      value: Struct.get(json, "en-shr_hide-em-wiggle-amp"),
    },
    "en-shr_use-em": {
      type: Boolean,
      value: Struct.get(json, "en-shr_use-em"),
    },
    "en-shr_em-cfg": {
      type: String,
      value: emitterJSON,
      serialize: UIUtil.serialize.getStringStruct(),
      passthrough: UIUtil.passthrough.getStringStruct(),
    },
  }

  var components = new Array(Struct, [
    VETitleComponent("en-shr_hide", {
      "label":{
        "text":"Properties"
      },
      "input":{
      },
      "checkbox":{
        "spriteOff":{
          "name":"visu_texture_checkbox_hide"
        },
        "store":{
          "key":"en-shr_hide"
        },
        "spriteOn":{
          "name":"visu_texture_checkbox_show"
        }
      }
    }),
    {
      name: "en-shr_template",  
      template: VEComponents.get("text-field"),
      layout: VELayouts.get("text-field"),
      config: { 
        layout: { 
          type: UILayoutType.VERTICAL,
          //margin: { top: 2, bottom: 2 },
        },
        label: {
          text: "Template",
          hidden: { key: "en-shr_hide" },
        },
        field: {
          store: { key: "en-shr_template" },
          hidden: { key: "en-shr_hide" },
        },
      },
    },
    {
      name: "en-shr_lifespan",
      template: VEComponents.get("numeric-input"),
      layout: VELayouts.get("div"),
      config: { 
        layout: { type: UILayoutType.VERTICAL },
        label: { 
          text: "Lifespan",
          enable: { key: "en-shr_use-lifespan" },
          hidden: { key: "en-shr_hide" },
        },  
        field: { 
          store: { key: "en-shr_lifespan" },
          enable: { key: "en-shr_use-lifespan" },
          hidden: { key: "en-shr_hide" },
        },
        decrease: {
          store: { key: "en-shr_lifespan" },
          enable: { key: "en-shr_use-lifespan" },
          factor: -0.1,
          hidden: { key: "en-shr_hide" },
        },
        increase: {
          store: { key: "en-shr_lifespan" },
          enable: { key: "en-shr_use-lifespan" },
          factor: 0.1,
          hidden: { key: "en-shr_hide" },
        },
        stick: {
          store: { key: "en-shr_lifespan" },
          enable: { key: "en-shr_use-lifespan" },
          factor: 0.1,
          step: 10.0,
          hidden: { key: "en-shr_hide" },
        },
        checkbox: {
          store: { key: "en-shr_use-lifespan" },
          spriteOn: { name: "visu_texture_checkbox_on" },
          spriteOff: { name: "visu_texture_checkbox_off" },
          hidden: { key: "en-shr_hide" },
        },
        title: {
          text: "Override",
          enable: { key: "en-shr_use-lifespan" },
          hidden: { key: "en-shr_hide" },
        }
      },
    },
    {
      name: "en-shr_hp",
      template: VEComponents.get("numeric-input"),
      layout: VELayouts.get("div"),
      config: { 
        layout: { type: UILayoutType.VERTICAL },
        label: { 
          text: "Health",
          enable: { key: "en-shr_use-hp" },
          hidden: { key: "en-shr_hide" },
        },  
        field: { 
          store: { key: "en-shr_hp" },
          enable: { key: "en-shr_use-hp" },
          hidden: { key: "en-shr_hide" },
        },
        decrease: {
          store: { key: "en-shr_hp" },
          enable: { key: "en-shr_use-hp" },
          factor: -0.1,
          hidden: { key: "en-shr_hide" },
        },
        increase: {
          store: { key: "en-shr_hp" },
          enable: { key: "en-shr_use-hp" },
          factor: 0.1,
          hidden: { key: "en-shr_hide" },
        },
        stick: {
          store: { key: "en-shr_hp" },
          enable: { key: "en-shr_use-hp" },
          factor: 0.1,
          step: 10.0,
          hidden: { key: "en-shr_hide" },
        },
        checkbox: {
          store: { key: "en-shr_use-hp" },
          spriteOn: { name: "visu_texture_checkbox_on" },
          spriteOff: { name: "visu_texture_checkbox_off" },
          hidden: { key: "en-shr_hide" },
        },
        title: {
          text: "Override",
          enable: { key: "en-shr_use-hp" },
          hidden: { key: "en-shr_hide" },
        }
      },
    },
    {
      name: "en-shr-template-line-h",
      template: VEComponents.get("line-h"),
      layout: VELayouts.get("line-h"),
      config: {
        layout: { type: UILayoutType.VERTICAL },
        image: { hidden: { key: "en-shr_hide" } },
      },
    },
    VETitleComponent("en-shr_hide-spawn", {
      "label":{
        "text":"Spawner"
      },
      "input":{
      },
      "checkbox":{
        "spriteOff":{
          "name":"visu_texture_checkbox_hide"
        },
        "store":{
          "key":"en-shr_hide-spawn"
        },
        "spriteOn":{
          "name":"visu_texture_checkbox_show"
        }
      }
    }),
    VETitleComponent("en-shr_preview", {
      "enable":{
        "key":"en-shr_preview"
      },
      "label":{
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
            if (store == null || !store.getValue("en-shr_preview")) {
              Beans.get(BeanVisuController).shroomService.spawner = null
            }
          }
          
          if (Core.isType(this.context.state.get("event"), VEEvent)) {
            store = this.context.state.get("event").store
            if (store == null || !store.getValue("en-shr_preview")) {
              Beans.get(BeanVisuController).shroomService.spawnerEvent = null
            }
          }

          if (!Optional.is(store) || !store.getValue("en-shr_preview")) {
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

          var _x = store.getValue("en-shr_x") * (SHROOM_SPAWN_SIZE / SHROOM_SPAWN_AMOUNT) + 0.5
          if (store.getValue("en-shr_use-rng-x")) {
            _x += sin(this.spawnerXTimer.update().time) * (store.getValue("en-shr_rng-x") * (SHROOM_SPAWN_SIZE / SHROOM_SPAWN_AMOUNT) / 2.0)
          }

          if (store.getValue("en-shr_snap-x")) {
            _x = _x - (view.x - locked.snapH)
          }

          if (!Struct.contains(this, "spawnerYTimer")) {
            Struct.set(this, "spawnerYTimer", new Timer(pi * 2, { 
              loop: Infinity,
              amount: FRAME_MS * 4,
              shuffle: true
            }))
          }

          var _y = store.getValue("en-shr_y") * (SHROOM_SPAWN_SIZE / SHROOM_SPAWN_AMOUNT) - 0.5
          if (store.getValue("en-shr_use-rng-y")) {
            _y += sin(this.spawnerYTimer.update().time) * (store.getValue("en-shr_rng-y") * (SHROOM_SPAWN_SIZE / SHROOM_SPAWN_AMOUNT) / 2.0)
          }

          if (store.getValue("en-shr_snap-y")) {
            _y = _y - (view.y - locked.snapV)
          }

          if (!Struct.contains(this, "spawnerAngleTimer")) {
            Struct.set(this, "spawnerAngleTimer", new Timer(pi * 2, { 
              loop: Infinity,
              amount: FRAME_MS * 4,
              shuffle: true
            }))
          }

          var angle = store.getValue("en-shr_dir")
          if (store.getValue("en-shr_use-dir-rng")) {
            angle += sin(this.spawnerAngleTimer.update().time) * (store.getValue("en-shr_dir-rng") / 2.0)
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
        "text":"Show spawner"
      },
      "input":{
      },
      "background":"#1B1B20",
      "checkbox":{
        "spriteOff":{
          "name":"visu_texture_checkbox_off"
        },
        "store":{
          "key":"en-shr_preview"
        },
        "spriteOn":{
          "name":"visu_texture_checkbox_on"
        }
      },
      "hidden":{
        "key":"en-shr_hide-spawn"
      }
    }),
    {
      name: "en-shr_spawn-map",
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
          store: { key: "en-shr_spawn-map" },
          hidden: { key: "en-shr_hide-spawn" },
          origin: "en-shr_spawn-map",
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
                store.get("en-shr_x").set(horizontal)
                store.get("en-shr_y").set(vertical)
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

            var horizontal = (store.getValue("en-shr_x") + (SHROOM_SPAWN_AMOUNT / 2.0)) / SHROOM_SPAWN_AMOUNT
            var vertical = (store.getValue("en-shr_y") + (SHROOM_SPAWN_AMOUNT / 2.0)) / SHROOM_SPAWN_AMOUNT
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

            var angle = store.getValue("en-shr_dir")
            if (store.getValue("en-shr_use-dir-rng")) {
              angle += sin(this.spawnerAngleTimer.update().time) * (store.getValue("en-shr_dir-rng") / 2.0)
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
            key: "en-shr_spawn-map",
            callback: function(value, data) { 
              if (!Core.isType(value, TextureTemplate)) {
                return
              }
              
              data.label.text = ""//$"width: {sprite_get_width(value.asset)} height: {sprite_get_height(value.asset)}"
            },
          },
          hidden: { key: "en-shr_hide-spawn" },
        },
      },
    },
    //{
    //  name: "en-shr-spawn-map-line-h",
    //  template: VEComponents.get("line-h"),
    //  layout: VELayouts.get("line-h"),
    //  config: { 
    //    layout: {
    //      type: UILayoutType.VERTICAL,
    //      margin: { top: 8, bottom: 4 },
    //    },
    //    image: { hidden: { key: "en-shr_hide-spawn" } },
    //  },
    //},
    {
      name: "en-shr_x-slider",  
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
          hidden: { key: "en-shr_hide-spawn" },
        },
        slider: {
          minValue: -1.0 * (SHROOM_SPAWN_AMOUNT / 2.0),
          maxValue: SHROOM_SPAWN_AMOUNT / 2.0,
          snapValue: 1.0 / SHROOM_SPAWN_AMOUNT,
          store: { key: "en-shr_x" },
          hidden: { key: "en-shr_hide-spawn" },
        },
      },
    },
    {
      name: "en-shr_x",
      template: VEComponents.get("numeric-input"),
      layout: VELayouts.get("div"),
      config: { 
        layout: { 
          type: UILayoutType.VERTICAL,
          //margin: { top: 2 },
        },
        label: {
          text: "",
          hidden: { key: "en-shr_hide-spawn" },
        },
        //label: { 
        //  text: "X",
        //  color: VETheme.color.textShadow,
        //  font: "font_inter_10_bold",
        //  hidden: { key: "en-shr_hide-spawn" },
        //},
        field: {
          store: { key: "en-shr_x" },
          hidden: { key: "en-shr_hide-spawn" },
        },
        decrease: {
          store: { key: "en-shr_x" },
          factor: -0.25,
          hidden: { key: "en-shr_hide-spawn" },
        },
        increase: {
          store: { key: "en-shr_x" },
          factor: 0.25,
          hidden: { key: "en-shr_hide-spawn" },
        },
        stick: {
          factor: 0.25,
          step: 10,
          store: { key: "en-shr_x" },
          hidden: { key: "en-shr_hide-spawn" },
        },
        checkbox: { 
          spriteOn: { name: "visu_texture_checkbox_on" },
          spriteOff: { name: "visu_texture_checkbox_off" },
          store: { key: "en-shr_snap-x" },
          hidden: { key: "en-shr_hide-spawn" },
        },
        title: { 
          text: "Snap",
          enable: { key: "en-shr_snap-x" },
          hidden: { key: "en-shr_hide-spawn" },
        },
      },
    },
    {
      name: "en-shr_rng-x",
      template: VEComponents.get("numeric-input"),
      layout: VELayouts.get("div"),
      config: { 
        layout: { 
          type: UILayoutType.VERTICAL,
          //margin: { top: 2, bottom: 4 },
        },
        label: { 
          text: "Random",
          enable: { key: "en-shr_use-rng-x" },
          hidden: { key: "en-shr_hide-spawn" },
        },  
        field: { 
          store: { key: "en-shr_rng-x" },
          enable: { key: "en-shr_use-rng-x" },
          hidden: { key: "en-shr_hide-spawn" },
        },
        decrease: {
          store: { key: "en-shr_rng-x" },
          enable: { key: "en-shr_use-rng-x" },
          factor: -0.25,
          hidden: { key: "en-shr_hide-spawn" },
        },
        increase: {
          store: { key: "en-shr_rng-x" },
          enable: { key: "en-shr_use-rng-x" },
          factor: 0.25,
          hidden: { key: "en-shr_hide-spawn" },
        },
        stick: {
          factor: 0.25,
          step: 10.0,
          store: { key: "en-shr_rng-x" },
          enable: { key: "en-shr_use-rng-x" },
          hidden: { key: "en-shr_hide-spawn" },
        },
        checkbox: { 
          spriteOn: { name: "visu_texture_checkbox_on" },
          spriteOff: { name: "visu_texture_checkbox_off" },
          store: { key: "en-shr_use-rng-x" },
          hidden: { key: "en-shr_hide-spawn" },
        },
        title: { 
          text: "Enable",
          enable: { key: "en-shr_use-rng-x" },
          hidden: { key: "en-shr_hide-spawn" },
        },
      },
    },
    {
      name: "en-shr-rng-x-line-h",
      template: VEComponents.get("line-h"),
      layout: VELayouts.get("line-h"),
      config: { 
        layout: { type: UILayoutType.VERTICAL },
        image: { hidden: { key: "en-shr_hide-spawn" } },
      },
    },
    {
      name: "en-shr_y-slider",  
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
          hidden: { key: "en-shr_hide-spawn" },
        },
        slider: {
          minValue: -1.0 * (SHROOM_SPAWN_AMOUNT / 2.0),
          maxValue: SHROOM_SPAWN_AMOUNT / 2.0,
          snapValue: 1.0 / SHROOM_SPAWN_AMOUNT,
          store: { key: "en-shr_y" },
          hidden: { key: "en-shr_hide-spawn" },
        },
      },
    },
    {
      name: "en-shr_y",
      template: VEComponents.get("numeric-input"),
      layout: VELayouts.get("div"),
      config: { 
        layout: { 
          type: UILayoutType.VERTICAL,
          //margin: { top: 2 },
        },
        label: {
          text: "",
          hidden: { key: "en-shr_hide-spawn" }
        },
        //label: { 
        //  text: "Y",
        //  color: VETheme.color.textShadow,
        //  font: "font_inter_10_bold",
        //  hidden: { key: "en-shr_hide-spawn" },
        //},
        field: {
          store: { key: "en-shr_y" },
          hidden: { key: "en-shr_hide-spawn" }
        },
        decrease: {
          store: { key: "en-shr_y" },
          factor: -0.25,
          hidden: { key: "en-shr_hide-spawn" },
        },
        increase: {
          store: { key: "en-shr_y" },
          factor: 0.25,
          hidden: { key: "en-shr_hide-spawn" },
        },
        stick: {
          factor: 0.25,
          step: 10.0,
          store: { key: "en-shr_y" },
          hidden: { key: "en-shr_hide-spawn" },
        },
        checkbox: { 
          spriteOn: { name: "visu_texture_checkbox_on" },
          spriteOff: { name: "visu_texture_checkbox_off" },
          store: { key: "en-shr_snap-y" },
          hidden: { key: "en-shr_hide-spawn" },
        },
        title: { 
          text: "Snap",
          enable: { key: "en-shr_snap-y" },
          hidden: { key: "en-shr_hide-spawn" },
        },
      },
    },
    {
      name: "en-shr_rng-y",
      template: VEComponents.get("numeric-input"),
      layout: VELayouts.get("div"),
      config: { 
        layout: { 
          type: UILayoutType.VERTICAL,
          //margin: { top: 2, bottom: 4 },
        },
        label: { 
          text: "Random",
          enable: { key: "en-shr_use-rng-y" },
          hidden: { key: "en-shr_hide-spawn" },
        },  
        field: { 
          store: { key: "en-shr_rng-y" },
          enable: { key: "en-shr_use-rng-y" },
          hidden: { key: "en-shr_hide-spawn" },
        },
        decrease: {
          store: { key: "en-shr_rng-y" },
          enable: { key: "en-shr_use-rng-y" },
          factor: -0.25,
          hidden: { key: "en-shr_hide-spawn" },
        },
        increase: {
          store: { key: "en-shr_rng-y" },
          enable: { key: "en-shr_use-rng-y" },
          factor: 0.25,
          hidden: { key: "en-shr_hide-spawn" },
        },
        stick: {
          factor: 0.25,
          step: 10.0,
          store: { key: "en-shr_rng-y" },
          enable: { key: "en-shr_use-rng-y" },
          hidden: { key: "en-shr_hide-spawn" },
        },
        checkbox: { 
          spriteOn: { name: "visu_texture_checkbox_on" },
          spriteOff: { name: "visu_texture_checkbox_off" },
          store: { key: "en-shr_use-rng-y" },
          hidden: { key: "en-shr_hide-spawn" },
        },
        title: { 
          text: "Enable",
          enable: { key: "en-shr_use-rng-y" },
          hidden: { key: "en-shr_hide-spawn" },
        },
      },
    },
    {
      name: "en-shr-rng-y-line-h",
      template: VEComponents.get("line-h"),
      layout: VELayouts.get("line-h"),
      config: {
        layout: { type: UILayoutType.VERTICAL },
        image: { hidden: { key: "en-shr_hide-spawn" } },
      },
    },
    {
      name: "en-shr_dir-slider",  
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
          hidden: { key: "en-shr_hide-spawn" },
        },
        slider: {
          minValue: 0.0,
          maxValue: 360.0,
          snapValue: 1.0 / 360.0,
          store: { key: "en-shr_dir" },
          hidden: { key: "en-shr_hide-spawn" },
        },
      },
    },
    {
      name: "en-shr_dir",
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
          hidden: { key: "en-shr_hide-spawn" },
        },
        field: {
          store: { key: "en-shr_dir" },
          hidden: { key: "en-shr_hide-spawn" },
        },
        decrease: {
          store: { key: "en-shr_dir" },
          hidden: { key: "en-shr_hide-spawn" },
          factor: -0.1,
        },
        increase: {
          store: { key: "en-shr_dir" },
          hidden: { key: "en-shr_hide-spawn" },
          factor: 0.1,
        },
        stick: {
          factor: 0.1,
          //step: 10.0,
          store: { key: "en-shr_dir" },
          hidden: { key: "en-shr_hide-spawn" },
        },
        checkbox: {
          hidden: { key: "en-shr_hide-spawn" },
          store: { 
            key: "en-shr_dir",
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
            if (this.store != null && this.store.getStore() != null && this.store.getStore().getValue("en-shr_use-dir-rng")) {
              sprite.setAngle(angle + sin(this.spawnerAngleTimer.update().time) * (this.store.getStore().getValue("en-shr_dir-rng") / 2.0))
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
          hidden: { key: "en-shr_hide-spawn" },
        },
      },
    },
    {
      name: "en-shr_dir-rng",
      template: VEComponents.get("numeric-input"),
      layout: VELayouts.get("div"),
      config: { 
        layout: { 
          type: UILayoutType.VERTICAL,
          //margin: { top: 2, bottom: 4 },
        },
        label: { 
          text: "Random",
          enable: { key: "en-shr_use-dir-rng" },
          hidden: { key: "en-shr_hide-spawn" },
        },  
        field: { 
          store: { key: "en-shr_dir-rng" },
          enable: { key: "en-shr_use-dir-rng" },
          hidden: { key: "en-shr_hide-spawn" },
        },
        decrease: {
          store: { key: "en-shr_dir-rng" },
          enable: { key: "en-shr_use-dir-rng" },
          hidden: { key: "en-shr_hide-spawn" },
          factor: -0.1,
        },
        increase: {
          store: { key: "en-shr_dir-rng" },
          enable: { key: "en-shr_use-dir-rng" },
          hidden: { key: "en-shr_hide-spawn" },
          factor: 0.1,
        },
        stick: {
          store: { key: "en-shr_dir-rng" },
          enable: { key: "en-shr_use-dir-rng" },
          hidden: { key: "en-shr_hide-spawn" },
          factor: 0.1,
          //step: 10.0,
        },
        checkbox: { 
          spriteOn: { name: "visu_texture_checkbox_on" },
          spriteOff: { name: "visu_texture_checkbox_off" },
          store: { key: "en-shr_use-dir-rng" },
          hidden: { key: "en-shr_hide-spawn" },
        },
        title: { 
          text: "Enable",
          enable: { key: "en-shr_use-dir-rng" },
          hidden: { key: "en-shr_hide-spawn" },
        },
      },
    },
    {
      name: "en-shr_dir-line-h",
      template: VEComponents.get("line-h"),
      layout: VELayouts.get("line-h"),
      config: {
        layout: { type: UILayoutType.VERTICAL },
        image: { hidden: { key: "en-shr_hide-spawn" } },
      },
    },
    {
      name: "en-shr_spd-slider",  
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
          hidden: { key: "en-shr_hide-spawn" },
        },
        slider: {
          mminValue: 0.0,
          maxValue: 99.9,
          snapValue: 1.0 / 99.9,
          store: { key: "en-shr_spd" },
          hidden: { key: "en-shr_hide-spawn" },
        },
      },
    },
    {
      name: "en-shr_spd",  
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
          hidden: { key: "en-shr_hide-spawn" },
        },
        field: {
          store: { key: "en-shr_spd" },
          hidden: { key: "en-shr_hide-spawn" },
        },
        decrease: { 
          store: { key: "en-shr_spd" },
          hidden: { key: "en-shr_hide-spawn" },
          factor: -0.1,
        },
        increase: { 
          store: { key: "en-shr_spd" },
          hidden: { key: "en-shr_hide-spawn" },
          factor: 0.1,
        },
        stick: {
          factor: 0.1,
          //step: 10.0,
          store: { key: "en-shr_spd" },
          hidden: { key: "en-shr_hide-spawn" },
        },
        checkbox: {
          spriteOn: { name: "visu_texture_checkbox_on" },
          spriteOff: { name: "visu_texture_checkbox_off" },
          store: { key: "en-shr_spd-grid" },
          hidden: { key: "en-shr_hide-spawn" },
        },
        title: {
          text: "Add grid speed",
          enable: { key: "en-shr_spd-grid" },
          hidden: { key: "en-shr_hide-spawn" },
        },
      },
    },
    {
      name: "en-shr_spd-rng",
      template: VEComponents.get("numeric-input"),
      layout: VELayouts.get("div"),
      config: { 
        layout: { 
          type: UILayoutType.VERTICAL,
          //margin: { top: 2, bottom: 4 },
        },
        label: { 
          text: "Random",
          enable: { key: "en-shr_use-spd-rng" },
          hidden: { key: "en-shr_hide-spawn" },
        },  
        field: { 
          store: { key: "en-shr_spd-rng" },
          enable: { key: "en-shr_use-spd-rng" },
          hidden: { key: "en-shr_hide-spawn" },
        },
        decrease: {
          store: { key: "en-shr_spd-rng" },
          enable: { key: "en-shr_use-spd-rng" },
          hidden: { key: "en-shr_hide-spawn" },
          factor: -0.1,
        },
        increase: {
          store: { key: "en-shr_spd-rng" },
          enable: { key: "en-shr_use-spd-rng" },
          hidden: { key: "en-shr_hide-spawn" },
          factor: 0.1,
        },
        stick: {
          factor: 0.1,
          //step: 10.0,
          store: { key: "en-shr_spd-rng" },
          enable: { key: "en-shr_use-spd-rng" },
          hidden: { key: "en-shr_hide-spawn" },
        },
        checkbox: { 
          spriteOn: { name: "visu_texture_checkbox_on" },
          spriteOff: { name: "visu_texture_checkbox_off" },
          store: { key: "en-shr_use-spd-rng" },
          hidden: { key: "en-shr_hide-spawn" },
        },
        title: { 
          text: "Enable",
          enable: { key: "en-shr_use-spd-rng" },
          hidden: { key: "en-shr_hide-spawn" },
        },
      },
    },
    {
      name: "en-spd-line-h",
      template: VEComponents.get("line-h"),
      layout: VELayouts.get("line-h"),
      config: {
        layout: { type: UILayoutType.VERTICAL },
        image: { hidden: { key: "en-shr_hide-spawn" } },
      },
    },
    VETitleComponent("en-shr_inherit-title", {
      "enable":{
        "key":"en-shr_use-inherit"
      },
      "label":{
        "text":"Inherit"
      },
      "input":{
        "spriteOff":{
          "name":"visu_texture_checkbox_switch_off"
        },
        "store":{
          "key":"en-shr_use-inherit"
        },
        "spriteOn":{
          "name":"visu_texture_checkbox_switch_on"
        }
      },
      "checkbox":{
        "spriteOff":{
          "name":"visu_texture_checkbox_hide"
        },
        "store":{
          "key":"en-shr_hide-inherit"
        },
        "spriteOn":{
          "name":"visu_texture_checkbox_show"
        }
      }
    }),
    {
      name: "en-shr_inherit",
      template: VEComponents.get("text-area"),
      layout: VELayouts.get("text-area"),
      config: { 
        layout: { type: UILayoutType.VERTICAL },
        field: { 
          v_grow: true,
          w_min: 570,
          store: { key: "en-shr_inherit" },
          enable: { key: "en-shr_use-inherit"},
          updateCustom: UIItemUtils.textField.getUpdateJSONTextArea(),
          hidden: { key: "en-shr_hide-inherit" },
        },
      },
    },
    {
      name: "en-shr_inherit-line-h",
      template: VEComponents.get("line-h"),
      layout: VELayouts.get("line-h"),
      config: {
        layout: {
          type: UILayoutType.VERTICAL,
          margin: { top: 0, bottom: 0 },
          height: function() { return 0 },
        },
        image: { 
          hidden: { key: "en-shr_hide-inherit" },
          backgroundAlpha: 0.0,
        },
      },
    },
    VETitleComponent("en-shr_em-title", {
      "enable":{
        "key":"en-shr_use-em"
      },
      "label":{
        "text":"Emitter"
      },
      "input":{
        "spriteOff":{
          "name":"visu_texture_checkbox_switch_off"
        },
        "store":{
          "key":"en-shr_use-em"
        },
        "spriteOn":{
          "name":"visu_texture_checkbox_switch_on"
        }
      },
      "checkbox":{
        "spriteOff":{
          "name":"visu_texture_checkbox_hide"
        },
        "store":{
          "key":"en-shr_hide-em"
        },
        "spriteOn":{
          "name":"visu_texture_checkbox_show"
        }
      }
    }),

    {
      name: "en-shr_em-cfg",
      template: VEComponents.get("text-area"),
      layout: VELayouts.get("text-area"),
      config: { 
        layout: { type: UILayoutType.VERTICAL },
        field: { 
          v_grow: true,
          w_min: 570,
          store: { key: "en-shr_em-cfg" },
          enable: { key: "en-shr_use-em"},
          updateCustom: UIItemUtils.textField.getUpdateJSONTextArea(),
          hidden: { key: "en-shr_hide-em" },
        },
      },
    },
    {
      name: "en-shr_em-cfg-line-h",
      template: VEComponents.get("line-h"),
      layout: VELayouts.get("line-h"),
      config: {
        layout: {
          type: UILayoutType.VERTICAL,
          margin: { top: 0, bottom: 0 },
          height: function() { return 0 },
        },
        image: { 
          hidden: { key: "en-shr_hide-em" },
          backgroundAlpha: 0.0,
        },
      },
    }
  ])

  return {
    name: "brush_entity_shroom",
    store: new Map(String, Struct, store),
    components: components,
  }
}