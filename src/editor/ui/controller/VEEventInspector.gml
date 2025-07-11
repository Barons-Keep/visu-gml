///@package io.alkapivo.visu.editor.ui.controller

///@param {VisuEditorController} _editor
function VEEventInspector(_editor) constructor {

  ///@type {VisuEditorController}
  editor = Assert.isType(_editor, VisuEditorController)

  ///@type {Map<String, Containers>}
  containers = new Map(String, UI)

  ///@type {Store}
  store = new Store({
    "event": {
      type: Optional.of(VEEvent),
      value: null,
    },
  })

  ///@type {Boolean}
  enable = true

  ///@private
  ///@param {UIlayout} parent
  ///@return {UILayout}
  factoryLayout = function(parent) {
    return new UILayout({ 
      name: "event-inspector",
      staticHeight: new BindIntent(function() { 
        return this.nodes.title.height() + this.nodes.title.__margin.top
            + this.nodes.control.height() 
            + this.nodes.view.__margin.top 
            + this.nodes.view.__margin.bottom
      }),
      nodes: {
        "title": {
          name: "event-inspector.title",
          y: function() { return this.context.y() + this.__margin.top },
          height: function() { return 16 },
          margin: { left: 1, right: 1, top: 0 },
        },
        "view": {
          name: "event-inspector.view",
          margin: { top: 1, bottom: 0, left: 10, right: 1, },
          height: function() { return this.context.height() - this.context.staticHeight()
            - this.__margin.top - this.__margin.bottom },
          y: function() { return this.__margin.top + this.context.nodes.title.bottom() },
        },
        "control": {
          name: "event-inspector.control",
          height: function() { return 40 },
          margin: { left: 0, right: 1, },
          y: function() { return this.context.nodes.view.bottom() + this.context.nodes.view.__margin.bottom },
        }
      }
    }, parent)
  }

  ///@private
  ///@param {UIlayout} parent
  ///@return {Task}
  factoryOpenTask = function(parent) {
    var eventInspector = this
    var layout = this.factoryLayout(parent)
    this.layout = layout
    var containerIntents = new Map(String, Struct, {
      "ve-event-inspector-title": {
        name: "ve-event-inspector-title",
        state: new Map(String, any, {
          "background-alpha": 1.0,
          "background-color": ColorUtil.fromHex(VETheme.color.accentShadow).toGMColor(),
        }),
        updateTimer: new Timer(FRAME_MS * 2, { loop: Infinity, shuffle: true }),
        layout: layout.nodes.title,
        eventInspector: eventInspector,
        updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
        render: Callable.run(UIUtil.renderTemplates.get("renderDefaultNoSurface")),
        items: {
          "label_ve-event-inspector-title": {
            type: UIText,
            text: "Event inspector",
            font: "font_inter_8_bold",
            color: VETheme.color.textShadow,
            align: { v: VAlign.CENTER, h: HAlign.LEFT },
            offset: { x: 4 },
            margin: { top: 1 },
            backgroundColor: VETheme.color.accentDark,
            clipboard: {
              name: "label_ve-event-inspector-title",
              drag: function() {
                Beans.get(BeanVisuController).displayService.setCursor(Cursor.RESIZE_VERTICAL)
              },
              drop: function() {
                Beans.get(BeanVisuController).displayService.setCursor(Cursor.DEFAULT)
              }
            },
            __height: 0.0,
            __update: new BindIntent(Callable.run(UIUtil.updateAreaTemplates.get("applyMargin"))),
            updateCustom: function() {
              this.__update()
              if (Beans.get(BeanVisuEditorIO).mouse.getClipboard() == this.clipboard) {
                this.updateLayout(MouseUtil.getMouseY())
                this.context.eventInspector.containers.forEach(function(container) {
                  if (!Optional.is(container.updateTimer)) {
                    return
                  }
                  
                  container.surfaceTick.skip()
                  container.updateTimer.time = container.updateTimer.duration + random(container.updateTimer.duration / 2.0)
                })
  
                if (!mouse_check_button(mb_left)) {
                  Beans.get(BeanVisuEditorIO).mouse.clearClipboard()
                  Beans.get(BeanVisuController).displayService.setCursor(Cursor.DEFAULT)
                }
              } else {
                var editor = Beans.get(BeanVisuEditorController)
                var accordion = editor.accordion
                var accordionNode = editor.layout.nodes.accordion
                var store = accordion.layout.store
                var height = accordionNode.height()
                var eventInspectorMinHeight = editor.accordion.eventInspector.layout.nodes.title.height()
                  + editor.accordion.eventInspector.layout.nodes.control.height()
                  //+ 16.0 + 32.0 + 28.0
                var templateToolbarMinHeight = Struct.get(editor.accordion.templateToolbar.layout.nodes, "type").height()
                  + Struct.get(editor.accordion.templateToolbar.layout.nodes, "add").height()
                  + Struct.get(editor.accordion.templateToolbar.layout.nodes, "title").height()
                  + Struct.get(editor.accordion.templateToolbar.layout.nodes, "inspector-bar").height()
                  + Struct.get(editor.accordion.templateToolbar.layout.nodes, "control").height()
                  + 16.0

                var current = Struct.get(store, "events-percentage")
                var percentage = clamp(current, eventInspectorMinHeight / height, 1.0 - (templateToolbarMinHeight / height))
                if (percentage == current) {
                  return
                }

                Struct.set(store, "events-percentage", percentage)
                accordion.containers.forEach(accordion.resetUpdateTimer)
                accordion.templateToolbar.containers.forEach(accordion.resetUpdateTimer)
                accordion.eventInspector.containers.forEach(accordion.resetUpdateTimer)

                //var editor = Beans.get(BeanVisuEditorController)
                //var height = editor.layout.nodes.accordion.height()
                //if (this.__height != height) {
                //  this.__height = height
                //  this.updateLayout(this.context.area.getY() + this.area.getY())
                //}
              }
            },
            updateLayout: new BindIntent(function(position) {
              var editor = Beans.get(BeanVisuEditorController)
              var accordion = editor.accordion
              var accordionNode = editor.layout.nodes.accordion
              var store = accordion.layout.store
              var height = accordionNode.height()
              var eventInspectorMinHeight = editor.accordion.eventInspector.layout.nodes.title.height()
                + editor.accordion.eventInspector.layout.nodes.control.height()
                //+ 16.0 + 32.0 + 28.0
              var templateToolbarMinHeight = Struct.get(editor.accordion.templateToolbar.layout.nodes, "bar").height()
                + Struct.get(editor.accordion.templateToolbar.layout.nodes, "type").height()
                + Struct.get(editor.accordion.templateToolbar.layout.nodes, "add").height()
                + Struct.get(editor.accordion.templateToolbar.layout.nodes, "title").height()
                + Struct.get(editor.accordion.templateToolbar.layout.nodes, "inspector-bar").height()
                + Struct.get(editor.accordion.templateToolbar.layout.nodes, "control").height()
                + 16.0

              var pos = ((position - accordionNode.y()) / height)
              var percentage = clamp(1.0 - pos, eventInspectorMinHeight / height, 1.0 - (templateToolbarMinHeight / height))
              var current = Struct.get(store, "events-percentage")
              if (percentage == current) {
                return
              }

              Struct.set(store, "events-percentage", percentage)
              accordion.containers.forEach(accordion.resetUpdateTimer)
              accordion.templateToolbar.containers.forEach(accordion.resetUpdateTimer)
              accordion.eventInspector.containers.forEach(accordion.resetUpdateTimer)
            }),
            onMousePressedLeft: function(event) {
              Beans.get(BeanVisuEditorIO).mouse.setClipboard(this.clipboard)
            },
            onMousePressedRight: function(event) {
              var editor = Beans.get(BeanVisuEditorController)
              var accordion = editor.accordion
              Struct.set(accordion.layout.store, "events-percentage", Struct.get(this, "__expandPercentageHeight") == true ? 0.0 : 1.0)
              Struct.set(this, "__percentage", null)
              Struct.set(this, "__expandPercentageHeight", !(Struct.get(this, "__expandPercentageHeight") == true))
              this.updateCustom()
              accordion.containers.forEach(accordion.resetUpdateTimer)
              accordion.templateToolbar.containers.forEach(accordion.resetUpdateTimer)
              accordion.eventInspector.containers.forEach(accordion.resetUpdateTimer)
            },
            onMouseHoverOver: function(event) {
              if (!mouse_check_button(mb_left)) {
                this.clipboard.drag()
              }
            },
            onMouseHoverOut: function(event) {
              if (!mouse_check_button(mb_left)) {
                this.clipboard.drop()
              }
            },
          }, 
        }
      },
      "ve-event-inspector-properties": {
        name: "ve-event-inspector-properties",
        state: new Map(String, any, {
          "background-alpha": 1.0,
          "background-color": ColorUtil.fromHex(VETheme.color.side).toGMColor(),
          "empty-label": new UILabel({
            text: "Click on\ntimeline\nevent",
            font: "font_inter_10_regular",
            color: VETheme.color.textShadow,
            align: { v: VAlign.CENTER, h: HAlign.CENTER },
          }),
          "inspectorType": VEEventInspector,
          "updateTrackEvent": false,
          "surface-alpha": 1.0,
        }),
        updateTimer: new Timer(FRAME_MS * Core.getProperty("visu.editor.ui.event-inspector.properties.updateTimer", 60), { loop: Infinity, shuffle: true }),
        eventInspector: eventInspector,
        layout: layout.nodes.view,
        instantSubscribe: false,
        _updateTrackEvent: new BindIntent(function() {
          if (!this.state.get("updateTrackEvent")) {
            return
          }

          this.state.set("updateTrackEvent", false)
          var selectedEvent = Beans.get(BeanVisuEditorController).store
            .getValue("selected-event")
          if (!Core.isType(selectedEvent, Struct)) {
            return
          }

          var event = this.state.get("event")
          if (!Core.isType(event, VEEvent)) {
            return
          }

          var template = event.toTemplate()
          selectedEvent.data.timestamp = template.event.timestamp
          selectedEvent.data.data = template.event.data
          selectedEvent.channel = template.channel

          var container = Beans.get(BeanVisuEditorController).uiService
            .find("ve-timeline-events")
          if (!Core.isType(container, UI)) {
            return
          }

          selectedEvent.name = container.updateEvent(
            selectedEvent.channel, 
            selectedEvent.data, 
            selectedEvent.name
          ).name
        }),
        updateArea: Callable.run(UIUtil.updateAreaTemplates.get("scrollableY")),
        renderItem: Callable.run(UIUtil.renderTemplates.get("renderItemDefaultScrollable")),
        renderDefaultScrollable: new BindIntent(Callable.run(UIUtil.renderTemplates.get("renderDefaultScrollableAlpha"))),
        render: function() {
          if (this.executor != null) {
            this.executor.update()
          }

          this._updateTrackEvent()

          var surfaceAlpha = this.state.getIfType("surface-alpha", Number, 1.0)
          //if (this.executor.tasks.size() > 0) {
          //  //this.state.set("surface-alpha", clamp(surfaceAlpha - DeltaTime.apply(0.066), 0.5, 1.0))
          //} else 
          if (surfaceAlpha < 1.0) {
            this.state.set("surface-alpha", clamp(surfaceAlpha + DeltaTime.apply(0.066), 0.0, 1.0))
          }

          this.renderDefaultScrollable()
          if (!Optional.is(this.state.get("selectedEvent"))) {
            this.state.get("empty-label").render(
              this.area.getX() + (this.area.getWidth() / 2),
              this.area.getY() + (this.area.getHeight() / 2),
              this.area.getWidth(),
              this.area.getHeight()
            )
          }

          return this
        },
        executor: null,
        scrollbarY: { align: HAlign.LEFT },
        onMousePressedLeft: Callable.run(UIUtil.mouseEventTemplates.get("onMouseScrollbarY")),
        onMouseWheelUp: Callable.run(UIUtil.mouseEventTemplates.get("scrollableOnMouseWheelUpY")),
        onMouseWheelDown: Callable.run(UIUtil.mouseEventTemplates.get("scrollableOnMouseWheelDownY")),
        onInit: function() {
          var container = this
          this.executor = new TaskExecutor(this, {
            enableLogger: true,
            catchException: false,
          })
          this.collection = new UICollection(this, { layout: container.layout })
          Beans.get(BeanVisuEditorController).store
            .get("selected-event")
            .addSubscriber({ 
              name: container.name,
              overrideSubscriber: true,
              callback: function(selectedEvent, data) { 
                var track = Beans.get(BeanVisuController).trackService.track
                if (!Optional.is(selectedEvent) || !track.channels.contains(Struct.get(selectedEvent, "channel"))) {
                  data.items.forEach(function(item) { item.free() }).clear() ///@todo replace with remove lambda
                  data.collection.components.clear() ///@todo replace with remove lambda
                  data.eventInspector.store.get("event").set(null)
                  data.state
                    .set("selectedEvent", null)
                    .set("event", null)
                    .set("store", null)
                  return
                }

                var trackEvent = selectedEvent.data
                var icon = Struct.get(trackEvent.data, "icon")
                var event = new VEEvent(null, {
                  "event-color": Struct.getIfType(icon, "blend", String, "#FFFFFF"),
                  "event-texture": Struct.getIfType(icon, "name", String, "texture_missing"),
                  "event-timestamp": trackEvent.timestamp,
                  "event-channel": selectedEvent.channel,
                  "type": trackEvent.callableName,
                  "properties": Struct.remove(JSON.clone(trackEvent.data), "icon")
                })

                var oldEvent = data.state.get("event")
                data.eventInspector.store.get("event").set(event)
                data.state
                  .set("selectedEvent", selectedEvent)
                  .set("event", event)
                  .set("store", event.store)

                if (1 == 2 && Struct.get(oldEvent, "type") == trackEvent.callableName) {
                  data.executor.tasks
                    .forEach(TaskUtil.fullfillByName, "sync-ui-store")
                    .forEach(TaskUtil.fullfillByName, "init-ui-components")

                  var task = new Task("sync-ui-store")
                    .setTimeout(60.0)
                    .setState({
                      context: data,
                      event: event,
                      itemKeys: new Queue(String, data.items.keys().getContainer()),
                      storeKeys: new Queue(String, event.store.container.keys().getContainer()),
                      subscribersConfig: {
                        name: data.name,
                        data: data,
                        overrideSubscriber: true,
                        callback: function(value, data) { 
                          data.state.set("updateTrackEvent", true)
                        },
                      },
                      stage: "update-store",
                      stages: {
                        "update-store": function(task) {
                          if (task.state.itemKeys.size() == 0) {
                            task.state.stage = "add-subscriber"
                            return
                          }

                          var key = task.state.itemKeys.pop()
                          var item = task.state.context.items.get(key)
                          if (item != null) {
                            item.updateStore()
                          }
                        },
                        "add-subscriber": function(task) {
                          if (task.state.storeKeys.size() == 0) {
                            task.fullfill()
                            task.state.context.finishUpdateTimer()
                            task.state.context.areaWatchdog.signal()
                            return
                          }

                          var key = task.state.storeKeys.pop()
                          var item = task.state.event.store.get(key)
                          if (item != null) {
                            item.addSubscriber(task.state.subscribersConfig)
                          }
                        },
                      }
                    })
                    .whenUpdate(function() {
                      repeat (SYNC_UI_STORE_STEP) {
                        var stage = Struct.get(this.state.stages, this.state.stage)
                        stage(this)

                        if (this.status == TaskStatus.FULLFILLED) {
                          break
                        }
                      }
                      return this
                    })
                    
                  data.executor.add(task)
                } else {
                  data.items.forEach(function(item) { item.free() }).clear()
                  data.collection.components.clear()

                  data.executor.tasks
                    .forEach(TaskUtil.fullfillByName, "sync-ui-store")
                    .forEach(TaskUtil.fullfillByName, "init-ui-components")

                  var task = new Task("init-ui-components")
                    .setTimeout(60)
                    .setState({
                      stage: "intro-cooldown",//"load-components",
                      flip: FLIP_VALUE,
                      context: data,
                      components: event.components,
                      componentsQueue: new Queue(String, GMArray
                        .map(event.components.container, function(component, index) { 
                          return index 
                        })),
                      componentsConfig: {
                        context: data,
                        layout: new UILayout({
                          area: data.area,
                          width: function() { return this.area.getWidth() },
                        }),
                        textField: null,
                        updateArea: Core.getProperty("visu.editor.ui.event-inspector.inspector-view.init-ui-contanier.updateArea", true),
                      },
                      subscribers: event.store.container,
                      subscribersQueue: new Queue(String, event.store.container
                        .keys()
                        .map(Lambda.passthrough).getContainer()),
                      subscribersConfig: {
                        name: data.name,
                        overrideSubscriber: true,
                        callback: function(value, data) { 
                          data.state.set("updateTrackEvent", true)
                        },
                        data: data,
                      },
                      cooldown: new Timer(FRAME_MS * Core.getProperty("visu.editor.ui.event-inspector.inspector-view.init-ui-contanier.cooldown", 8)),
                      "intro-cooldown": function(task) {
                        if (task.state.cooldown.update().finished) {
                          task.state.stage = "load-components"
                        }
                      },
                      "load-components": function(task) {
                        repeat (EVENT_INSPECTOR_ENTRY_STEP) {
                          if (task.state.flip > 0) {
                            task.state.flip -= 1
                            break
                          } else {
                            task.state.flip = FLIP_VALUE
                          }
                          
                          var index = task.state.componentsQueue.pop()
                          if (!Optional.is(index)) {
                            task.state.stage = "set-subscribers"
                            break
                          }
        
                          var component = new UIComponent(task.state.components.get(index))
                          task.state.context.addUIComponent(component, index, task.state.componentsConfig)
                        }
                      },
                      "set-subscribers": function(task) {
                        var key = task.state.subscribersQueue.pop()
                        if (Optional.is(key)) {
                          var item = task.state.subscribers.get(key)
                          item.addSubscriber(task.state.subscribersConfig)
                          return
                        }

                        task.fullfill()
                        task.state.context.finishUpdateTimer()
                        task.state.context.areaWatchdog.signal()
                      }
                    })
                    .whenUpdate(function() {
                      var stage = Struct.get(this.state, this.state.stage)
                      stage(this)
                      return this
                    })
                    
                  data.executor.add(task)
                }
              },
              data: container,
            })
        },
        onDestroy: function() {
          if (Optional.is(this.executor)) {
            this.executor.tasks.forEach(function(task) { 
              task.fullfill() 
            }).clear()
          }

          var editor = Beans.get(BeanVisuEditorController)
          if (Optional.is(editor)) {
            editor.store
              .get("selected-event")
              .removeSubscriber(this.name)
          }
        },
      },
      "ve-event-inspector-control": {
        name: "ve-event-inspector-control",
        state: new Map(String, any, {
          "background-alpha": 1.0,
          "background-color": ColorUtil.fromHex(VETheme.color.sideDark).toGMColor(),
          "components": new Array(Struct, [
            {
              name: "button_control-preview",
              template: VEComponents.get("collection-button"),
              layout: VELayouts.get("horizontal-item"),
              config: {
                label: { text: "Preview" },
                layout: {
                  height: function() { return 40 },
                },
                callback: function() { 
                  var eventInspector = this.context.eventInspector
                  var event = eventInspector.store.getValue("event")
                  if (!Core.isType(event, VEEvent)) {
                    return
                  }

                  var controller = Beans.get(BeanVisuController)
                  var handler = controller.trackService.handlers.get(event.type)
                  handler.run(handler.parse(event.toTemplate().event.data))

                  var item = this
                  controller = Beans.get(BeanVisuEditorController)
                  controller.executor.tasks.forEach(function(task, iterator, item) {
                    if (Struct.get(task.state, "item") == item) {
                      task.fullfill()
                    }
                  }, item)
                  
                  var task = new Task($"onMouseReleasedLeft_{item.name}")
                    .setTimeout(10.0)
                    .setState({
                      item: item,
                      transformer: new ColorTransformer({
                        value: VETheme.color.accentLight,
                        target: item.isHoverOver ? item.colorHoverOver : item.colorHoverOut,
                        duration: 1.0,
                      })
                    })
                    .whenUpdate(function(executor) {
                      if (this.state.transformer.update().finished) {
                        this.fullfill()
                      }
      
                      this.state.item.backgroundColor = this.state.transformer.get().toGMColor()
                    })
      
                  item.backgroundColor = ColorUtil.parse(VETheme.color.accentLight).toGMColor()
                  controller.executor.add(task)
                },
                onMouseHoverOut: function(event) {
                  var item = this
                  var controller = Beans.get(BeanVisuEditorController)
                  controller.executor.tasks.forEach(function(task, iterator, item) {
                    if (Struct.get(task.state, "item") == item) {
                      task.fullfill()
                    }
                  }, item)

                  this.backgroundColor = ColorUtil.fromHex(this.colorHoverOut).toGMColor()
                },
                onMouseHoverOver: function(event) {
                  var item = this
                  var controller = Beans.get(BeanVisuEditorController)
                  controller.executor.tasks.forEach(function(task, iterator, item) {
                    if (Struct.get(task.state, "item") == item) {
                      task.fullfill()
                    }
                  }, item)

                  this.backgroundColor = ColorUtil.fromHex(this.colorHoverOver).toGMColor()
                },
                postRender: function() {
                  var keyLabel = Struct.get(this, "keyLabel")
                  if (!Optional.is(keyLabel)) {
                    keyLabel = Struct.set(this, "keyLabel", new UILabel({
                      font: "font_inter_8_regular",
                      text: "[CTRL + A]",
                      alpha: 1.0,
                      useScale: false,
                      color: VETheme.color.textShadow,
                      align: {
                        v: VAlign.BOTTOM,
                        h: HAlign.CENTER,
                      },
                    }))
                  }
  
                  keyLabel.render(
                    this.context.area.getX() + this.area.getX() + (this.area.getWidth() / 2.0),
                    this.context.area.getY() + this.area.getY() + this.area.getHeight(),
                    this.area.getWidth(),
                    this.area.getHeight(),
                    0.9
                  )
                },
              },
            },
            {
              name: "button_control-to-brush",
              template: VEComponents.get("collection-button"),
              layout: VELayouts.get("horizontal-item"),
              config: {
                label: { text: "To brush" },
                layout: {
                  height: function() { return 40 },
                },
                callback: function() { 
                  var eventInspector = this.context.eventInspector
                  var event = eventInspector.store.getValue("event")
                  if (!Core.isType(event, VEEvent)) {
                    return
                  }

                  var editor = Beans.get(BeanVisuEditorController)
                  var brushToolbar = editor.brushToolbar
                  var store = brushToolbar.store
                  var category = brushToolbar.getCategoryFromType(event.type)
                  if (!Optional.is(category)) {
                    return
                  }

                  var eventTemplate = event.toTemplate()
                  var icon = Struct.get(eventTemplate.event.data, "icon")
                  var template = new VEBrushTemplate({
                    name: "no name brush",
                    type: event.type,
                    color: Struct.getIfType(icon, "blend", String, "#ffffff"),
                    texture: Struct.getIfType(icon, "name", String, "texture_baron"),
                    properties: eventTemplate.event.data,
                  })

                  if (store.getValue("category") != category) {
                    store.get("category").set(category)
                  }
                  
                  //if (store.getValue("type") != template.type) {
                  //  var currentTemplate = store.getValue("template")
                  //  if (Optional.is(currentTemplate)) {
                  //    var templatesCache = brushToolbar.templatesCache
                  //    templatesCache.set(store.getValue("type"), currentTemplate.toStruct())
                  //  }
                  //  store.get("type").set(template.type)
                  //}

                  var brush = brushToolbar.containers
                    .get("ve-brush-toolbar_inspector-view").state
                    .get("brush")

                  var templatesCache = brushToolbar.templatesCache
                  if (Optional.is(brush)) {
                    var _template = brush.toTemplate()
                    templatesCache.set(_template.type, _template.toStruct())
                  }
                  
                  store.get("template").set(template)

                  var item = this
                  controller = Beans.get(BeanVisuEditorController)
                  controller.executor.tasks.forEach(function(task, iterator, item) {
                    if (Struct.get(task.state, "item") == item) {
                      task.fullfill()
                    }
                  }, item)
                  
                  var task = new Task($"onMouseReleasedLeft_{item.name}")
                    .setTimeout(10.0)
                    .setState({
                      item: item,
                      transformer: new ColorTransformer({
                        value: VETheme.color.accentLight,
                        target: item.isHoverOver ? item.colorHoverOver : item.colorHoverOut,
                        duration: 1.0,
                      })
                    })
                    .whenUpdate(function(executor) {
                      if (this.state.transformer.update().finished) {
                        this.fullfill()
                      }
      
                      this.state.item.backgroundColor = this.state.transformer.get().toGMColor()
                    })
      
                  item.backgroundColor = ColorUtil.parse(VETheme.color.accentLight).toGMColor()
                  controller.executor.add(task)
                },
                onMouseHoverOut: function(event) {
                  var item = this
                  var controller = Beans.get(BeanVisuEditorController)
                  controller.executor.tasks.forEach(function(task, iterator, item) {
                    if (Struct.get(task.state, "item") == item) {
                      task.fullfill()
                    }
                  }, item)

                  this.backgroundColor = ColorUtil.fromHex(this.colorHoverOut).toGMColor()
                },
                onMouseHoverOver: function(event) {
                  var item = this
                  var controller = Beans.get(BeanVisuEditorController)
                  controller.executor.tasks.forEach(function(task, iterator, item) {
                    if (Struct.get(task.state, "item") == item) {
                      task.fullfill()
                    }
                  }, item)

                  this.backgroundColor = ColorUtil.fromHex(this.colorHoverOver).toGMColor()
                },
                postRender: function() {
                  var keyLabel = Struct.get(this, "keyLabel")
                  if (!Optional.is(keyLabel)) {
                    keyLabel = Struct.set(this, "keyLabel", new UILabel({
                      font: "font_inter_8_regular",
                      text: "[CTRL + B]",
                      alpha: 1.0,
                      useScale: false,
                      color: VETheme.color.textShadow,
                      align: {
                        v: VAlign.BOTTOM,
                        h: HAlign.CENTER,
                      },
                    }))
                  }
  
                  keyLabel.render(
                    this.context.area.getX() + this.area.getX() + (this.area.getWidth() / 2.0),
                    this.context.area.getY() + this.area.getY() + this.area.getHeight(),
                    this.area.getWidth(),
                    this.area.getHeight(),
                    0.9
                  )
                },
              },
            },
          ]),
        }),
        updateTimer: new Timer(FRAME_MS * 2, { loop: Infinity, shuffle: true }),
        eventInspector: eventInspector,
        layout: layout.nodes.control,
        updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
        render: Callable.run(UIUtil.renderTemplates.get("renderDefaultNoSurface")),
        onInit: function() {
          var layout = this.layout
          this.collection = new UICollection(this, { layout: layout })
          this.state.get("components")
            .forEach(function(component, index, collection) {
              collection.add(new UIComponent(component))
            }, this.collection)
        },
      },
    })

    return new Task("init-container")
      .setState({
        context: eventInspector,
        containers: containerIntents,
        queue: new Queue(String, GMArray.sort(containerIntents.keys().getContainer())),
      })
      .whenUpdate(function() {
        var key = this.state.queue.pop()
        if (key == null) {
          this.fullfill()
          return
        }
        this.state.context.containers.set(key, new UI(this.state.containers.get(key)))
      })
      .whenFinish(function() {
        var containers = this.state.context.containers
        IntStream.forEach(0, containers.size(), function(iterator, index, acc) {
          Beans.get(BeanVisuEditorController).uiService.send(new Event("add", {
            container: acc.containers.get(acc.keys[iterator]),
            replace: true,
          }))
        }, {
          keys: GMArray.sort(containers.keys().getContainer()),
          containers: containers,
        })
      })
  }

  ///@type {EventPump}
  dispatcher = new EventPump(this, new Map(String, Callable, {
    "open": function(event) {
      this.dispatcher.execute(new Event("close"))
      Beans.get(BeanVisuEditorController).executor
        .add(this.factoryOpenTask(event.data.layout))
    },
    "close": function(event) {
      var context = this
      this.containers.forEach(function (container, key, uiService) {
        uiService.dispatcher.execute(new Event("remove", { 
          name: key, 
          quiet: true,
        }))
      }, Beans.get(BeanVisuEditorController).uiService).clear()

      this.store.get("event").set(null)
    },
  }), { 
    enableLogger: false, 
    catchException: false,
  })

  ///@param {Event} event
  ///@return {?Promise}
  send = method(this, EventPumpUtil.send())

  ///@return {VEBrushToolbar}
  update = function() { 
    try {
      this.dispatcher.update()
    } catch (exception) {
      var message = $"VEBrushToolbar dispatcher fatal error: {exception.message}"
      Beans.get(BeanVisuController).send(new Event("spawn-popup", { message: message }))
      Logger.error("UI", message)
    }

    this.containers.forEach(function (container, key, enable) {
      container.enable = enable
    }, this.enable)
    return this
  }
}