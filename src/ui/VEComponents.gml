//@package io.alkapivo.visu.editor

///@static
///@type {Map<String, Callable>}
global.__VEComponents = new Map(String, Callable, {
  
  ///@param {String} name
  ///@param {UILayout} layout
  ///@param {?Struct} [config]
  ///@return {Array<UIItem>}
  "button": function(name, layout, config = null) {
    return new Array(UIItem, [
      UIButton(
        $"{name}_button", 
        Struct.appendRecursive(
          Struct.appendRecursive(
            { 
              layout: layout.nodes.button,
              updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
            }, 
            VEStyles.get("category-button"),
            false
          ),
          config,
          false
        )
      ),
    ])
  },

  ///@param {String} name
  ///@param {UILayout} layout
  ///@param {?Struct} [config]
  ///@return {Array<UIItem>}
  "category-button": function(name, layout, config = null) {
    return new Array(UIItem, [
      UIButton(
        $"{name}_category-button", 
        Struct.appendRecursive(
          Struct.appendRecursive(
            { 
              layout: layout,
              updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyCollectionLayout")),
            }, 
            VEStyles.get("category-button"),
            false
          ),
          config,
          false
        )
      ),
    ])
  },

  ///@param {String} name
  ///@param {UILayout} layout
  ///@param {?Struct} [config]
  ///@return {Array<UIItem>}
  "channel-entry": function(name, layout, config = null) {
    return new Array(UIItem, [
      UIText(
        $"{name}_channel-entry_label",
        Struct.appendRecursive(
          Struct.appendRecursive(
            { 
              layout: layout.nodes.label,
              updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyCollectionLayout")),
            }, 
            VEStyles.get("channel-entry").label,
            false
          ),
          Struct.get(config, "label"),
          false
        )
      ),
      UIButton(
        $"{name}_channel-entry_remove", 
        Struct.appendRecursive(
          Struct.appendRecursive(
            { 
              layout: layout.nodes.remove,
              updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyCollectionLayout")),
            }, 
            VEStyles.get("channel-entry").remove,
            false
          ),
          Struct.get(config, "button"),
          false
        )
      ),
    ])
  },

  ///@param {String} name
  ///@param {UILayout} layout
  ///@param {?Struct} [config]
  ///@return {Array<UIItem>}
  "brush-entry": function(name, layout, config = null) {
    return new Array(UIItem, [
      UIImage(
        $"{name}_brush-entry_image",
        Struct.appendRecursive(
          Struct.appendRecursive(
            { 
              layout: layout.nodes.image,
              _updateArea: new BindIntent(Callable.run(UIUtil.updateAreaTemplates.get("applyCollectionLayout"))),
              updateArea: function() {
                this._updateArea()
              }
            }, 
            VEStyles.get("brush-entry").image,
            false
          ),
          Struct.get(config, "image"),
          false
        )
      ),
      UIText(
        $"{name}_brush-entry_label",
        Struct.appendRecursive(
          Struct.appendRecursive(
            { 
              layout: layout.nodes.label,
              updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyCollectionLayout")),
            }, 
            VEStyles.get("brush-entry").label,
            false
          ),
          Struct.get(config, "label"),
          false
        )
      ),
      UIButton(
        $"{name}_brush-entry_up", 
        Struct.appendRecursive(
          Struct.appendRecursive(
            { 
              layout: layout.nodes.up,
              updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyCollectionLayout")),
            }, 
            VEStyles.get("brush-entry").up,
            false
          ),
          Struct.get(config, "up"),
          false
        )
      ),
      UIButton(
        $"{name}_brush-entry_down", 
        Struct.appendRecursive(
          Struct.appendRecursive(
            { 
              layout: layout.nodes.down,
              updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyCollectionLayout")),
            }, 
            VEStyles.get("brush-entry").down,
            false
          ),
          Struct.get(config, "down"),
          false
        )
      ),
      UIButton(
        $"{name}_brush-entry_remove", 
        Struct.appendRecursive(
          Struct.appendRecursive(
            { 
              layout: layout.nodes.remove,
              updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyCollectionLayout")),
            }, 
            VEStyles.get("brush-entry").remove,
            false
          ),
          Struct.get(config, "button"),
          false
        )
      ),
    ])
  },

  ///@param {String} name
  ///@param {UILayout} layout
  ///@param {?Struct} [config]
  ///@return {Array<UIItem>}
  "template-entry": function(name, layout, config = null) {
    return new Array(UIItem, [
      UIText(
        $"{name}_brush-entry_label",
        Struct.appendRecursive(
          Struct.appendRecursive(
            { 
              layout: layout.nodes.label,
              updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyCollectionLayout")),
            }, 
            VEStyles.get("brush-entry").label,
            false
          ),
          Struct.get(config, "label"),
          false
        )
      ),
      UIButton(
        $"{name}_brush-entry_remove", 
        Struct.appendRecursive(
          Struct.appendRecursive(
            { 
              layout: layout.nodes.remove,
              updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyCollectionLayout")),
            }, 
            VEStyles.get("brush-entry").remove,
            false
          ),
          Struct.get(config, "button"),
          false
        )
      ),
    ])
  },

  ///@param {String} name
  ///@param {UILayout} layout
  ///@param {?Struct} [config]
  ///@return {Array<UIItem>}
  "property": function(name, layout, config = null) {
    var style = VEStyles.get("property")
    return new Array(UIItem, [
      UICheckbox(
        $"{name}_checkbox", 
        Struct.appendRecursive(
          Struct.appendRecursive(
            { 
              layout: layout.nodes.checkbox,
              updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
            }, 
            Struct.get(style, "checkbox"),
            false
          ),
          Struct.get(config, "checkbox"),
          false
        )
      ),
      UIText(
        $"{name}_text", 
        Struct.appendRecursive(
          Struct.appendRecursive(
            { 
              layout: layout.nodes.label,
              updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
            },
            Struct.get(style, "label"),
            false
          ),
          Struct.get(config, "label"),
          false
        )
      ),
      UICheckbox(
        $"{name}_input", 
        Struct.appendRecursive(
          Struct.appendRecursive(
            { 
              layout: layout.nodes.input,
              updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
            }, 
            Struct.get(style, "input"),
            false
          ),
          Struct.get(config, "input"),
          false
        )
      ),
    ])
  },

  ///@param {String} name
  ///@param {UILayout} layout
  ///@param {?Struct} [config]
  ///@return {Array<UIItem>}
  "text-field": function(name, layout, config = null) {
    return new Array(UIItem, [
      UIText(
        $"label_{name}", 
        Struct.appendRecursive(
          Struct.appendRecursive(
            { 
              layout: layout.nodes.label,
              updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
            },
            VEStyles.get("text-field_label"),
            false
          ),
          Struct.get(config, "label"),
          false
        )
      ),
      UITextField(
        $"field_{name}", 
        Struct.appendRecursive(
          Struct.appendRecursive(
            { 
              layout: layout.nodes.field,
              updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayoutTextField")),
            },
            VEStyles.get("text-field"),
            false
          ),
          Struct.get(config, "field"),
          false
        )
      ),
    ])
  },

  ///@param {String} name
  ///@param {UILayout} layout
  ///@param {?Struct} [config]
  ///@return {Array<UIItem>}
  "text-area": function(name, layout, config = null) {
    return new Array(UIItem, [
      UITextField(
        $"field_{name}", 
        Struct.appendRecursive(
          Struct.appendRecursive(
            { 
              layout: layout.nodes.field,
              updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayoutTextField")),
            },
            VEStyles.get("text-area"),
            false
          ),
          Struct.get(config, "field"),
          false
        )
      ),
    ])
  },

  ///@param {String} name
  ///@param {UILayout} layout
  ///@param {?Struct} [config]
  ///@return {Array<UIItem>}
  "text-field-button": function(name, layout, config = null) {
    return new Array(UIItem, [
      UIText(
        $"label_{name}", 
        Struct.appendRecursive(
          Struct.appendRecursive(
            { 
              layout: layout.nodes.label,
              updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
            },
            VEStyles.get("text-field-button").label,
            false
          ),
          Struct.get(config, "label"),
          false
        )
      ),
      UITextField(
        $"field_{name}", 
        Struct.appendRecursive(
          Struct.appendRecursive(
            { 
              layout: layout.nodes.field,
              updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayoutTextField")),
            },
            VEStyles.get("text-field-button").field,
            false
          ),
          Struct.get(config, "field"),
          false
        )
      ),
      UIButton(
        $"button_{name}", 
        Struct.appendRecursive(
          Struct.appendRecursive(
            { 
              layout: layout.nodes.button,
              updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
            }, 
            VEStyles.get("text-field-button").button,
            false
          ),
          Struct.get(config, "button"),
          false
        )
      ),
    ])
  },

  ///@param {String} name
  ///@param {UILayout} layout
  ///@param {?Struct} [config]
  ///@return {Array<UIItem>}
  "texture-field": function(name, layout, config = null) {
    ///@todo move to Lambda util
    static addItem = function(item, index, items) {
      items.add(item)
    }

    ///@param {String} name
    ///@param {UILayout} layout
    ///@param {?Struct} [config]
    ///@return {Array<UIItem>}
    static factoryTitle = function(name, layout, config) {
      return new UIComponent({
        name: name,
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: config,
      }).toUIItems(layout)
    }

    ///@param {String} name
    ///@param {UILayout} layout
    ///@param {?Struct} [config]
    ///@return {Array<UIItem>}
    static factoryTextField = function(name, layout, config) {
      return new UIComponent({
        name: name,
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: config,
      }).toUIItems(layout)
    }

    ///@param {String} name
    ///@param {UILayout} layout
    ///@param {?Struct} [config]
    ///@return {Array<UIItem>}
    static factoryNumericSliderField = function(name, layout, config) {
      return new UIComponent({
        name: name,
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: config,
      }).toUIItems(layout)
    }

    ///@param {String} name
    ///@param {UILayout} layout
    ///@param {?Struct} [config]
    ///@return {Array<UIItem>}
    static factoryImage = function(name, layout, config) {
      return UIImage(
        name, 
        Struct.appendRecursive(
          {
            layout: layout,
            updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
          },
          config,
          false
        )
      )
    }

    var items = new Array(UIItem)

    factoryTitle(
      $"{name}_title", 
      layout.nodes.title, 
      Struct.get(config, "title")
    ).forEach(addItem, items)

    factoryTextField(
      $"{name}_texture",
      layout.nodes.texture, 
      Struct.appendRecursive(
        { 
          field: { 
            store: { 
              callback: function(value, data) {
                if (!Core.isType(value, Sprite)) {
                  return
                }
                data.textField.setText(value.texture.name)
              },
              set: function(value) {
                var item = this.get()
                if (!Optional.is(item) || !TextureUtil.exists(value)) {
                  return
                }
                item.set(SpriteUtil.parse({ name: value }))
              },
            }
          }
        }, 
        Struct.get(config, "texture"),
        false
      )
    ).forEach(addItem, items)

    factoryTextField(
      $"{name}_frame",
      layout.nodes.frame, 
      Struct.appendRecursive(
        { 
          field: { 
            store: { 
              callback: function(value, data) {
                if (!Core.isType(value, Sprite)) {
                  return
                }
                data.textField.setText(value.getFrame())
              },
              set: function(value) {
                var item = this.get()
                if (!Optional.is(item)) {
                  return
                }

                var sprite = item.get()
                if (!Core.isType(sprite, Sprite)) {
                  return
                }
                
                sprite.setFrame(NumberUtil.parse(value))
                item.set(sprite)
              },
            }
          }
        },
        Struct.get(config, "frame"),
        false
      )
    ).forEach(addItem, items)

    factoryNumericSliderField(
      $"{name}_alpha",
      layout.nodes.alpha, 
      Struct.appendRecursive(
        { 
          field: { 
            store: { 
              callback: function(value, data) {
                if (!Core.isType(value, Sprite)) {
                  return
                }
                data.textField.setText(value.getAlpha())
              },
              set: function(value) {
                var item = this.get()
                if (!Optional.is(item)) {
                  return
                }

                var sprite = item.get()
                if (!Core.isType(sprite, Sprite)) {
                  return
                }
                sprite.setAlpha(NumberUtil.parse(value))
                item.set(sprite)
              },
            }
          },
          slider: { 
            minValue: 0.0,
            maxValue: 1.0,
            store: { 
              callback: function(value, data) {
                if (!Core.isType(value, Sprite)) {
                  return
                }
                data.value = value.getAlpha()
              },
              set: function(value) {
                var item = this.get()
                if (!Optional.is(item)) {
                  return
                }

                var sprite = item.get()
                if (!Core.isType(sprite, Sprite)) {
                  return
                }
                sprite.setAlpha(NumberUtil.parse(value))
                item.set(sprite)
              },
            },
          },
        },
        Struct.get(config, "alpha"),
        false
      )
    ).forEach(addItem, items)

    items.add(
      factoryImage(
        $"{name}_preview", 
        layout.nodes.preview, 
        Struct.appendRecursive(
          { 
            store: { 
              callback: function(value, data) {
                if (!Core.isType(value, Sprite)) {
                  return
                }
                data.image = value
              },
              set: function(value) { },
            }
          },
          Struct.get(config, "preview"),
          false
        )
      )
    )

    return items
  },

    ///@param {String} name
  ///@param {UILayout} layout
  ///@param {?Struct} [config]
  ///@return {Array<UIItem>}
  "texture-field-speed": function(name, layout, config = null) {
    ///@todo move to Lambda util
    static addItem = function(item, index, items) {
      items.add(item)
    }

    ///@param {String} name
    ///@param {UILayout} layout
    ///@param {?Struct} [config]
    ///@return {Array<UIItem>}
    static factoryTitle = function(name, layout, config) {
      return new UIComponent({
        name: name,
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: config,
      }).toUIItems(layout)
    }

    ///@param {String} name
    ///@param {UILayout} layout
    ///@param {?Struct} [config]
    ///@return {Array<UIItem>}
    static factoryTextField = function(name, layout, config) {
      return new UIComponent({
        name: name,
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: config,
      }).toUIItems(layout)
    }

    ///@param {String} name
    ///@param {UILayout} layout
    ///@param {?Struct} [config]
    ///@return {Array<UIItem>}
    static factoryNumericSliderField = function(name, layout, config) {
      return new UIComponent({
        name: name,
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: config,
      }).toUIItems(layout)
    }

    ///@param {String} name
    ///@param {UILayout} layout
    ///@param {?Struct} [config]
    ///@return {Array<UIItem>}
    static factoryImage = function(name, layout, config) {
      return UIImage(
        name, 
        Struct.appendRecursive(
          {
            layout: layout,
            updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
          },
          config,
          false
        )
      )
    }

    var items = new Array(UIItem)

    factoryTitle(
      $"{name}_title", 
      layout.nodes.title, 
      Struct.get(config, "title")
    ).forEach(addItem, items)

    factoryTextField(
      $"{name}_texture",
      layout.nodes.texture, 
      Struct.appendRecursive(
        { 
          field: { 
            store: { 
              callback: function(value, data) {
                if (!Core.isType(value, Sprite)) {
                  return
                }
                data.textField.setText(value.texture.name)
              },
              set: function(value) {
                var item = this.get()
                if (!Optional.is(item) || !TextureUtil.exists(value)) {
                  return
                }
                item.set(SpriteUtil.parse({ name: value }))
              },
            }
          }
        }, 
        Struct.get(config, "texture"),
        false
      )
    ).forEach(addItem, items)

    factoryTextField(
      $"{name}_frame",
      layout.nodes.frame, 
      Struct.appendRecursive(
        { 
          field: { 
            store: { 
              callback: function(value, data) {
                if (!Core.isType(value, Sprite)) {
                  return
                }
                data.textField.setText(value.getFrame())
              },
              set: function(value) {
                var item = this.get()
                if (!Optional.is(item)) {
                  return
                }

                var sprite = item.get()
                if (!Core.isType(sprite, Sprite)) {
                  return
                }
                
                sprite.setFrame(NumberUtil.parse(value))
                item.set(sprite)
              },
            }
          }
        },
        Struct.get(config, "frame"),
        false
      )
    ).forEach(addItem, items)

    factoryTextField(
      $"{name}_speed",
      layout.nodes.speed, 
      Struct.appendRecursive(
        { 
          field: { 
            store: { 
              callback: function(value, data) {
                if (!Core.isType(value, Sprite)) {
                  return
                }
                data.textField.setText(value.getSpeed())
              },
              set: function(value) {
                var item = this.get()
                if (!Optional.is(item)) {
                  return
                }

                var sprite = item.get()
                if (!Core.isType(sprite, Sprite)) {
                  return
                }
                
                sprite.setSpeed(abs(NumberUtil.parse(value, sprite.getSpeed())))
                item.set(sprite)
              },
            }
          }
        },
        Struct.get(config, "speed"),
        false
      )
    ).forEach(addItem, items)

    factoryNumericSliderField(
      $"{name}_alpha",
      layout.nodes.alpha, 
      Struct.appendRecursive(
        { 
          field: { 
            store: { 
              callback: function(value, data) {
                if (!Core.isType(value, Sprite)) {
                  return
                }
                data.textField.setText(value.getAlpha())
              },
              set: function(value) {
                var item = this.get()
                if (!Optional.is(item)) {
                  return
                }

                var sprite = item.get()
                if (!Core.isType(sprite, Sprite)) {
                  return
                }
                sprite.setAlpha(NumberUtil.parse(value))
                item.set(sprite)
              },
            }
          },
          slider: { 
            minValue: 0.0,
            maxValue: 1.0,
            store: { 
              callback: function(value, data) {
                if (!Core.isType(value, Sprite)) {
                  return
                }
                data.value = value.getAlpha()
              },
              set: function(value) {
                var item = this.get()
                if (!Optional.is(item)) {
                  return
                }

                var sprite = item.get()
                if (!Core.isType(sprite, Sprite)) {
                  return
                }
                sprite.setAlpha(NumberUtil.parse(value))
                item.set(sprite)
              },
            },
          },
        },
        Struct.get(config, "alpha"),
        false
      )
    ).forEach(addItem, items)

    items.add(
      factoryImage(
        $"{name}_preview", 
        layout.nodes.preview, 
        Struct.appendRecursive(
          { 
            store: { 
              callback: function(value, data) {
                if (!Core.isType(value, Sprite)) {
                  return
                }
                data.image = value
              },
              set: function(value) { },
            }
          },
          Struct.get(config, "preview"),
          false
        )
      )
    )

    return items
  },

  ///@param {String} name
  ///@param {UILayout} layout
  ///@param {?Struct} [config]
  ///@return {Array<UIItem>}
  "numeric-slider-field": function(name, layout, config = null) {
    return new Array(UIItem, [
      UIText(
        $"label_{name}", 
        Struct.appendRecursive(
          Struct.appendRecursive(
            { 
              layout: layout.nodes.label,
              updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
            }, 
            VEStyles.get("text-field_label"),
            false
          ),
          Struct.get(config, "label"),
          false
        )
      ),
      UITextField(
        $"field_{name}",
        Struct.appendRecursive(
          Struct.appendRecursive(
            { 
              layout: layout.nodes.field,
              updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayoutTextField")),
            },
            VEStyles.get("text-field"),
            false
          ),
          Struct.get(config, "field"),
          false
        )
      ),
      UISliderHorizontal(
        $"slider_{name}",
        Struct.appendRecursive(
          Struct.appendRecursive(
            { 
              layout: layout.nodes.slider,
              updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
            },
            VEStyles.get("slider-horizontal"),
            false
          ),
          Struct.get(config, "slider"),
          false
        )
      ),
    ])
  },

  ///@param {String} name
  ///@param {UILayout} layout
  ///@param {?Struct} [config]
  ///@return {Array<UIItem>}
  "color-picker": function(name, layout, config = null) {
    ///@todo move to Lambda util
    static addItem = function(item, index, items) {
      items.add(item)
    }

    static factoryTitle = function(name, layout, config) {
      return new UIComponent({
        name: name,
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: Struct.appendRecursive(
          config,
          {
            input: {
              store: {
                callback: function(value, data) { 
                  data.backgroundColor = value.toGMColor()
                },
                set: function(value) { return },
              },
            }
          },
          false
        ),
      }).toUIItems(layout)
    }

    static factoryColor = function(name, layout, config) {
      static factoryStore = {
        callbackField: function() {
          return function(value, data) { 
            var key = Struct.get(data, "colorChannel")
            if (!ColorUtil.isColorProperty(key)) {
              return 
            }
            data.textField.setText(clamp(round(Struct.get(value, key) * 255), 0.0, 255.0))
          }
        },
        callbackSlider: function() {
          return function(value, data) {
            var key = Struct.get(data, "colorChannel")
            if (!ColorUtil.isColorProperty(key)) {
              return 
            }
            data.value = clamp(round(Struct.get(value, key) * 255), 0.0, 255.0)
          }
        },
        set: function() {
          return function(value) {
            var item = this.get()
            var key = Struct.get(this.context, "colorChannel")
            if (item == null || !ColorUtil.isColorProperty(key)) {
              return 
            }

            var color = item.get()
            item.set(Struct.set(color, key, clamp(NumberUtil
              .parse(value / 255, Struct.get(color, key)), 0.0, 1.0)))
          }
        },
      }
      
      return new UIComponent({
        name: name,
        template: VEComponents.get("numeric-slider-field"),
        layout: VELayouts.get("numeric-slider-field"),
        config: Struct.appendRecursive(
          config, 
          {
            field: {
              store: {
                callback: factoryStore.callbackField(),
                set: factoryStore.set(),
              }
            },
            slider: {
              minValue: 0,
              maxValue: 255,
              store: {
                callback: factoryStore.callbackSlider(),
                set: factoryStore.set()
              },
            }
          },
          false
        ),
      }).toUIItems(layout)
    }

    static factoryHex = function(name, layout, config) {
      return new UIComponent({
        name: name,
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: Struct.appendRecursive(
          config, 
          {
            field: {
              store: {
                callback: function(value, data) { 
                  data.textField.setText(value.toHex())
                },
                set: function(value) {
                  var item = this.get()
                  if (item == null) {
                    return 
                  }
                  item.set(ColorUtil.fromHex(value, item.get().toHex()))
                },
              },
            },
          },
          false
        ),
      }).toUIItems(layout)
    }

    var items = new Array(UIItem)

    factoryTitle(
      $"{name}_title",
      layout.nodes.title,
      Struct.get(config, "title")
    ).forEach(addItem, items)

    factoryColor(
      $"{name}_red",
      layout.nodes.red,
      Struct.appendRecursive(
        Struct.get(config, "red"), 
        {
          field: { colorChannel: "red" }, 
          slider: { colorChannel: "red" },
        },
        false
      )
    ).forEach(addItem, items)

    factoryColor(
      $"{name}_green",
      layout.nodes.green,
      Struct.appendRecursive(
        Struct.get(config, "green"),
        {
          field: { colorChannel: "green" }, 
          slider: { colorChannel: "green" },
        },
        false
      )
    ).forEach(addItem, items)

    factoryColor(
      $"{name}_blue",
      layout.nodes.blue,
      Struct.appendRecursive(
        Struct.get(config, "blue"),
        {
          field: { colorChannel: "blue" }, 
          slider: { colorChannel: "blue" },
        },
        false
      )
    ).forEach(addItem, items)

    if (Struct.contains(config, "alpha")) {
      factoryColor(
        $"{name}_alpha",
        layout.nodes.alpha,
        Struct.appendRecursive(
          Struct.get(config, "alpha"),
          {
            field: { colorChannel: "alpha" }, 
            slider: { colorChannel: "alpha" },
          },
          false
        )
      ).forEach(addItem, items)
    }

    factoryHex(
      $"{name}_hex",
      layout.nodes.hex,
      Struct.get(config, "hex")
    ).forEach(addItem, items)

    return items
  },
  
  ///@param {String} name
  ///@param {UILayout} layout
  ///@param {?Struct} [config]
  ///@return {Array<UIItem>}
  "spin-select": function(name, layout, config = null) {
    static factoryButton = function(name, layout, config) {
      return UIButton(
        name, 
        Struct.appendRecursive(
          {
            layout: layout,
            updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
            callback: function() {
              ///@todo move to Lambda util
              static findEqual = function(source, iterator, target) {
                return source == target
              }

              var increment = Struct.get(this, "increment")
              if (!Optional.is(this.store) || !Core.isType(increment, Number)) {
                return
              }

              var item = this.store.get()
              if (!Optional.is(item)) {
                return
              }

              var data = item.data
              if (!Core.isType(data, Collection)) {
                return
              }

              var index = data.findIndex(findEqual, item.get())
              index = (index == null ? 0 : index) + increment
              if (index < 0) {
                index = data.size() - 1
              } else if (index > data.size() - 1) {
                index = 0
              }
              item.set(data.get(index))
            },
          }, 
          config, 
          false
        )
      )
    }

    ///@param {String} name
    ///@param {UILayout} layout
    ///@param {?Struct} [config]
    ///@return {Array<UIItem>}
    static factoryPreview = function(name, layout, config) {
      return UIImage(
        name, 
        Struct.appendRecursive(
          {
            layout: layout,
            updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
          }, 
          config, 
          false
        )
      )
    }
    
    return new Array(UIItem, [
      UIText(
        $"{name}_label", 
        Struct.appendRecursive(
          Struct.appendRecursive(
            { 
              layout: layout.nodes.label,
              updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
            },
            VEStyles.get("text-field_label"),
            false
          ),
          Struct.get(config, "label"),
          false
        )
      ),
      factoryButton(
        $"{name}_previous",
        layout.nodes.previous,
        Struct.appendRecursive(
          Struct.appendRecursive(
            { increment: -1 }, 
            Struct.get(config, "previous"), 
            false
          ), 
          Struct.get(VEStyles.get("spin-select"), "previous"),
          false
        )
      ),
      factoryPreview(
        $"{name}_preview",
        layout.nodes.preview,
        Struct.get(config, "preview")
      ),
      factoryButton(
        $"{name}_next",
        layout.nodes.next,
        Struct.appendRecursive(
          Struct.appendRecursive(
            { increment: 1 },
            Struct.get(config, "next"),
            false
          ),
          Struct.get(VEStyles.get("spin-select"), "next"),
          false
        )
      ),
    ])
  },

  ///@param {String} name
  ///@param {UILayout} layout
  ///@param {?Struct} [config]
  ///@return {Array<UIItem>}
  "transform-numeric-property": function(name, layout, config = null) {
    ///@todo move to Lambda util
    static addItem = function(item, index, items) {
      items.add(item)
    }

    static factoryTitle = function(name, layout, config) {
      return new UIComponent({
        name: name,
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: config,
      }).toUIItems(layout)
    }

    static factoryTextField = function(name, layout, config) {
      return new UIComponent({
        name: name,
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: Struct.appendRecursive(
          config, 
          {
            field: {
              store: {
                callback: function(value, data) { 
                  var item = data.store.get()
                  if (item == null) {
                    return 
                  }

                  var key = Struct.get(data, "transformNumericProperty")
                  var transformer = item.get()
                  if (!Core.isType(transformer, NumberTransformer) 
                    || !Struct.contains(transformer, key)) {
                    return 
                  }
                  data.textField.setText(Struct.get(transformer, key))
                },
                set: function(value) {
                  var item = this.get()
                  if (item == null) {
                    return 
                  }

                  var parsedValue = NumberUtil.parse(value, null)
                  if (parsedValue == null) {
                    return
                  }

                  var key = Struct.get(this.context, "transformNumericProperty")
                  var transformer = item.get()
                  if (!Core.isType(transformer, NumberTransformer) 
                    || !Struct.contains(transformer, key)) {
                    return 
                  }
                  item.set(Struct.set(transformer, key, parsedValue))
                },
              },
            },
          },
          false
        )
      }).toUIItems(layout)
    }

    var items = new Array(UIItem)

    factoryTitle(
      $"{name}_title",
      layout.nodes.title,
      Struct.get(config, "title")
    ).forEach(addItem, items)

    factoryTextField(
      $"{name}_target",
      layout.nodes.target,
      Struct.appendRecursive(
        Struct.get(config, "target"),
        { field: { transformNumericProperty: "target" } },
        false
      )
    ).forEach(addItem, items)

    factoryTextField(
      $"{name}_factor", 
      layout.nodes.factor, 
      Struct.appendRecursive(
        Struct.get(config, "factor"), 
        { field: { transformNumericProperty: "factor" } },
        false
      )
    ).forEach(addItem, items)

    factoryTextField(
      $"{name}_increment",
      layout.nodes.increment, 
      Struct.appendRecursive(
        Struct.get(config, "increment"), 
        { field: { transformNumericProperty: "increase" } },
        false
      )
    ).forEach(addItem, items)

    return items
  },

  ///@param {String} name
  ///@param {UILayout} layout
  ///@param {?Struct} [config]
  ///@return {Array<UIItem>}
  "transform-numeric-uniform": function(name, layout, config = null) {
    ///@todo move to Lambda util
    static addItem = function(item, index, items) {
      items.add(item)
    }

    static factoryTitle = function(name, layout, config) {
      return new UIComponent({
        name: name,
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: config,
      }).toUIItems(layout)
    }

    static factoryTextField = function(name, layout, config) {
      return new UIComponent({
        name: name,
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: Struct.appendRecursive(
          config, 
          {
            field: {
              store: {
                callback: function(value, data) { 
                  var item = data.store.get()
                  if (item == null) {
                    return 
                  }

                  var key = Struct.get(data, "transformNumericProperty")
                  var transformer = item.get()
                  if (!Core.isType(transformer, NumberTransformer) 
                    || !Struct.contains(transformer, key)) {
                    return 
                  }
                  data.textField.setText(Struct.get(transformer, key))
                },
                set: function(value) {
                  var item = this.get()
                  if (item == null) {
                    return 
                  }

                  var parsedValue = NumberUtil.parse(value, null)
                  if (parsedValue == null) {
                    return
                  }

                  var key = Struct.get(this.context, "transformNumericProperty")
                  var transformer = item.get()
                  if (!Core.isType(transformer, NumberTransformer) 
                    || !Struct.contains(transformer, key)) {
                    return 
                  }
                  item.set(Struct.set(transformer, key, parsedValue))
                },
              },
            },
          },
          false
        )
      }).toUIItems(layout)
    }

    var items = new Array(UIItem)

    factoryTitle(
      $"{name}_title",
      layout.nodes.title,
      Struct.get(config, "title")
    ).forEach(addItem, items)

    factoryTextField(
      $"{name}_value",
      layout.nodes.value,
      Struct.appendRecursive(
        Struct.get(config, "value"),
        { field: { transformNumericProperty: "value" } },
        false
      )
    ).forEach(addItem, items)

    factoryTextField(
      $"{name}_target",
      layout.nodes.target,
      Struct.appendRecursive(
        Struct.get(config, "target"),
        { field: { transformNumericProperty: "target" } },
        false
      )
    ).forEach(addItem, items)

    factoryTextField(
      $"{name}_factor", 
      layout.nodes.factor, 
      Struct.appendRecursive(
        Struct.get(config, "factor"), 
        { field: { transformNumericProperty: "factor" } },
        false
      )
    ).forEach(addItem, items)

    factoryTextField(
      $"{name}_increment",
      layout.nodes.increment, 
      Struct.appendRecursive(
        Struct.get(config, "increment"), 
        { field: { transformNumericProperty: "increase" } },
        false
      )
    ).forEach(addItem, items)

    return items
  },

  ///@param {String} name
  ///@param {UILayout} layout
  ///@param {?Struct} [config]
  ///@return {Array<UIItem>}
  "uniform-vec2-field": function(name, layout, config = null) {
    return new Array(UIItem, [
      UIText(
        $"label_{name}", 
        Struct.appendRecursive(
          Struct.appendRecursive(
            { 
              layout: layout.nodes.label,
              updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
            },
            VEStyles.get("transform-numeric-uniform").label,
            false
          ),
          Struct.get(config, "label"),
          false
        )
      ),
      UITextField(
        $"field_vec2x_{name}", 
        Struct.appendRecursive(
          Struct.appendRecursive(
            { 
              layout: layout.nodes.vec2x,
              updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayoutTextField")),
              store: {
                callback: function(value, data) { 
                  if (!Core.isType(value, Vector2)) {
                    return 
                  }
                  data.textField.setText(value.x)
                },
                set: function(value) {
                  var item = this.get()
                  if (item == null) {
                    return 
                  }

                  var vec2 = item.get()
                  if (!Core.isType(vec2, Vector2)) {
                    return 
                  }
                  vec2.x = NumberUtil.parse(value, 0)
                  item.set(vec2)
                },
              },
            },
            VEStyles.get("text-field"),
            false
          ),
          Struct.get(config, "vec2x"),
          false
        )
      ),
      UITextField(
        $"field_vec2y_{name}", 
        Struct.appendRecursive(
          Struct.appendRecursive(
            { 
              layout: layout.nodes.vec2y,
              updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayoutTextField")),
              store: {
                callback: function(value, data) { 
                  if (!Core.isType(value, Vector2)) {
                    return 
                  }
                  data.textField.setText(value.y)
                },
                set: function(value) {
                  var item = this.get()
                  if (item == null) {
                    return 
                  }

                  var vec2 = item.get()
                  if (!Core.isType(vec2, Vector2)) {
                    return 
                  }
                  vec2.y = NumberUtil.parse(value, 0)
                  item.set(vec2)
                },
              },
            },
            VEStyles.get("text-field"),
            false
          ),
          Struct.get(config, "vec2y"),
          false
        )
      ),
    ])
  },

    ///@param {String} name
  ///@param {UILayout} layout
  ///@param {?Struct} [config]
  ///@return {Array<UIItem>}
  "vec4-field": function(name, layout, config = null) {
    ///@todo move to Lambda util
    static addItem = function(item, index, items) {
      items.add(item)
    }

    static factoryTitle = function(name, layout, config) {
      return new UIComponent({
        name: name,
        template: VEComponents.get("property"),
        layout: VELayouts.get("property"),
        config: config,
      }).toUIItems(layout)
    }

    static factoryTextField = function(name, layout, config) {
      return new UIComponent({
        name: name,
        template: VEComponents.get("text-field"),
        layout: VELayouts.get("text-field"),
        config: Struct.appendRecursive(
          config, 
          {
            field: {
              store: {
                callback: function(value, data) { 
                  var item = data.store.get()
                  if (item == null) {
                    return 
                  }

                  var key = Struct.get(data, "vec4Property")
                  var vec4 = item.get()
                  if (!Core.isType(vec4, Vector4) || !Struct.contains(vec4, key)) {
                    return 
                  }
                  data.textField.setText(Struct.get(vec4, key))
                },
                set: function(value) {
                  var item = this.get()
                  if (item == null) {
                    return 
                  }

                  var parsedValue = NumberUtil.parse(value, null)
                  if (parsedValue == null) {
                    return
                  }

                  var key = Struct.get(this.context, "vec4Property")
                  var vec4 = item.get()
                  if (!Core.isType(vec4, Vector4) || !Struct.contains(vec4, key)) {
                    return 
                  }
                  item.set(Struct.set(vec4, key, parsedValue))
                },
              },
            },
          },
          false
        )
      }).toUIItems(layout)
    }

    var items = new Array(UIItem)

    factoryTitle(
      $"{name}_title",
      layout.nodes.title,
      Struct.get(config, "title")
    ).forEach(addItem, items)

    factoryTextField(
      $"{name}_x",
      layout.nodes.x,
      Struct.appendRecursive(
        Struct.get(config, "x"),
        { field: { vec4Property: "x" } },
        false
      )
    ).forEach(addItem, items)

    factoryTextField(
      $"{name}_y",
      layout.nodes.y,
      Struct.appendRecursive(
        Struct.get(config, "y"),
        { field: { vec4Property: "y" } },
        false
      )
    ).forEach(addItem, items)

    factoryTextField(
      $"{name}_z",
      layout.nodes.z,
      Struct.appendRecursive(
        Struct.get(config, "z"),
        { field: { vec4Property: "z" } },
        false
      )
    ).forEach(addItem, items)

    factoryTextField(
      $"{name}_a",
      layout.nodes.a,
      Struct.appendRecursive(
        Struct.get(config, "a"),
        { field: { vec4Property: "a" } },
        false
      )
    ).forEach(addItem, items)

    return items
  },
})
#macro VEComponents global.__VEComponents
