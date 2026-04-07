///@package io.alkapivo.visu.editor.api.template

///@param {Struct} json
///@return {Struct}
function template_subtitle(json = null) {
  var langCodes = LanguageType.keys()
  var store = new Map(String, Struct, {
    "current_langCode": {
      type: String,
      value: LanguageType.en_EN,
      passthrough: UIUtil.passthrough.getArrayValue(),
      data: langCodes,
    },
  })

  var components = new Array(Struct, [
    VESpinSelectComponent("subtitle_current_langCode", {
      store: { key: "current_langCode" },
      layout: { margin: { top: 2, bottom: 2 } },
      label: { text: "Language" },
      preview: {
        store: {
          callback: function(value, data) {
            //Struct.set(data, "value", value)
            Struct.set(Struct.get(data, "label"), "text", value)
            LanguageType.keys().forEach(function(langCode, idx, acc) {
              var hiddenKey = $"hidden_{langCode}"
              var storeItem = acc.store.get(hiddenKey)
              if (storeItem != null) {
                storeItem.set(langCode != acc.langCode)
              }
            }, {
              store: this.getStore(),
              langCode: value,
            })
          },
        },
      },
    }),
  ])

  langCodes.forEach(function(langCode, idx, acc) {
    var isDefault = langCode == LanguageType.en_EN
    var linesKey = $"lines_{langCode}"

    var item = Struct.get(acc.json, langCode)
    acc.store.set(linesKey, {
      type: String,
      value: Struct.getIfType(item, "lines", Array, new Array(String)).join("\n"),
    })

    var hiddenKey = $"hidden_{langCode}"
    acc.store.set(hiddenKey, {
      type: Boolean,
      value: LanguageType.en_EN != langCode,
    })

    var enableKey = $"enable_{langCode}"
    acc.store.set(enableKey, {
      type: Boolean,
      value: isDefault ? true : Struct.getIfType(item, "enable", Boolean, true),
    })

    var titleKey = $"title_{langCode}"
    acc.components.add(VETitleComponent(titleKey, {
      enable: { key: enableKey },
      hidden: { key: hiddenKey },
      checkbox: {
        store: { key: enableKey },
        enable: { value: !isDefault },
        spriteOn: { name: !isDefault ? "visu_texture_checkbox_on" : "texture_empty" },
        spriteOff: { name: !isDefault ? "visu_texture_checkbox_off" : "texture_empty" },
      },
      label: { text: $"[{langCode}] Text" },
      input: { },
      background: VETheme.color.accentShadow,
    }))

    var textFieldKey = $"textField_{langCode}"
    acc.components.add(VETextAreaInputComponent(textFieldKey, {
      store: { key: linesKey },
      hidden: { key: hiddenKey },
      enable: { key: enableKey },
      value: {
        v_grow: true,
        w_min: 570,
      }
    }))
  }, {
    json: Struct.get(Struct.get(json, "data"), "container"),
    store: store,
    components: components,
  })

  components.add({
    name: "subtitle_lines_text-area-line-h",
    template: VEComponents.get("line-h"),
    layout: VELayouts.get("line-h"),
    config: {
      layout: {
        type: UILayoutType.VERTICAL,
        margin: { top: 0, bottom: 0 },
        height: function() { return 0 },
      },
      image: { backgroundAlpha: 0.0 },
    },
  })
  
  var template = {
    name: Assert.isType(Struct.get(json, "name"), String, 
      "template_subtitle::name must be type of String"),
    store: store,
    components: components,
  }

  return template
}
