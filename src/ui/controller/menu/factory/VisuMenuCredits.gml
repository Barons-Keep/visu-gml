///@package fun.barons-keep.visu.ui.controller.menu

///@param {?Struct} [_config]
///@return {Event}
function factoryVisuMenuOpenCreditsEvent(_config = null) {
  static factoryCreditsEntry = function(index, text, url = null) {
    return {
      name: $"credits_menu-button-entry_{index}",
      template: VisuComponents.get("menu-label-entry"),
      layout: VisuLayouts.get("menu-button-entry"),
      config: {
        layout: { type: UILayoutType.VERTICAL },
        label: {
          text: text,
          url: url,
          callback: new BindIntent(function() {
            if (Core.isType(this.url, String)) {
              url_open(this.url)
            }
          }),
          onMouseReleasedLeft: function() {
            this.callback()
          },
        },
      }
    }
  }

  var controller = Beans.get(BeanVisuController)
  var generator = {
    count: 0,
    seed: 2137,
    run: function() {
      this.count += 1
      return sha1_string_utf8($"{this.count + this.seed}")
    },
  }

  var config = Struct.appendUnique(_config, {
    back: controller.menu.factories.get("menu-main"),
  })

  var event = new Event("open").setData({
    back: config.back,
    layout: controller.visuRenderer.layout,
    title: {
      name: "credits_title",
      template: VisuComponents.get("menu-title"),
      layout: VisuLayouts.get("menu-title"),
      config: {
        label: { 
          text: Language.get("visu.menu.credits", "Credits"),
        },
      },
    },
    content: new Array(Struct, [
      factoryMenuButtonEntryTitle(generator.run(), "Game design"),
      factoryCreditsEntry(generator.run(), "Alkapivo", "https://github.com/Alkapivo"),
      factoryCreditsEntry(generator.run(), "kattybratt", "https://github.com/kattybratt"),
      factoryMenuButtonEntryTitle(generator.run(), "Level design"),
      factoryCreditsEntry(generator.run(), "Alkapivo", "https://github.com/Alkapivo"),
      factoryCreditsEntry(generator.run(), "kattybratt", "https://github.com/kattybratt"),
      factoryMenuButtonEntryTitle(generator.run(), "Music"),
      factoryCreditsEntry(generator.run(), "GOETIA - Death of the Muse - Create and Yet Fate's Faw Avoid", "https://sigillumazoetia.bandcamp.com/track/create-and-yet-fates-faw-avoid"),
      factoryCreditsEntry(generator.run(), "GOETIA - Cerecloth", "https://www.youtube.com/watch?v=-l4Q5X8Kj6I"),
      factoryCreditsEntry(generator.run(), "kattybratt - pulsar", "https://dogpunk.bandcamp.com/track/07-pulsar"),
      factoryCreditsEntry(generator.run(), "kedy_selma - Just To Create Something", "https://www.youtube.com/watch?v=xR_Q6hbTtgA"),
      factoryCreditsEntry(generator.run(), "kedy_selma - Passion", "https://www.youtube.com/watch?v=wKkWH1uFcbc"),
      factoryCreditsEntry(generator.run(), "pikaro & PAXNKOXD - the memories fade but the feeling remains", "https://www.youtube.com/watch?v=0cVlto8BBO4"),
      factoryCreditsEntry(generator.run(), "Schnoopy - Destination Unknown", "https://schnoopy.bandcamp.com/track/destination-unknown"),
      factoryCreditsEntry(generator.run(), "Sewerslvt - Psychosis", "https://www.youtube.com/watch?v=oT-0HHd-9Fw"),
      factoryCreditsEntry(generator.run(), "Sewerslvt - Purple Hearts In Her Eyes", "https://www.youtube.com/watch?v=dTh4cp_ypu4"),
      factoryCreditsEntry(generator.run(), "zoogies - digitalshadow", "https://zmuda.dev"),
      factoryCreditsEntry(generator.run(), "4evrx - life.delete", "https://www.youtube.com/watch?v=yO3uw8h_rR4"),
      factoryMenuButtonEntryTitle(generator.run(), "Code"),
      factoryCreditsEntry(generator.run(), "Alkapivo - visu-project", "https://github.com/Barons-Keep/visu-project"),
      factoryCreditsEntry(generator.run(), "Alkapivo - visu-gml", "https://github.com/Barons-Keep/visu-gml"),
      factoryCreditsEntry(generator.run(), "Alkapivo - core-gml", "https://github.com/Alkapivo/core-gml"),
      factoryCreditsEntry(generator.run(), "Alkapivo - gm-cli", "https://github.com/Alkapivo/gm-cli"),
      factoryCreditsEntry(generator.run(), "Alkapivo, maras_cz - mh-cz.gmtf-gml", "https://github.com/Alkapivo/mh-cz.gmtf-gml"),
      factoryCreditsEntry(generator.run(), "Alkapivo, blokatt - fyi.odditica.bktGlitch-gml", "https://github.com/Alkapivo/fyi.odditica.bktGlitch-gml"),
      factoryCreditsEntry(generator.run(), "Alkapivo, LAGameStudio - com.la-game-studio.input-candy-gml", "https://github.com/Alkapivo/com.la-game-studio.input-candy-gml"),
      //factoryCreditsEntry(generator.run(), "Alkapivo, Pixelated_Pope - com.pixelatedpope.tdmc-gml", "https://github.com/Alkapivo/com.pixelatedpope.tdmc-gml"),
      factoryMenuButtonEntryTitle(generator.run(), "QA"),
      factoryCreditsEntry(generator.run(), "maister_kapli", "https://www.youtube.com/@maister_kapli8184"),
      factoryCreditsEntry(generator.run(), "kattybratt", "https://github.com/kattybratt"),
      factoryCreditsEntry(generator.run(), "XieXie", "https://forum.marianabay.com/members/xiexie.171/"),
      factoryMenuButtonEntryTitle(generator.run(), "Shaders"),
      factoryCreditsEntry(generator.run(), "Alkapivo - Arc Runner", "https://github.com/Alkapivo/core-gml"),
      factoryCreditsEntry(generator.run(), "Alkapivo - Astral Flow", "https://github.com/Alkapivo/core-gml"),
      factoryCreditsEntry(generator.run(), "Alkapivo - Cloudy Sky", "https://github.com/Alkapivo/core-gml"),
      factoryCreditsEntry(generator.run(), "Alkapivo - Deep Space", "https://github.com/Alkapivo/core-gml"),
      factoryCreditsEntry(generator.run(), "Alkapivo - Fractal Bloom", "https://github.com/Alkapivo/core-gml"),
      factoryCreditsEntry(generator.run(), "Alkapivo - Funk Flux", "https://github.com/Alkapivo/core-gml"),
      factoryCreditsEntry(generator.run(), "Alkapivo - Hyperspace", "https://github.com/Alkapivo/core-gml"),
      factoryCreditsEntry(generator.run(), "Alkapivo - Polycular", "https://github.com/Alkapivo/core-gml"),
      factoryCreditsEntry(generator.run(), "Alkapivo - Warp Pulse", "https://github.com/Alkapivo/core-gml"),
      factoryCreditsEntry(generator.run(), "Alkapivo - Wavy Lines", "https://github.com/Alkapivo/core-gml"),
      factoryCreditsEntry(generator.run(), "Alkapivo - Wavy Mesh", "https://github.com/Alkapivo/core-gml"),
      factoryCreditsEntry(generator.run(), "Alkapivo - Wavy Spectrum", "https://github.com/Alkapivo/core-gml"),
      factoryCreditsEntry(generator.run(), "Alkapivo - Wormhole Vortex", "https://github.com/Alkapivo/core-gml"),
      factoryCreditsEntry(generator.run(), "ChunderFPV - SINCOS 3D", "https://shadertoy.com/view/XfXGz4"),
      factoryCreditsEntry(generator.run(), "Dave_Hoskins - WARP SPEED 2", "https://shadertoy.com/view/4tjSDt"),
      factoryCreditsEntry(generator.run(), "haquxx - 002 BLUE", "https://shadertoy.com/view/WldSRn"),
      factoryCreditsEntry(generator.run(), "iekdosha - BROKEN TIME PORTAL", "https://shadertoy.com/view/XXcGWr"),
      factoryCreditsEntry(generator.run(), "iq - WARP", "https://shadertoy.com/view/lsl3RH"),
      factoryCreditsEntry(generator.run(), "Kali - STAR NEST", "https://shadertoy.com/view/XlfGRj"),
      factoryCreditsEntry(generator.run(), "kasari39 - PHANTOM STAR", "https://shadertoy.com/view/ttKGDt"),
      factoryCreditsEntry(generator.run(), "KeeVee_Games - HUE", "https://musnik.itch.io/hue-shader"),
      factoryCreditsEntry(generator.run(), "kishimisu - ART", "https://shadertoy.com/view/mtyGWy"),
      factoryCreditsEntry(generator.run(), "murieron - CLOUDS 2D", "https://shadertoy.com/view/WdXBW4"),
      factoryCreditsEntry(generator.run(), "nayk - WHIRLPOOL", "https://shadertoy.com/view/lcscDj"),
      factoryCreditsEntry(generator.run(), "Peace - COLORS EMBODY", "https://shadertoy.com/view/lffyWf"),
      factoryCreditsEntry(generator.run(), "ProfessorPixels - CUBULAR", "https://shadertoy.com/view/M3tGWr"),
      factoryCreditsEntry(generator.run(), "supah - DISCOTEQ 2", "https://shadertoy.com/view/DtXfDr"),
      factoryCreditsEntry(generator.run(), "tomorrowevening - 70S MELT", "https://shadertoy.com/view/XsX3zl"),
      factoryCreditsEntry(generator.run(), "trinketMage - BASE WARP FBM", "https://shadertoy.com/view/tdG3Rd"),
      factoryCreditsEntry(generator.run(), "whisky_shusuky - OCTAGRAMS", "https://shadertoy.com/view/tlVGDt"),
      factoryCreditsEntry(generator.run(), "xygthop3 - CRT", "https://github.com/xygthop3/Free-Shaders"),
      factoryCreditsEntry(generator.run(), "xygthop3 - LED", "https://github.com/xygthop3/Free-Shaders"),
      factoryCreditsEntry(generator.run(), "xygthop3 - MOSAIC", "https://github.com/xygthop3/Free-Shaders"),
      factoryCreditsEntry(generator.run(), "xygthop3 - POSTERIZATION", "https://github.com/xygthop3/Free-Shaders"),
      factoryCreditsEntry(generator.run(), "xygthop3 - REVERT", "https://github.com/xygthop3/Free-Shaders"),
      /*
      factoryCreditsEntry(generator.run(), "Alkapivo - Dissolve", "https://github.com/Alkapivo/core-gml"),
      factoryCreditsEntry(generator.run(), "Alkapivo - Gaussian Blur", "https://github.com/Alkapivo/core-gml"),
      factoryCreditsEntry(generator.run(), "anatole_duprat - FLAME", "https://shadertoy.com/view/MdX3zr"),
      factoryCreditsEntry(generator.run(), "butadiene - MONSTER", "https://shadertoy.com/view/WtKSzt"),
      factoryCreditsEntry(generator.run(), "edankwan - CINESHADER LAVA", "https://shadertoy.com/view/3sySRK"),
      factoryCreditsEntry(generator.run(), "lise - DIVE TO CLOUD", "https://shadertoy.com/view/ll3SWl"),
      factoryCreditsEntry(generator.run(), "magician0809 - UI NOISE HALO", "https://shadertoy.com/view/3tBGRm"),
      factoryCreditsEntry(generator.run(), "Peace - GRID SPACE", "https://shadertoy.com/view/lffyWf"),
      factoryCreditsEntry(generator.run(), "Peace - LIGHTING WITH GLOW", "https://shadertoy.com/view/MclyWl"),
      factoryCreditsEntry(generator.run(), "svtetering - NOG BETERE 2", "https://shadertoy.com/view/NtlSzX"),
      factoryCreditsEntry(generator.run(), "xygthop3 - ABBERATION", "https://github.com/xygthop3/Free-Shaders"),
      factoryCreditsEntry(generator.run(), "xygthop3 - EMBOSS", "https://github.com/xygthop3/Free-Shaders"),
      factoryCreditsEntry(generator.run(), "xygthop3 - MAGNIFY", "https://github.com/xygthop3/Free-Shaders"),
      factoryCreditsEntry(generator.run(), "xygthop3 - RIPPLE", "https://github.com/xygthop3/Free-Shaders"),
      factoryCreditsEntry(generator.run(), "xygthop3 - SCANLINES", "https://github.com/xygthop3/Free-Shaders"),
      factoryCreditsEntry(generator.run(), "xygthop3 - SHOCK_WAVE", "https://github.com/xygthop3/Free-Shaders"),
      factoryCreditsEntry(generator.run(), "xygthop3 - SKETCH", "https://github.com/xygthop3/Free-Shaders"),
      factoryCreditsEntry(generator.run(), "xygthop3 - THERMAL", "https://github.com/xygthop3/Free-Shaders"),
      factoryCreditsEntry(generator.run(), "xygthop3 - WAVE", "https://github.com/xygthop3/Free-Shaders"),
      */
      {
        name: "credits_menu-button-entry_back",
        template: VisuComponents.get("menu-button-entry"),
        layout: VisuLayouts.get("menu-button-entry"),
        config: {
          layout: { type: UILayoutType.VERTICAL },
          label: { 
            text: Language.get("visu.menu.back"),
            callback: new BindIntent(function() {
              Beans.get(BeanVisuController).menu.send(Callable.run(this.callbackData))
              Beans.get(BeanVisuController).sfxService.play("menu-select-entry")
            }),
            callbackData: config.back,
            onMouseReleasedLeft: function() {
              this.callback()
            },
            colorHoverOut: VisuTheme.color.deny,
          },
        }
      }
    ])
  })

  return event
}