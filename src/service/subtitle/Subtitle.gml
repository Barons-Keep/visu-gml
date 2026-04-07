///@package io.alkapivo.visu.service.subtitle

///@param {String} _name
///@param {Struct} json
function SubtitleTemplate(_name, _json) constructor {

  ///@type {String}
  name = Assert.isType(_name, String)

  /* migrate to multilang */
  var json = (Struct.get(_json, "lines") != null && Struct.get(_json, LanguageType.en_EN) == null) 
    ? LanguageType.keys().toStruct(
      function(langCode, idx, lines) {
        return {
          lines: langCode == LanguageType.en_EN ? lines : [],
          enable: langCode == LanguageType.en_EN,
        }
      },
      _json.lines,
      function(langCode) {
        return langCode
      }
    )
    : _json

  ///@type {Map<String, Struct>}
  data = new Map(String, Struct, Core.isType(json, Struct)
    ? Struct.map(json, function(item) {
      return {
        lines: new Array(String, Struct.getIfType(item, "lines", GMArray, [])),
        enable: Struct.getIfType(item, "enable", Boolean, true),
      }
    })
    : {})

  ///@return {Struct}
  serialize = function() {
    return data.toStruct(function(item) {
      return {
        lines: Struct.getIfType(item, "lines", Array, new Array(String)).getContainer(),
        enable: Struct.getIfType(item, "enable", Boolean, true),
      }
    })
  }
}


///@param {Struct} json
function Subtitle(json) constructor {

  ///@type {String}
  template = Assert.isType(Struct.get(json, "template"), String,
    "Subtitle::template must be type of String")

  ///@type {Array<String>}
  lines = Assert.isType(Struct.get(json, "lines"), Array,
    "Subtitle::lines must be type of String")

  ///@type {Font}
  font = Core.isType(Struct.get(json, "font"), Font)
    ? json.font
    : Assert.isType(FontUtil.parse({ name: "font_basic" }), Font)

  ///@type {String}
  fontHeight = Optional.is(Struct.get(json, "fontHeight"))
    ? Assert.isType(json.fontHeight, Number)
    : 12

  ///@type {Number}
  charSpeed = Optional.is(Struct.get(json, "charSpeed"))
    ? Assert.isType(json.charSpeed, Number)
    : 1

  ///@type {GMColor}
  color = Optional.is(Struct.get(json, "color"))
    ? Assert.isType(json.color, GMColor)
    : c_white

  ///@type {?GMColor}
  outline = Optional.is(Struct.get(json, "outline"))
    ? Assert.isType(json.outline, GMColor)
    : null

  ///@type {Struct}
  align = Optional.is(Struct.get(json, "align"))
    ? Assert.isType(json.align, Struct)
    : { v: VAlign.TOP, h: HAlign.LEFT }

  ///@type {Rectangle}
  area = Assert.isType(json.area, Rectangle)

  ///@type {?Timer}
  lineDelay = Optional.is(Struct.get(json, "lineDelay"))
    ? Assert.isType(json.lineDelay, Timer)
    : null

  ///@type {?Timer}
  finishDelay = Optional.is(Struct.get(json, "finishDelay"))
    ? Assert.isType(json.finishDelay, Timer)
    : null

  ///@type {NumberTransformer}
  angleTransformer = Optional.is(Struct.get(json, "angleTransformer"))
    ? Assert.isType(json.angleTransformer, NumberTransformer)
    : null

  ///@type {NumberTransformer}
  speedTransformer = Optional.is(Struct.get(json, "speedTransformer"))
    ? Assert.isType(json.speedTransformer, NumberTransformer)
    : null

  ///@type {Number}
  fadeIn = Optional.is(Struct.get(json, "fadeIn"))
    ? Assert.isType(json.fadeIn, Number)
    : 0.0

  ///@type {Number}
  fadeOut = Optional.is(Struct.get(json, "fadeOut"))
    ? Assert.isType(json.fadeOut, Number)
    : 0.0
}
