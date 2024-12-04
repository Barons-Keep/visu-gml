///@package io.alkapivo.visu.editor.ui.controller

///@param {VisuEditorController} _editor
///@param {?Struct} [config]
function VEAccordion(_editor, config = null) constructor {

  ///@type {VisuEditorController}
  editor = _editor

  ///@type {?UILayout}
  layout = null

  ///@type {VEEventInspector}
  eventInspector = new VEEventInspector(this.editor)

  ///@type {VETemplateToolbar}
  templateToolbar = new VETemplateToolbar(this.editor)

  ///@type {Map<String, UI>}
  containers = new Map(String, UI)

  ///@type {Store}
  store = new Store({
    "render-event-inspector": {
      type: Boolean,
      value: Assert.isType(Visu.settings
        .getValue("visu.editor.accordion.render-event-inspector", false), Boolean),
    },
    "render-template-toolbar": {
      type: Boolean,
      value: Assert.isType(Visu.settings
        .getValue("visu.editor.accordion.render-template-toolbar", false), Boolean),
    },
  })

  this.store.get("render-event-inspector").addSubscriber(Visu
    .generateSettingsSubscriber("visu.editor.accordion.render-event-inspector"))
  this.store.get("render-template-toolbar").addSubscriber(Visu
    .generateSettingsSubscriber("visu.editor.accordion.render-template-toolbar"))

  ///@private
  ///@param {UIlayout} parent
  ///@return {UILayout}
  factoryLayout = function(parent) {
    return new UILayout(
      {
        name: "ve-accordion",
        store: {
          "render-event-inspector": false,
          "render-template-toolbar": false,
          "templates-percentage": 0.7,
        },
        nodes: {
          "view_event-inspector": {
            name: "ve-accordion.view_event-inspector",
            margin: { top: 0, bottom: 0, right: 0, left: 1 },
            y: function() { return this.context.y() + this.margin.top },
            width: function() { return this.context.width() 
              - this.context.nodes.resize.width()
              - this.margin.left
              - this.margin.right },
            height: function() { 
              if (!Struct.get(this.context.store, "render-event-inspector")) {
                return 0
              }
              var height = this.context.height() - this.margin.top - this.margin.bottom
              if (Struct.get(this.context.store, "render-template-toolbar")) {
                height = height * (1.0 - Struct.get(this.context.store, "templates-percentage"))
              }

              return height
            },
          },
          "view_template-toolbar": {
            name: "ve-accordion.view_template-toolbar",
            margin: { top: 0, bottom: 0, right: 0, left: 1 },
            y: function() { return Struct.get(this.context.nodes, "view_event-inspector").bottom() + this.margin.top },
            width: function() { return this.context.width() 
              - this.context.nodes.resize.width()
              - this.margin.left
              - this.margin.right },
            height: function() { 
              if (!Struct.get(this.context.store, "render-template-toolbar")) {
                return 0
              }

              var height = this.context.height() - this.margin.top - this.margin.bottom
              if (Struct.get(this.context.store, "render-event-inspector")) {
                height = height * Struct.get(this.context.store, "templates-percentage")
              }

              return height
            },
          },
          "resize": {
            name: "ve-accordion.resize",
            x: function() { return this.context.x()
              + this.context.width()
              - this.width() },
            y: function() { return 0 },
            width: function() { return 7 },
            height: function() { return this.context.height() },
          },
          "options": {
            name: "ve-accordion.options",
            x: function() { return this.context.x() + this.context.width() },
            width: function() { return 24 },
            height: function() { return 420 },
          },
        }
      },
      parent
    ) 
  }

  ///@private
  ///@param {UIlayout} parent
  ///@return {Task}
  factoryOpenTask = function(parent) {
    var accordion = this
    var layout = this.factoryLayout(parent)
    this.layout = layout

    var eventInspectorEvent = new Event("open").setData({ 
      layout: Struct.get(layout.nodes, "view_event-inspector")
    })
    
    var templateToolbarEvent = new Event("open").setData({ 
      layout: Struct.get(layout.nodes, "view_template-toolbar")
    })

    var containerIntents = new Map(String, Struct, {
      "_ve-accordion_accordion-items": {
        name: "_ve-accordion_accordion-items",
        state: new Map(String, any, {
          "background-alpha": 1.0,
          "background-color": ColorUtil.fromHex(VETheme.color.darkShadow).toGMColor(),
        }),
        updateTimer: new Timer(FRAME_MS * 2, { loop: Infinity, shuffle: true }),
        accordion: accordion,
        layout: layout,
        updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
        updateCustom: function() {
          var store = this.state.get("store")
          if (!Core.isType(store, Store)
            || !Core.isType(this.layout, UILayout)) {
            return
          }
          
          Struct.set(this.layout.store, "render-event-inspector", store
            .getValue("render-event-inspector"))
          Struct.set(this.layout.store, "render-template-toolbar", store
            .getValue("render-template-toolbar"))
        },
        render: Callable.run(UIUtil.renderTemplates.get("renderDefault")),
        onInit: function() {
          var context = this
          this.state.set("store", this.accordion.store)
        },
        items: {
          "resize_accordion": {
            type: UIButton,
            layout: layout.nodes.resize,
            backgroundColor: VETheme.color.primary, //resize
            clipboard: {
              name: "resize_accordion",
              drag: function() {
                Beans.get(BeanVisuController).displayService.setCursor(Cursor.RESIZE_HORIZONTAL)
              },
              drop: function() {
                Beans.get(BeanVisuController).displayService.setCursor(Cursor.DEFAULT)
              }
            },
            updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
            updateCustom: function() {
              static updateAccordionTimer = function(container) {
                if (!Optional.is(container.updateTimer)) {
                  return
                }
                
                container.surfaceTick.skip()
                container.updateTimer.time = container.updateTimer.duration + random(container.updateTimer.duration / 2.0)
              }

              if (Beans.get(BeanVisuEditorIO).mouse.getClipboard() == this.clipboard) {
                this.updateLayout(MouseUtil.getMouseX())
                this.context.accordion.containers.forEach(updateAccordionTimer)
                this.context.accordion.eventInspector.containers.forEach(updateAccordionTimer)
                this.context.accordion.templateToolbar.containers.forEach(updateAccordionTimer)
  
                if (!mouse_check_button(mb_left)) {
                  Beans.get(BeanVisuEditorIO).mouse.clearClipboard()
                  Beans.get(BeanVisuController).displayService.setCursor(Cursor.DEFAULT)
                }
              }
            },
            updateLayout: new BindIntent(function(position) {
              var node = Struct.get(Beans.get(BeanVisuEditorController).layout.nodes, "accordion")
              node.percentageWidth = position / GuiWidth()
            }),
            onMousePressedLeft: function(event) {
              Beans.get(BeanVisuEditorIO).mouse.setClipboard(this.clipboard)
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
      "_ve-accordion_accordion-options": {
        name: "_ve-accordion_accordion-options",
        state: new Map(String, any, {
          "background-alpha": 1.0,
          "background-color": ColorUtil.fromHex(VETheme.color.darkShadow).toGMColor(),
          "components": new Array(Struct, [
            {
              name: "ve-accordion-option-button_event-inspector",
              template: VEComponents.get("category-button"),
              layout: VELayouts.get("vertical-item"),
              config: {
                backgroundColor: VETheme.color.primary,
                backgroundColorOn: ColorUtil.fromHex(VETheme.color.accent).toGMColor(),
                backgroundColorHover: ColorUtil.fromHex(VETheme.color.accentShadow).toGMColor(),
                backgroundColorOff: ColorUtil.fromHex(VETheme.color.primary).toGMColor(),
                backgroundMargin: { top: 0, bottom: 1, left: 1, right: 0 },
                callback: function() { 
                  var store = this.context.state.get("store")
                  var item = store.get("render-event-inspector")
                  item.set(!item.get())
                },
                updateCustom: function() {
                  var store = this.context.state.get("store")
                  var render = store.getValue("render-event-inspector")
                  this.backgroundColor = render
                    ? this.backgroundColorOn
                    : (this.isHoverOver ? this.backgroundColorHover : this.backgroundColorOff)
                },
                onMouseHoverOver: function(event) { },
                onMouseHoverOut: function(event) { },
                label: { 
                  font: "font_inter_8_bold",
                  text: String.toArray("EVENT").join("\n"),
                },
              },
            },
            {
              name: "ve-accordion-option-button_template-toolbar",
              template: VEComponents.get("category-button"),
              layout: VELayouts.get("vertical-item"),
              config: {
                backgroundColor: VETheme.color.primary,
                backgroundColorOn: ColorUtil.fromHex(VETheme.color.accent).toGMColor(),
                backgroundColorHover: ColorUtil.fromHex(VETheme.color.accentShadow).toGMColor(),
                backgroundColorOff: ColorUtil.fromHex(VETheme.color.primary).toGMColor(),
                backgroundMargin: { top: 1, bottom: 0, left: 1, right: 0 },
                callback: function() { 
                  var store = this.context.state.get("store")
                  var item = store.get("render-template-toolbar")
                  item.set(!item.get())
                },
                updateCustom: function() {
                  var store = this.context.state.get("store")
                  var render = store.getValue("render-template-toolbar")
                  this.backgroundColor = render
                    ? this.backgroundColorOn
                    : (this.isHoverOver ? this.backgroundColorHover : this.backgroundColorOff)
                },
                onMouseHoverOver: function(event) { },
                onMouseHoverOut: function(event) { },
                label: { 
                  font: "font_inter_8_bold",
                  text: String.toArray("TEMPLATE").join("\n"),
                },
              },
            }
          ]),
        }),
        updateTimer: new Timer(FRAME_MS * 2, { loop: Infinity, shuffle: true }),
        accordion: accordion,
        layout: layout.nodes.options,
        updateArea: Callable.run(UIUtil.updateAreaTemplates.get("applyLayout")),
        render: Callable.run(UIUtil.renderTemplates.get("renderDefaultNoSurface")),
        onInit: function() {
          var layout = this.layout
          this.collection = new UICollection(this, { layout: layout })
          this.state.set("store", this.accordion.store)
          this.state.get("components")
            .forEach(function(component, index, collection) {
              collection.add(new UIComponent(component))
            }, this.collection)
        },
      },
    })

    return new Task("init-container")
      .setState({
        context: accordion,
        containers: containerIntents,
        queue: new Queue(String, GMArray.sort(containerIntents.keys().getContainer())),
        eventInspector: accordion.eventInspector,
        eventInspectorEvent: eventInspectorEvent,
        templateToolbar: accordion.templateToolbar,
        templateToolbarEvent: templateToolbarEvent,
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

        this.state.eventInspector.send(this.state.eventInspectorEvent)
        this.state.templateToolbar.send(this.state.templateToolbarEvent)
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

      this.eventInspector.dispatcher.execute(new Event("close"))
      this.templateToolbar.dispatcher.execute(new Event("close"))
    },
  }), { 
    enableLogger: false, 
    catchException: false,
  })

  ///@param {Event} event
  ///@return {?Promise}
  send = method(this, EventPumpUtil.send())

  ///@private
  ///@params {Struct} context
  ///@params {Boolean} enable
  updateContainerObject = function(context, enable) {
    if (!context.enable && enable) {
      context.containers.forEach(function(container) {
        if (Optional.is(container.updateArea)) {
          container.updateArea()
        }
        container.items.forEach(function(item) {
          if (Optional.is(item.updateArea)) {
            item.updateArea()
          }
        }) 
      })
    }

    context.enable = enable
    context.update()
  }

  ///@private
  ///@param {UIContainer} container
  resetUpdateTimer = function(container) {
    if (!Optional.is(container.updateTimer)) {
      return
    }
    container.updateTimer.time = container.updateTimer.duration + random(container.updateTimer.duration / 2.0)
  }

  ///@return {VEBrushToolbar}
  update = function() { 

    try {
      this.dispatcher.update()
      var renderEventInspector = this.store.getValue("render-event-inspector")
      var renderTemplateToolbar = this.store.getValue("render-template-toolbar")
      if (this.eventInspector.enable != renderEventInspector
          || this.templateToolbar.enable != renderTemplateToolbar) {
        this.containers.forEach(this.resetUpdateTimer)
        this.eventInspector.containers.forEach(this.resetUpdateTimer)
        this.templateToolbar.containers.forEach(this.resetUpdateTimer)
      }
      this.updateContainerObject(this.eventInspector, renderEventInspector)
      this.updateContainerObject(this.templateToolbar, renderTemplateToolbar)
    } catch (exception) {
      var message = $"VEAccordion dispatcher fatal error: {exception.message}"
      Beans.get(BeanVisuController).send(new Event("spawn-popup", { message: message }))
      Logger.error("UI", message)
    }
    return this
  }
}