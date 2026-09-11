show_debug_message("init entity_track_event.gml")


///@type {Number}
#macro SHROOM_SPAWN_AMOUNT 60

///@type {Number}
#macro SHROOM_SPAWN_SIZE 10

///@type {Struct}
global.__entity_track_event = {
  "brush_entity_shroom": {
    defaultValues: function() {
      var __defaultValues = Struct.get("__defaultValues")
      if (__defaultValues == null) {
        __defaultValues = new Map(String, any, {
          "en-shr_preview": false,
          "en-shr_template": "shroom-default",
          "en-shr_use-lifespan": false,
          "en-shr_lifespan": 15,
          "en-shr_use-hp": false,
          "en-shr_hp": 1,
          "en-shr_spd": 10,
          "en-shr_spd-grid": false,
          "en-shr_use-spd-rng": false,
          "en-shr_spd-rng": 0,
          "en-shr_dir": 270,
          "en-shr_use-dir-rng": false,
          "en-shr_dir-rng": false,
          "en-shr_x": 0,
          "en-shr_snap-x": false,
          "en-shr_use-rng-x": false,
          "en-shr_rng-x": false,
          "en-shr_y": 0,
          "en-shr_snap-y": false,
          "en-shr_use-rng-y": false,
          "en-shr_rng-y": 0,
          "en-shr_use-inherit": false,
          "en-shr_inherit": [],
          "en-shr_spawn-map": new TextureTemplate("texture_shroom_spawn_map", { asset: texture_shroom_spawn_map, file: "" }),
          "en-shr_hide": true,
          "en-shr_hide-spawn": true,
          "en-shr_hide-inherit": true,
          "en-shr_hide-em": true,
          "en-shr_hide-em-cfg": true,
          "en-shr_use-em": false,
          "en-shr_em-cfg": {},
        })
        Struct.set("__defaultValues", __defaultValues)
      }

      return __defaultValues
    },
    parse: function(data) {
      var defaultValues = this.defaultValues()
      return {
        "icon": Struct.parse.sprite(data, "icon"),
        "en-shr_hide": Struct.parse.boolean(data, "en-shr_hide", defaultValues.get("en-shr_hide")),
        "en-shr_hide-spawn": Struct.parse.boolean(data, "en-shr_hide-spawn", defaultValues.get("en-shr_hide-spawn")),
        "en-shr_hide-inherit": Struct.parse.boolean(data, "en-shr_hide-inherit", defaultValues.get("en-shr_hide-inherit")),
        "en-shr_hide-em": Struct.parse.boolean(data, "en-shr_hide-em", defaultValues.get("en-shr_hide-em")),
        "en-shr_hide-em-cfg": Struct.parse.boolean(data, "en-shr_hide-em-cfg", defaultValues.get("en-shr_hide-em-cfg")),
        "en-shr_preview": Struct.parse.boolean(data, "en-shr_preview", defaultValues.get("en-shr_preview")),
        "en-shr_template": Struct.parse.text(data, "en-shr_template", defaultValues.get("en-shr_template")),
        "en-shr_use-lifespan": Struct.parse.boolean(data, "en-shr_use-lifespan", defaultValues.get("en-shr_use-lifespan")),
        "en-shr_lifespan": Struct.parse.number(data, "en-shr_lifespan", defaultValues.get("en-shr_lifespan")),
        "en-shr_use-hp": Struct.parse.boolean(data, "en-shr_use-hp", defaultValues.get("en-shr_use-hp")),
        "en-shr_hp": Struct.parse.number(data, "en-shr_hp", defaultValues.get("en-shr_hp")),
        "en-shr_spd": Struct.parse.number(data, "en-shr_spd", defaultValues.get("en-shr_spd"), 0.0, 99.9),
        "en-shr_spd-grid": Struct.parse.boolean(data, "en-shr_spd-grid", defaultValues.get("en-shr_spd-grid")),
        "en-shr_use-spd-rng": Struct.parse.boolean(data, "en-shr_use-spd-rng", defaultValues.get("en-shr_use-spd-rng")),
        "en-shr_spd-rng": Struct.parse.number(data, "en-shr_spd-rng", defaultValues.get("en-shr_spd-rng"), 0.0, 99.9),
        "en-shr_dir": Struct.parse.number(data, "en-shr_dir", defaultValues.get("en-shr_dir"), 0.0, 360.0),
        "en-shr_use-dir-rng": Struct.parse.boolean(data, "en-shr_use-dir-rng", defaultValues.get("en-shr_use-dir-rng")),
        "en-shr_dir-rng": Struct.parse.number(data, "en-shr_dir-rng", defaultValues.get("en-shr_dir-rng"), 0.0, 360.0),
        "en-shr_x": Struct.parse.number(data, "en-shr_x", defaultValues.get("en-shr_x"), 
          -1.0 * (SHROOM_SPAWN_AMOUNT / 2.0), 
          SHROOM_SPAWN_AMOUNT / 2.0),
        "en-shr_snap-x": Struct.parse.boolean(data, "en-shr_snap-x", defaultValues.get("en-shr_snap-x")),
        "en-shr_use-rng-x": Struct.parse.boolean(data, "en-shr_use-rng-x", defaultValues.get("en-shr_use-rng-x")),
        "en-shr_rng-x": Struct.parse.number(data, "en-shr_rng-x", defaultValues.get("en-shr_rng-x"), 
          0.0,
          SHROOM_SPAWN_AMOUNT),
        "en-shr_y": Struct.parse.number(data, "en-shr_y", defaultValues.get("en-shr_y"),
          -1.0 * (SHROOM_SPAWN_AMOUNT / 2.0),
          SHROOM_SPAWN_AMOUNT / 2.0),
        "en-shr_snap-y": Struct.parse.boolean(data, "en-shr_snap-y", defaultValues.get("en-shr_snap-y")),
        "en-shr_use-rng-y": Struct.parse.boolean(data, "en-shr_use-rng-y", defaultValues.get("en-shr_use-rng-y")),
        "en-shr_rng-y": Struct.parse.number(data, "en-shr_rng-y", defaultValues.get("en-shr_rng-y"),
          0.0,
          SHROOM_SPAWN_AMOUNT),
        "en-shr_use-inherit": Struct.parse.boolean(data, "en-shr_use-inherit", defaultValues.get("en-shr_use-inherit")),
        "en-shr_inherit": Struct.getIfType(data, "en-shr_inherit", GMArray, defaultValues.get("en-shr_inherit")),
        "en-shr_use-em": Struct.parse.boolean(data, "en-shr_use-em", defaultValues.get("en-shr_use-em")),
        "en-shr_em-cfg": Struct.getIfType(data, "en-shr_em-cfg", Struct, defaultValues.get("en-shr_em-cfg")),
        "en-shr_spawn-map": defaultValues.get("en-shr_spawn-map"),
      }
    },
    run: function(data, channel) {
      var controller = Beans.get(BeanVisuController)
      Struct.set(data, "en-shr_texture", Struct.parse.sprite(data, "_en-shr_texture"))
      var spd = abs(Struct.get(data, "en-shr_spd")
        + (Struct.get(data, "en-shr_use-spd-rng")
          ? (random(Struct.get(data, "en-shr_spd-rng") / 2.0)
            * choose(1.0, -1.0))
          : 0.01))
        + (Struct.get(data, "en-shr_spd-grid")
          ? controller.gridService.properties.speed
          : 0.0)
      var angle = Math.normalizeAngle(Struct.get(data, "en-shr_dir")
        + (Struct.get(data, "en-shr_use-dir-rng")
          ? (random(Struct.get(data, "en-shr_dir-rng") / 2.0)
          * choose(1.0, -1.0))
        : 0.0))
      var spawnX = Struct.get(data, "en-shr_x")
        * (SHROOM_SPAWN_SIZE / SHROOM_SPAWN_AMOUNT)
        + 0.5
        + (Struct.get(data, "en-shr_use-rng-x")
          ? (random(Struct.get(data, "en-shr_rng-x") / 2.0)
            * (SHROOM_SPAWN_SIZE / SHROOM_SPAWN_AMOUNT)
            * choose(1.0, -1.0))
          : 0.0)
      var snapH = Struct.getDefault(data, "en-shr_snap-x", false)
      var spawnY = Struct.get(data, "en-shr_y")
        * (SHROOM_SPAWN_SIZE / SHROOM_SPAWN_AMOUNT)
        - 0.5
        + (Struct.get(data, "en-shr_use-rng-y")
          ? (random(Struct.get(data, "en-shr_rng-y") / 2.0)
            * (SHROOM_SPAWN_SIZE / SHROOM_SPAWN_AMOUNT)
            * choose(1.0, -1.0))
          : 0.0)
      var snapV = Struct.getDefault(data, "en-shr_snap-y", false)
      var lifespan = Struct.get(data, "en-shr_use-lifespan") ? Struct.get(data, "en-shr_lifespan") : null
      var hp = Struct.get(data, "en-shr_use-hp") ? Struct.get(data, "en-shr_hp") : null
      var inherit = Struct.get(data, "en-shr_use-inherit") ? Struct.get(data, "en-shr_inherit") : null
      var template = Struct.get(data, "en-shr_template")
      if (Struct.get(data, "en-shr_use-em")) {
        controller.shroomService.spawnShroomEmitter({
          name: template,
          spawnX: spawnX,
          spawnY: spawnY,
          angle: angle,
          speed: spd,
          snapH: snapH,
          snapV: snapV,
          lifespan: lifespan,
          hp: hp,
          inherit: inherit
        }, Struct.get(data, "en-shr_em-cfg"))
      } else {
        controller.shroomService.spawnShroom(
          template,
          spawnX,
          spawnY,
          angle,
          spd,
          snapH,
          snapV,
          lifespan,
          hp,
          inherit
        )
      }
    },
  },
  "brush_entity_bullet": {
    defaultValues: function() {
      var __defaultValues = Struct.get("__defaultValues")
      if (__defaultValues == null) {
        __defaultValues = new Map(String, any, {
          "en-blt_preview": false,
          "en-blt_template": "bullet-default",
          "en-blt_use-lifespan": false,
          "en-blt_lifespan": 15,
          "en-blt_use-hp": false,
          "en-blt_hp": 1,
          "en-blt_spd": 10,
          "en-blt_spd-grid": false,
          "en-blt_use-spd-rng": false,
          "en-blt_spd-rng": 0,
          "en-blt_dir": 270,
          "en-blt_use-dir-rng": false,
          "en-blt_dir-rng": false,
          "en-blt_x": 0,
          "en-blt_snap-x": false,
          "en-blt_use-rng-x": false,
          "en-blt_rng-x": false,
          "en-blt_y": 0,
          "en-blt_snap-y": false,
          "en-blt_use-rng-y": false,
          "en-blt_rng-y": 0,
          "en-blt_use-inherit": false,
          "en-blt_inherit": [],
          "en-blt_spawn-map": new TextureTemplate("texture_shroom_spawn_map", { asset: texture_shroom_spawn_map, file: "" }),
          "en-blt_hide": true,
          "en-blt_hide-spawn": true,
          "en-blt_hide-inherit": true,
          "en-blt_hide-em": true,
          "en-blt_hide-em-cfg": true,
          "en-blt_use-em": false,
          "en-blt_em-cfg": {},
        })
        Struct.set("__defaultValues", __defaultValues)
      }

      return __defaultValues
    },
    parse: function(data) {
      var defaultValues = this.defaultValues()
      return {
        "icon": Struct.parse.sprite(data, "icon"),
        "en-blt_hide": Struct.parse.boolean(data, "en-blt_hide", defaultValues.get("en-blt_hide")),
        "en-blt_hide-spawn": Struct.parse.boolean(data, "en-blt_hide-spawn", defaultValues.get("en-blt_hide-spawn")),
        "en-blt_hide-em": Struct.parse.boolean(data, "en-blt_hide-em", defaultValues.get("en-blt_hide-em")),
        "en-blt_hide-em-cfg": Struct.parse.boolean(data, "en-blt_hide-em-cfg", defaultValues.get("en-blt_hide-em-cfg")),
        "en-blt_preview": Struct.parse.boolean(data, "en-blt_preview", defaultValues.get("en-blt_preview")),
        "en-blt_template": Struct.parse.text(data, "en-blt_template", defaultValues.get("en-blt_template")),
        "en-blt_use-lifespan": Struct.parse.boolean(data, "en-blt_use-lifespan", defaultValues.get("en-blt_use-lifespan")),
        "en-blt_lifespan": Struct.parse.number(data, "en-blt_lifespan", defaultValues.get("en-blt_lifespan")),
        "en-blt_use-dmg": Struct.parse.boolean(data, "en-blt_use-dmg",  defaultValues.get("en-blt_use-dmg")),
        "en-blt_dmg": Struct.parse.number(data, "en-blt_dmg", defaultValues.get("en-blt_dmg")),
        "en-blt_spd": Struct.parse.number(data, "en-blt_spd", defaultValues.get("en-blt_spd"), 0.0, 99.9),
        "en-blt_spd-grid": Struct.parse.boolean(data, "en-blt_spd-grid", defaultValues.get("en-blt_spd-grid")),
        "en-blt_use-spd-rng": Struct.parse.boolean(data, "en-blt_use-spd-rng", defaultValues.get("en-blt_use-spd-rng")),
        "en-blt_spd-rng": Struct.parse.number(data, "en-blt_spd-rng", defaultValues.get("en-blt_spd-rng"), 0.0, 99.9),
        "en-blt_dir": Struct.parse.number(data, "en-blt_dir", defaultValues.get("en-blt_dir"), 0.0, 360.0),
        "en-blt_use-dir-rng": Struct.parse.boolean(data, "en-blt_use-dir-rng", defaultValues.get("en-blt_use-dir-rng")),
        "en-blt_dir-rng": Struct.parse.number(data, "en-blt_dir-rng", defaultValues.get("en-blt_dir-rng"), 0.0, 360.0),
        "en-blt_x": Struct.parse.number(data, "en-blt_x", defaultValues.get("en-blt_x"), 
          -1.0 * (SHROOM_SPAWN_AMOUNT / 2.0), 
          SHROOM_SPAWN_AMOUNT / 2.0),
        "en-blt_snap-x": Struct.parse.boolean(data, "en-blt_snap-x", defaultValues.get("en-blt_snap-x")),
        "en-blt_use-rng-x": Struct.parse.boolean(data, "en-blt_use-rng-x", defaultValues.get("en-blt_use-rng-x")),
        "en-blt_rng-x": Struct.parse.number(data, "en-blt_rng-x", defaultValues.get("en-blt_rng-x"), 
          0.0,
          SHROOM_SPAWN_AMOUNT),
        "en-blt_y": Struct.parse.number(data, "en-blt_y", defaultValues.get("en-blt_y"),
          -1.0 * (SHROOM_SPAWN_AMOUNT / 2.0),
          SHROOM_SPAWN_AMOUNT / 2.0),
        "en-blt_snap-y": Struct.parse.boolean(data, "en-blt_snap-y", defaultValues.get("en-blt_snap-y")),
        "en-blt_use-rng-y": Struct.parse.boolean(data, "en-blt_use-rng-y", defaultValues.get("en-blt_use-rng-y")),
        "en-blt_rng-y": Struct.parse.number(data, "en-blt_rng-y", defaultValues.get("en-blt_rng-y"),
          0.0,
          SHROOM_SPAWN_AMOUNT),
        "en-blt_use-em": Struct.parse.boolean(data, "en-blt_use-em", defaultValues.get("en-blt_use-em")),
        "en-blt_em-cfg": Struct.getIfType(data, "en-blt_em-cfg", Struct, defaultValues.get("en-blt_em-cfg")),
      }
    },
    run: function(data, channel) {
      var controller = Beans.get(BeanVisuController)
      var spd = abs(Struct.get(data, "en-blt_spd")
        + (Struct.get(data, "en-blt_use-spd-rng")
          ? (random(Struct.get(data, "en-blt_spd-rng") / 2.0)
            * choose(1.0, -1.0))
          : 0.01))
        + (Struct.get(data, "en-blt_spd-grid")
          ? controller.gridService.properties.speed
          : 0.0)
      var angle = Math.normalizeAngle(Struct.get(data, "en-blt_dir")
        + (Struct.get(data, "en-blt_use-dir-rng")
          ? (random(Struct.get(data, "en-blt_dir-rng") / 2.0)
          * choose(1.0, -1.0))
        : 0.0))
      var spawnX = Struct.get(data, "en-blt_x")
        * (SHROOM_SPAWN_SIZE / SHROOM_SPAWN_AMOUNT)
        + 0.5
        + (Struct.get(data, "en-blt_use-rng-x")
          ? (random(Struct.get(data, "en-blt_rng-x") / 2.0)
            * (SHROOM_SPAWN_SIZE / SHROOM_SPAWN_AMOUNT)
            * choose(1.0, -1.0))
          : 0.0)
      var snapH = Struct.getDefault(data, "en-blt_snap-x", false)
      var spawnY = Struct.get(data, "en-blt_y")
        * (SHROOM_SPAWN_SIZE / SHROOM_SPAWN_AMOUNT)
        - 0.5
        + (Struct.get(data, "en-blt_use-rng-y")
          ? (random(Struct.get(data, "en-blt_rng-y") / 2.0)
            * (SHROOM_SPAWN_SIZE / SHROOM_SPAWN_AMOUNT)
            * choose(1.0, -1.0))
          : 0.0)
      var snapV = Struct.getDefault(data, "en-blt_snap-y", false)
      var lifespan = Struct.get(data, "en-blt_use-lifespan") ? Struct.get(data, "en-blt_lifespan") : null
      var damage = Struct.get(data, "en-blt_use-dmg") ? Struct.get(data, "en-blt_dmg") : null
      var template = Struct.get(data, "en-blt_template")
      var angleOffset = null
      var angleOffsetRng = null
      var sumAngleOffset = null
      var speedOffset = null
      var sumSpeedOffset = null
      if (Struct.get(data, "en-blt_use-em")) {
        controller.bulletService.spawnBulletEmitter({
          name: template,
          spawnX: spawnX,
          spawnY: spawnY,
          angle: angle,
          speed: spd,
          snapH: snapH,
          snapV: snapV,
          lifespan: lifespan,
          damage: damage,
          angleOffset: angleOffset,
          angleOffsetRng: angleOffsetRng,
          sumAngleOffset: sumAngleOffset,
          speedOffset: speedOffset,
          sumSpeedOffset: sumSpeedOffset,
        }, Struct.get(data, "en-blt_em-cfg"))
      } else {
        var view = controller.gridService.view
        var locked = controller.gridService.targetLocked
        var viewX = snapH ? locked.snapH : view.x
        var viewY = snapV ? locked.snapV : view.y
        controller.bulletService.spawnBullet(
          template,
          Shroom,
          viewX + spawnX,
          viewY + spawnY,
          angle,
          spd,
          angleOffset,
          angleOffsetRng,
          sumAngleOffset,
          speedOffset,
          sumSpeedOffset,
          lifespan,
          damage
        )
      }
    },
  },
  "brush_entity_coin": {
    defaultValues: function() {
      var __defaultValues = Struct.get("__defaultValues")
      if (__defaultValues == null) {
        __defaultValues = new Map(String, any, {
          "en-coin_hide": true,
          "en-coin_hide-spawn": true,
          "en-coin_preview": true,
          "en-coin_template": "coin-default",
          "en-coin_snap-x": false,
          "en-coin_use-rng-x": false,
          "en-coin_snap-y": false,
          "en-coin_use-rng-y": false,
          "en-coin_x": 0.0,
          "en-coin_rng-x": 0.0,
          "en-coin_y": 0.0,
          "en-coin_rng-y": 0.0,
        })
        Struct.set("__defaultValues", __defaultValues)
      }

      return __defaultValues
    },
    parse: function(data) {
      var defaultValues = this.defaultValues()
      return {
        "icon": Struct.parse.sprite(data, "icon"),
        "en-coin_hide": Struct.parse.boolean(data, "en-coin_hide"),
        "en-coin_hide-spawn": Struct.parse.boolean(data, "en-shr_coin-spawn"),
        "en-coin_preview": Struct.parse.boolean(data, "en-coin_preview"),
        "en-coin_template": Struct.parse.text(data, "en-coin_template", defaultValues.get("en-coin_template")),
        "en-coin_x": Struct.parse.number(data, "en-coin_x", defaultValues.get("en-coin_x"),
          -1.0 * (SHROOM_SPAWN_AMOUNT / 2.0),
          SHROOM_SPAWN_AMOUNT / 2.0),
        "en-coin_snap-x": Struct.parse.boolean(data, "en-coin_snap-x"),
        "en-coin_use-rng-x": Struct.parse.boolean(data, "en-coin_use-rng-x"),
        "en-coin_rng-x": Struct.parse.number(data, "en-coin_rng-x", defaultValues.get("en-coin_rng-x"),
          0.0,
          SHROOM_SPAWN_AMOUNT),
        "en-coin_y": Struct.parse.number(data, "en-coin_y", defaultValues.get("en-coin_y"),
          -1.0 * (SHROOM_SPAWN_AMOUNT / 2.0),
          SHROOM_SPAWN_AMOUNT / 2.0),
        "en-coin_snap-y": Struct.parse.boolean(data, "en-coin_snap-y"),
        "en-coin_use-rng-y": Struct.parse.boolean(data, "en-coin_use-rng-y"),
        "en-coin_rng-y": Struct.parse.number(data, "en-coin_rng-y", defaultValues.get("en-coin_rng-y"),
          0.0, 
          SHROOM_SPAWN_AMOUNT),
      }
    },
    run: function(data, channel) {
      var controller = Beans.get(BeanVisuController)
      var view = controller.gridService.view
      var viewX = Struct.get(data, "en-coin_snap-x")
        ? floor(view.x / (view.width / 2.0)) * (view.width / 2.0)
        : view.x
      var viewY = Struct.get(data, "en-coin_snap-y")
        ? floor(view.y / (view.height / 2.0)) * (view.height / 2.0)
        : view.y

      ///@description feature TODO entity.coin.spawn
      controller.coinService.spawnCoin(
        Struct.get(data, "en-coin_template"),
        viewX + Struct.get(data, "en-coin_x")
          * (SHROOM_SPAWN_SIZE / SHROOM_SPAWN_AMOUNT)
          + 0.5
          + (Struct.get(data, "en-coin_use-rng-x")
            ? (random(Struct.get(data, "en-coin_rng-x") / 2.0)
              * (SHROOM_SPAWN_SIZE / SHROOM_SPAWN_AMOUNT)
              * choose(1.0, -1.0))
            : 0.0),
        viewY + Struct.get(data, "en-coin_y")
          * (SHROOM_SPAWN_SIZE / SHROOM_SPAWN_AMOUNT)
          - 0.5
          + (Struct.get(data, "en-coin_use-rng-y")
            ? (random(Struct.get(data, "en-coin_rng-y") / 2.0)
              * (SHROOM_SPAWN_SIZE / SHROOM_SPAWN_AMOUNT)
              * choose(1.0, -1.0))
            : 0.0))

      /*
      controller.coinService.send(new Event("spawn-coin", {
        template: Struct.get(data, "en-coin_template"),
        x: viewX + Struct.get(data, "en-coin_x")
          * (SHROOM_SPAWN_SIZE / SHROOM_SPAWN_AMOUNT)
          + 0.5
          + (Struct.get(data, "en-coin_use-rng-x")
            ? (random(Struct.get(data, "en-coin_rng-x") / 2.0)
              * (SHROOM_SPAWN_SIZE / SHROOM_SPAWN_AMOUNT)
              * choose(1.0, -1.0))
            : 0.0),
        y: viewY + Struct.get(data, "en-coin_y")
          * (SHROOM_SPAWN_SIZE / SHROOM_SPAWN_AMOUNT)
          - 0.5
          + (Struct.get(data, "en-coin_use-rng-y")
            ? (random(Struct.get(data, "en-coin_rng-y") / 2.0)
              * (SHROOM_SPAWN_SIZE / SHROOM_SPAWN_AMOUNT)
              * choose(1.0, -1.0))
            : 0.0),
      }))
      */
    },
  },
  "brush_entity_player": {
    defaultValues: function() {
      var __defaultValues = Struct.get("__defaultValues")
      if (__defaultValues == null) {
        __defaultValues = new Map(String, any, {
          "en-pl_hide": true,
          "en-pl_hide-texture": true,
          "en-pl_hide-mask": true,
          "en-pl_hide-stats": true,
          "en-pl_hide-cfg": true,
          "en-pl_texture": SpriteUtil.parse({ name: "texture_player" }),
          "en-pl_use-mask": true,
          "en-pl_mask": new Rectangle({
            x: 60,
            y: 64,
            width: 52,
            height: 52
          }),
          "en-pl_reset-pos": false,
          "en-pl_shadow": true,
          "en-pl_use-stats": true,
          "en-pl_stats": {
            force: { value: 0 },
            point: { value: 0 },
            bomb: { value: 5 },
            life: { value: 4 },
          },
          "en-pl_use-bullethell": true,
          "en-pl_bullethell": {
            x: {
              friction: 9.3,
              acceleration: 1.92,
              speedMax: 2.1,
            },
            y: {
              friction: 9.3,
              acceleration: 1.92,
              speedMax: 2.1,
            },
            guns: [
              {
                angle:  90,
                bullet: "bullet-default",
                cooldown: 8.0,
                offsetX:  0.0,
                offsetY:  0.0,
                speed:  10.0,
              }
            ]
          },
        })
        Struct.set("__defaultValues", __defaultValues)
      }

      return __defaultValues
    },
    parse: function(data) {
      var defaultValues = this.defaultValues()
      return {
        "icon": Struct.parse.sprite(data, "icon"),
        "en-pl_hide": Struct.parse.boolean(data, "en-pl_hide", defaultValues.get("en-pl_hide")),
        "en-pl_hide-texture": Struct.parse.boolean(data, "en-pl_hide-texture", defaultValues.get("en-pl_hide-texture")),
        "en-pl_hide-mask": Struct.parse.boolean(data, "en-pl_hide-mask", defaultValues.get("en-pl_hide-mask")),
        "en-pl_hide-stats": Struct.parse.boolean(data, "en-pl_hide-stats", defaultValues.get("en-pl_hide-stats")),
        "en-pl_hide-cfg": Struct.parse.boolean(data, "en-pl_hide-cfg", defaultValues.get("en-pl_hide-cfg")),
        "en-pl_texture": Struct.parse.sprite(data, "en-pl_texture", defaultValues.get("en-pl_texture").serialize()),
        "en-pl_use-mask": Struct.parse.boolean(data, "en-pl_use-mask", defaultValues.get("en-pl_use-mask")),
        "en-pl_mask": Struct.parse.rectangle(data, "en-pl_mask", defaultValues.get("en-pl_mask").serialize()),
        "en-pl_reset-pos": Struct.parse.boolean(data, "en-pl_reset-pos", defaultValues.get("en-pl_reset-pos")),
        "en-pl_shadow": Struct.parse.boolean(data, "en-pl_shadow", defaultValues.get("en-pl_shadow")),
        "en-pl_use-stats": Struct.parse.boolean(data, "en-pl_use-stats", defaultValues.get("en-pl_use-stats")),
        "en-pl_stats": Struct.getIfType(data, "en-pl_stats", Struct, defaultValues.get("en-pl_stats")),
        "en-pl_use-bullethell": Struct.parse.boolean(data, "en-pl_use-bullethell", defaultValues.get("en-pl_use-bullethell")),
        "en-pl_bullethell": Struct.getIfType(data, "en-pl_bullethell", Struct, defaultValues.get("en-pl_bullethell")),
      }
    },
    run: function(data, channel) {
      var controller = Beans.get(BeanVisuController)
      ///@description feature TODO entity.player.spawn
      controller.playerService.send(new Event("spawn-player", {
        "sprite": Struct.get(data, "en-pl_texture").serialize(),
        "mask": Struct.get(data, "en-pl_mask").serialize(),
        "reset-position": Struct.get(data, "en-pl_reset-pos")
          ? Struct.get(data, "en-pl_reset-pos")
          : false,
        "stats": Struct.get(data, "en-pl_use-stats")
          ? Struct.get(data, "en-pl_stats")
          : null,
        "handler": Struct.get(data, "en-pl_use-bullethell")
          ? Struct.get(data, "en-pl_bullethell")
          : null,
      }))

      ///@description feature TODO grid.player.shadow
      Struct.set(controller.gridService.properties, "playerShadowEnable", Struct.get(data, "en-pl_shadow"))
    },
  },
  "brush_entity_config": {
    defaultValues: function() {
      var __defaultValues = Struct.get("__defaultValues")
      if (__defaultValues == null) {
        __defaultValues = new Map(String, any, {
          "en-cfg_hide-render": true,
          "en-cfg_hide-cls": true,
          "en-cfg_hide-cfg": true,
          "en-cfg_hide-shroom": true,
          "en-cfg_hide-player": true,
          "en-cfg_hide-coin": true,
          "en-cfg_hide-bullet": true,
          "en-cfg_use-render-shr": true,
          "en-cfg_render-shr": true,
          "en-cfg_use-render-player": true,
          "en-cfg_render-player": true,
          "en-cfg_use-render-coin": true,
          "en-cfg_render-coin": true,
          "en-cfg_use-render-bullet": true,
          "en-cfg_render-bullet": true,
          "en-cfg_cls-shr": true,
          "en-cfg_cls-player": true,
          "en-cfg_cls-coin": true,
          "en-cfg_cls-bullet": true,
          "en-cfg_use-z-shr": true,
          "en-cfg_change-z-shr": true,
          "en-cfg_use-z-player": true,
          "en-cfg_change-z-player": true,
          "en-cfg_use-z-coin": true,
          "en-cfg_change-z-coin": true,
          "en-cfg_use-z-bullet": true,
          "en-cfg_change-z-bullet": true,
          "en-cfg_z-shr": {
            value: 2045,
            clampValue: { from: 0.0, to: 99999.9 },
            clampTarget: { from: 0.0, to: 99999.9 },
          },
          "en-cfg_z-player": {
            value: 2051,
            clampValue: { from: 0.0, to: 99999.9 },
            clampTarget: { from: 0.0, to: 99999.9 },
          },
          "en-cfg_z-coin": {
            value: 2047,
            clampValue: { from: 0.0, to: 99999.9 },
            clampTarget: { from: 0.0, to: 99999.9 },
          },
          "en-cfg_z-bullet": {
            value: 2048,
            clampValue: { from: 0.0, to: 99999.9 },
            clampTarget: { from: 0.0, to: 99999.9 },
          },
        })
        Struct.set("__defaultValues", __defaultValues)
      }

      return __defaultValues
    },
    parse: function(data) {
      var defaultValues = this.defaultValues()
      return {
        "icon": Struct.parse.sprite(data, "icon"),
        "en-cfg_hide-render": Struct.parse.boolean(data, "en-cfg_hide-render", defaultValues.get("en-cfg_hide-render")),
        "en-cfg_hide-cls": Struct.parse.boolean(data, "en-cfg_hide-cls", defaultValues.get("en-cfg_hide-cls")),
        "en-cfg_hide-cfg": Struct.parse.boolean(data, "en-cfg_hide-cfg", defaultValues.get("en-cfg_hide-cfg")),
        "en-cfg_hide-shroom": Struct.parse.boolean(data, "en-cfg_hide-shroom", defaultValues.get("en-cfg_hide-shroom")),
        "en-cfg_hide-player": Struct.parse.boolean(data, "en-cfg_hide-player", defaultValues.get("en-cfg_hide-player")),
        "en-cfg_hide-coin": Struct.parse.boolean(data, "en-cfg_hide-coin", defaultValues.get("en-cfg_hide-coin")),
        "en-cfg_hide-bullet": Struct.parse.boolean(data, "en-cfg_hide-bullet", defaultValues.get("en-cfg_hide-bullet")),
        "en-cfg_use-render-shr": Struct.parse.boolean(data, "en-cfg_use-render-shr", defaultValues.get("en-cfg_use-render-shr")),
        "en-cfg_render-shr": Struct.parse.boolean(data, "en-cfg_render-shr", defaultValues.get("en-cfg_render-shr")),
        "en-cfg_use-render-player": Struct.parse.boolean(data, "en-cfg_use-render-player", defaultValues.get("en-cfg_use-render-player")),
        "en-cfg_render-player": Struct.parse.boolean(data, "en-cfg_render-player", defaultValues.get("en-cfg_render-player")),
        "en-cfg_use-render-coin": Struct.parse.boolean(data, "en-cfg_use-render-coin", defaultValues.get("en-cfg_use-render-coin")),
        "en-cfg_render-coin": Struct.parse.boolean(data, "en-cfg_render-coin", defaultValues.get("en-cfg_render-coin")),
        "en-cfg_use-render-bullet": Struct.parse.boolean(data, "en-cfg_use-render-bullet", defaultValues.get("en-cfg_use-render-bullet")),
        "en-cfg_render-bullet": Struct.parse.boolean(data, "en-cfg_render-bullet", defaultValues.get("en-cfg_render-bullet")),
        "en-cfg_cls-shr": Struct.parse.boolean(data, "en-cfg_cls-shr", defaultValues.get("en-cfg_cls-shr")),
        "en-cfg_cls-player": Struct.parse.boolean(data, "en-cfg_cls-player", defaultValues.get("en-cfg_cls-player")),
        "en-cfg_cls-coin": Struct.parse.boolean(data, "en-cfg_cls-coin", defaultValues.get("en-cfg_cls-coin")),
        "en-cfg_cls-bullet": Struct.parse.boolean(data, "en-cfg_cls-bullet", defaultValues.get("en-cfg_cls-bullet")),
        "en-cfg_use-z-shr": Struct.parse.boolean(data, "en-cfg_use-z-shr", defaultValues.get("en-cfg_use-z-shr")),
        "en-cfg_z-shr": Struct.parse.numberTransformer(data, "en-cfg_z-shr", defaultValues.get("en-cfg_z-shr")),
        "en-cfg_change-z-shr": Struct.parse.boolean(data, "en-cfg_change-z-shr", defaultValues.get("en-cfg_change-z-shr")),
        "en-cfg_use-z-player": Struct.parse.boolean(data, "en-cfg_use-z-player", defaultValues.get("en-cfg_use-z-player")),
        "en-cfg_z-player": Struct.parse.numberTransformer(data, "en-cfg_z-player", defaultValues.get("en-cfg_z-player")),
        "en-cfg_change-z-player": Struct.parse.boolean(data, "en-cfg_change-z-player", defaultValues.get("en-cfg_change-z-player")),
        "en-cfg_use-z-coin": Struct.parse.boolean(data, "en-cfg_use-z-coin", defaultValues.get("en-cfg_use-z-coin")),
        "en-cfg_z-coin": Struct.parse.numberTransformer(data, "en-cfg_z-coin", defaultValues.get("en-cfg_z-coin")),
        "en-cfg_change-z-coin": Struct.parse.boolean(data, "en-cfg_change-z-coin", defaultValues.get("en-cfg_change-z-coin")),
        "en-cfg_use-z-bullet": Struct.parse.boolean(data, "en-cfg_use-z-bullet", defaultValues.get("en-cfg_use-z-bullet")),
        "en-cfg_z-bullet": Struct.parse.numberTransformer(data, "en-cfg_z-bullet", defaultValues.get("en-cfg_z-bullet")),
        "en-cfg_change-z-bullet": Struct.parse.boolean(data, "en-cfg_change-z-bullet", defaultValues.get("en-cfg_change-z-bullet")),
      }
    },
    run: function(data, channel) {
      var controller = Beans.get(BeanVisuController)
      Struct.get(data, "en-cfg_z-shr").reset()
      Struct.get(data, "en-cfg_z-player").reset()
      Struct.get(data, "en-cfg_z-coin").reset()
      Struct.get(data, "en-cfg_z-bullet").reset()
      var gridService = controller.gridService
      var properties = gridService.properties
      var pump = gridService.dispatcher
      var executor = gridService.executor
      var depths = properties.depths

      ///@description feature TODO grid.shroom.render
      Visu.resolveBooleanTrackEvent(data,
        "en-cfg_use-render-shr",
        "en-cfg_render-shr",
        "renderShrooms",
        properties)

      ///@description feature TODO grid.player.render
      Visu.resolveBooleanTrackEvent(data,
        "en-cfg_use-render-player",
        "en-cfg_render-player",
        "renderPlayer",
        properties)

      ///@description feature TODO grid.coin.render
      Visu.resolveBooleanTrackEvent(data,
        "en-cfg_use-render-coin",
        "en-cfg_render-coin",
        "renderCoins",
        properties)

      ///@description feature TODO grid.bullet.render
      Visu.resolveBooleanTrackEvent(data,
        "en-cfg_use-render-bullet",
        "en-cfg_render-bullet",
        "renderBullets",
        properties)

      ///@description feature TODO grid.shroom.clear
      Visu.resolveSendEventTrackEvent(data,
        "en-cfg_cls-shr",
        "clear-shrooms",
        null,
        controller.shroomService.dispatcher)

      ///@description feature TODO grid.player.clear
      Visu.resolveSendEventTrackEvent(data,
        "en-cfg_cls-player",
        "clear-player",
        null,
        controller.playerService.dispatcher)

      ///@description feature TODO grid.coin.clear
      Visu.resolveSendEventTrackEvent(data,
        "en-cfg_cls-coin",
        "clear-coins",
        null,
        controller.coinService.dispatcher)

      ///@description feature TODO grid.bullets.clear
      Visu.resolveSendEventTrackEvent(data,
        "en-cfg_cls-bullet",
        "clear-bullets",
        null,
        controller.bulletService.dispatcher)

      ///@description feature TODO grid.shroom.z
      Visu.resolveNumberTransformerTrackEvent(data, 
        "en-cfg_use-z-shr",
        "en-cfg_z-shr",
        "en-cfg_change-z-shr",
        "shroomZ",
        depths, pump, executor)

      ///@description feature TODO grid.player.z
      Visu.resolveNumberTransformerTrackEvent(data, 
        "en-cfg_use-z-player",
        "en-cfg_z-player",
        "en-cfg_change-z-player",
        "playerZ",
        depths, pump, executor)

      ///@description feature TODO grid.coin.z
      Visu.resolveNumberTransformerTrackEvent(data, 
        "en-cfg_use-z-coin",
        "en-cfg_z-coin",
        "en-cfg_change-z-coin",
        "coinZ",
        depths, pump, executor)

      ///@description feature TODO grid.bullet.z
      Visu.resolveNumberTransformerTrackEvent(data, 
        "en-cfg_use-z-bullet",
        "en-cfg_z-bullet",
        "en-cfg_change-z-bullet",
        "bulletZ",
        depths, pump, executor)
    },
  },
}
#macro entity_track_event global.__entity_track_event
