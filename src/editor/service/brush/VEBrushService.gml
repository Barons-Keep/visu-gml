///@package io.alkapivo.visu.editor.service.brush

function VEBrushService() constructor {

  ///@type {Map<String, Array>}
  templates = new Map(String, Array)

  ///@description init templates with VEBrushType keys
  VEBrushType.keys().forEach(function(key, index, templates) {
    templates.add(new Array(VEBrushTemplate), VEBrushType.get(key))
  }, this.templates)

  ///@param {VEBrushType} type
  ///@return {?Array}
  fetchTemplates = function(type) {
    var templates = this.templates.get(type)
    return Optional.is(templates) ? Assert.isType(templates, Array) : null
  }

  ///@param {VEBrushTemplate}
  ///@param {?Number} idx
  ///@return {VEBrushService}
  saveTemplate = function(template, idx = null) {
    if (!Core.isType(template, VEBrushTemplate)) {
      Logger.warn("VEBrushService::saveTemplate", $"Template must be type of VEBrushTemplate")
      return this
    }

    var templates = this.templates.get(template.type)
    if (!Core.isType(templates, Array)) {
      Logger.warn("VEBrushService", $"Unable to find template for type '{template.type}'")
      return this
    }

    var index = templates.findIndex(function(template, index, name) {
      return template.name == name
    }, template.name)

    if (Optional.is(index)) {
      //Logger.info("VEBrushService", $"Template of type '{template.type}' updated: '{template.name}'")
      templates.set(index, template)
    } else {
      //Logger.info("VEBrushService", $"Template of type '{template.type}' added: '{template.name}'")
      if (Core.isType(idx, Number)) {
        templates.add(template, idx)
      } else {
        templates.add(template)
      }
    }

    return this
  }

  ///@param {VEBrushTemplate}
  ///@return {VEBrushService}
  removeTemplate = function(template) {
    if (!Core.isType(template, VEBrushTemplate)) {
      Logger.warn("VEBrushService::removeTemplate", $"Template must be type of VEBrushTemplate")
      return this
    }

    var templates = this.templates.get(template.type)
    if (!Core.isType(templates, Array)) {
      Logger.warn("VEBrushService::removeTemplate", $"Unable to find template for type '{template.type}'")
      return this
    }

    var index = templates.findIndex(function(template, index, name) {
      return template.name == name
    }, template.name)

    if (Optional.is(index)) {
      Logger.info("VEBrushService::removeTemplate", $"Template of type '{template.type}' removed: '{template.name}'")
      templates.remove(index)
    } else {
      Logger.warn("VEBrushService::removeTemplate", $"Template of type '{template.type}' wasn't found: '{template.name}'")
    }

    return this
  }

  ///@param {VEBrushTemplate}
  ///@return {VEBrush}
  templateToBrush = function(template) {
    return new VEBrush(template)
  }

  ///@param {VEBrush}
  ///@return {VEBrushTemplate}
  brushToTemplate = function(brush) {
    var json = {
      name: Assert.isType(brush.store.getValue("brush-name"), String),
      type: Assert.isEnum(brush.type, VEBrushType),
      color: Assert.isType(brush.store.getValue("brush-color"), Color).toHex(),
      texture: Assert.isType(brush.store.getValue("brush-texture"), String),
      hidden: Assert.isType(brush.store.getValue("brush-hidden"), Boolean),
    }

    var properties = brush.store.container
      .filter(function(item) {
        return item.name != "brush-name" 
          && item.name != "brush-color" 
          && item.name != "brush-texture" 
          && item.name != "brush-hidden" 
      })
      .toStruct(function(item) { 
        return item.stringify()
      })
    
    if (Struct.size(properties) > 0) {
      Struct.set(json, "properties", properties)
    }

    return new VEBrushTemplate(json)
  }

  ///@return {VEBrushTemplate}
  clearTemplates = function() {
    this.templates.forEach(function(array) {
      array.clear()
    })
    return this
  }
}