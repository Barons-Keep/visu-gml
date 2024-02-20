///@package io.alkapivo.visu

global.__VisuTrack = null
///@param {VisuController} _controller
function VisuTrackLoader(_controller): Service() constructor {

  ///@type {VisuController}
  controller = Assert.isType(_controller, VisuController)
  
  ///@todo extract to generic 
  ///@type {Struct}
  utils = {
    addTask: function(task, executor) {
      executor.add(task)
      return Assert.isType(task.promise, Promise)
    },
    filterPromise: function(promise, name) {
      if (!promise.isReady()) {
        return false
      }

      if (promise.status != PromiseStatus.FULLFILLED) { 
        throw new Exception($"Found rejected promise: {name}")
      }
      return true
    },
    mapPromiseToTask: function(promise) {
      return Assert.isType(promise.response, Task)
    }
  }

  ///@type {FSM}
  fsm = new FSM(this, {
    initialState: {
      name: "idle", //"parse-manifest",
      data: $"{working_directory}manifest.json",
    },
    states: {
      "idle": {
        actions: {
          onStart: function(fsm, fsmState, data) {
            if (Core.isType(data, String)) {
              Logger.info("VisuTrackLoader", $"message: '{data}'")
            }
          },
        },
        transitions: GMArray.toStruct([ "idle", "parse-manifest" ]),
      },
      "parse-manifest": {
        actions: {
          onStart: function(fsm, fsmState, path) {
            fsmState.state.set("promise", fsm.context.controller.fileService.send(
              new Event("fetch-file")
                .setData({ path: path })
                .setPromise(new Promise()
                  .whenSuccess(function(result) {
                    var callback = this.setResponse
                    JSON.parserTask(result.data, { 
                      callback: function(prototype, json, key, acc) {
                        acc.callback(new prototype(acc.path, json))
                      }, 
                      acc: {
                        callback: callback,
                        path: result.path,
                      },
                    }).update()
                    
                    global.__todo_bpm = this.response.bpm ///@hack
                    return {
                      path: Assert.isType(FileUtil.getDirectoryFromPath(result.path), String),
                      manifest: Assert.isType(this.response, VisuTrack),
                    }
                  })
                )
            ))
          },
        },
        update: function(fsm) {
          try {
            var promise = this.state.get("promise")
            if (!promise.isReady()) {
              return
            }
            
            fsm.dispatcher.send(new Event("transition", {
              name: "create-parser-tasks",
              data: {
                path: Assert.isType(promise.response.path, String),
                manifest: Assert.isType(promise.response.manifest, VisuTrack),
              },
            }))
          } catch (exception) {
            Logger.error("VisuTrackLoader", $"{exception.message}")
            fsm.dispatcher.send(new Event("transition", {
              name: "idle",
              data: $"'parse-manifest' fatal error: {exception.message}",
            }))
          }
        },
        transitions: GMArray.toStruct([ "idle", "create-parser-tasks" ]),
      },
      "create-parser-tasks": {
        actions: {
          onStart: function(fsm, fsmState, data) {
            var controller = fsm.context.controller
            global.__VisuTrack = data.manifest
            var promises = new Map(String, Promise, {
              "texture": controller.fileService.send(
                new Event("fetch-file")
                  .setData({ path: $"{data.path}{data.manifest.texture}" })
                  .setPromise(new Promise()
                    .setState({ 
                      callback: function(prototype, json, iterator, acc) {
                        Logger.debug("VisuTrackLoader", $"load texture '{json.name}'")
                        acc.promises.forEach(function(promise, key) {
                          if (promise.status == PromiseStatus.REJECTED) {
                            throw new Exception($"Found rejected load-texture promise for key '{key}'")
                          }
                        })

                        var textureIntent = Assert.isType(new prototype(json), TextureIntent)
                        textureIntent.file = FileUtil.get($"{acc.path}{FileUtil.getFilenameFromPath(textureIntent.file)}")
                        var promise = new Promise()
                        acc.service.send(new Event("load-texture")
                          .setData(textureIntent)
                          .setPromise(promise))
                        acc.promises.add(promise, textureIntent.name)
                      },
                      acc: {
                        service: Beans.get(BeanTextureService),
                        promises: new Map(String, Promise),
                        path: global.__VisuTrack.path,
                      },
                      steps: 2,
                    })
                    .whenSuccess(function(result) {
                      return Assert.isType(JSON.parserTask(result.data, this.state), Task)
                    }))
              ),
              "sound": controller.fileService.send(
                new Event("fetch-file")
                  .setData({ path: $"{data.path}{data.manifest.sound}" })
                  .setPromise(new Promise()
                    .setState({ 
                      callback: function(prototype, json, key, acc) {
                        Logger.debug("VisuTrackLoader", $"load sound intent '{key}'")
                        var soundIntent = new prototype(json)
                        var soundService = acc.soundService
                        var path = FileUtil.get($"{acc.path}{soundIntent.file}")
                        Assert.fileExists(path)
                        Assert.isFalse(soundService.sounds.contains(key), "GMSound already loaded")
                        soundService.sounds.add(audio_create_stream(path), key)
                        soundService.intents.add(soundIntent, key)
                      },
                      acc: {
                        soundService: Beans.get(BeanSoundService),
                        path: global.__VisuTrack.path,
                      },
                      steps: MAGIC_NUMBER_TASK,
                    })
                    .whenSuccess(function(result) {
                      return Assert.isType(JSON.parserTask(result.data, this.state), Task)
                    }))
              ),
              "shader": controller.fileService.send(
                new Event("fetch-file")
                  .setData({ path: $"{data.path}{data.manifest.shader}" })
                  .setPromise(new Promise()
                    .setState({ 
                      callback: function(prototype, json, key, acc) {
                        Logger.debug("VisuTrackLoader", $"load shader '{key}'")
                        acc.set(key, new prototype(key, json))
                      },
                      acc: controller.shaderPipeline.templates,
                      steps: MAGIC_NUMBER_TASK,
                    })
                    .whenSuccess(function(result) {
                      return Assert.isType(JSON.parserTask(result.data, this.state), Task)
                    }))
              ),
              "video": new Promise().fullfill(
                new Task("send-load-video")
                  .setPromise(new Promise())
                  .setState(new Map(any, any, {
                    service: controller.videoService,
                    event: new Event("open-video", {
                      video: {
                        name: $"{data.manifest.video}",
                        path: $"{data.path}{data.manifest.video}",
                        timestamp: 0.0,
                        volume: 0,
                      }
                    })
                  }))
                  .whenUpdate(function() {
                    var event = Assert.isType(this.state.get("event"), Event)
                    var service = Assert.isType(this.state.get("service"), VideoService)
                    var name = Struct.get(Struct.get(event.data, "video"), "name")
                    service.send(event.setPromise(Assert.isType(this.promise, Promise)))
                    Logger.debug("VisuTrackLoader", $"load video '{name}'")
                    this.setPromise()
                    this.fullfill()
                  })
              ),
              "track": controller.fileService.send(
                new Event("fetch-file")
                  .setData({ path: $"{data.path}{data.manifest.track}" })
                  .setPromise(new Promise()
                    .setState({ 
                      callback: function(prototype, json, key, acc) {
                        var name = Struct.get(json, "name")
                        Logger.debug("VisuTrackLoader", $"load track '{name}'")
                        acc.openTrack(new prototype(json, { handlers: acc.handlers }))
                      },
                      acc: controller.trackService
                    })
                    .whenSuccess(function(result) {
                      return Assert.isType(JSON.parserTask(result.data, this.state), Task)
                    }))
              ),
              "bullet": controller.fileService.send(
                new Event("fetch-file")
                  .setData({ path: $"{data.path}{data.manifest.bullet}" })
                  .setPromise(new Promise()
                    .setState({ 
                      callback: function(prototype, json, key, acc) {
                        Logger.debug("VisuTrackLoader", $"load bullet template '{key}'")
                        acc.set(key, new prototype(key, json))
                      },
                      acc: controller.bulletService.templates,
                      steps: MAGIC_NUMBER_TASK,
                    })
                    .whenSuccess(function(result) {
                      return Assert.isType(JSON.parserTask(result.data, this.state), Task)
                    }))
              ),
              "lyrics": controller.fileService.send(
                new Event("fetch-file")
                  .setData({ path: $"{data.path}{data.manifest.lyrics}" })
                  .setPromise(new Promise()
                    .setState({ 
                      callback: function(prototype, json, key, acc) {
                        Logger.debug("VisuTrackLoader", $"load lyrics template '{key}'")
                        acc.set(key, new prototype(key, json))
                      },
                      acc: controller.lyricsService.templates,
                      steps: MAGIC_NUMBER_TASK,
                    })
                    .whenSuccess(function(result) {
                      return Assert.isType(JSON.parserTask(result.data, this.state), Task)
                    }))
              ),
              "shroom": controller.fileService.send(
                new Event("fetch-file")
                  .setData({ path: $"{data.path}{data.manifest.shroom}" })
                  .setPromise(new Promise()
                    .setState({ 
                      callback: function(prototype, json, key, acc) {
                        Logger.debug("VisuTrackLoader", $"load shroom template '{key}'")
                        acc.set(key, new prototype(key, json))
                      },
                      acc: controller.shroomService.templates,
                      steps: MAGIC_NUMBER_TASK,
                    })
                    .whenSuccess(function(result) {
                      return Assert.isType(JSON.parserTask(result.data, this.state), Task)
                    }))
              ),
              "particle": controller.fileService.send(
                new Event("fetch-file")
                  .setData({ path: $"{data.path}{data.manifest.particle}" })
                  .setPromise(new Promise()
                    .setState({ 
                      callback: function(prototype, json, key, acc) {
                        Logger.debug("VisuTrackLoader", $"load particle template '{key}'")
                        acc.set(key, new prototype(key, json))
                      },
                      acc: controller.particleService.templates,
                      steps: MAGIC_NUMBER_TASK,
                    })
                    .whenSuccess(function(result) {
                      return Assert.isType(JSON.parserTask(result.data, this.state), Task)
                    }))
              ),
            })
            data.manifest.editor.forEach(function(file, index, acc) { 
              var promise = acc.controller.fileService.send(
                new Event("fetch-file")
                  .setData({ path: $"{acc.data.path}{file}" })
                  .setPromise(new Promise()
                    .setState({ 
                      callback: function(prototype, json, index, acc) {
                        Logger.debug("VisuTrackLoader", $"load editor '{acc.file}' brush no. {index}")
                        acc.saveTemplate(new prototype(json))
                      },
                      acc: {
                        saveTemplate: acc.controller.editor.brushService.saveTemplate,
                        file: file,
                      },
                      steps: MAGIC_NUMBER_TASK,
                    })
                    .whenSuccess(function(result) {
                      return Assert.isType(JSON.parserTask(result.data, this.state), Task)
                    }))
              )
              acc.promises.add(promise, file)
            }, { controller: controller, data: data, promises: promises })
            
            fsmState.state.set("promises", promises)
          },
        },
        update: function(fsm) {
          try {
            var promises = this.state.get("promises")
            var filtered = promises.filter(fsm.context.utils.filterPromise)
            if (filtered.size() != promises.size()) {
              return
            }

            fsm.dispatcher.send(new Event("transition", {
              name: "parse-primary-assets",
              data: filtered.map(fsm.context.utils.mapPromiseToTask, null, String, Task),
            }))
          } catch (exception) {
            Logger.error("VisuTrackLoader", $"{exception.message}")
            fsm.dispatcher.send(new Event("transition", {
              name: "idle",
              data: $"'create-parser-tasks' fatal error: {exception.message}",
            }))
          }
        },
        transitions: GMArray.toStruct([ "idle", "parse-primary-assets" ]),
      },
      "parse-primary-assets": {
        actions: {
          onStart: function(fsm, fsmState, tasks) { 
            var addTask = fsm.context.utils.addTask
            var executor = fsm.context.controller.executor
            fsmState.state.set("tasks", tasks).set("promises", new Map(String, Promise, {
              "texture": addTask(tasks.get("texture"), executor),
              "sound": addTask(tasks.get("sound"), executor),
              "shader": addTask(tasks.get("shader"), executor),
              "video": addTask(tasks.get("video"), executor),
            }))
          },
        },
        update: function(fsm) {
          try {
            var promises = this.state.get("promises")
            var filtered = promises.filter(fsm.context.utils.filterPromise)
            if (filtered.size() != promises.size()) {
              return
            }

            fsm.dispatcher.send(new Event("transition", {
              name: "parse-secondary-assets",
              data: Assert.isType(this.state.get("tasks"), Map)
            }))
          } catch (exception) {
            Logger.error("VisuTrackLoader", $"{exception.message}")
            fsm.dispatcher.send(new Event("transition", {
              name: "idle",
              data: $"'parse-primary-assets' fatal error: {exception.message}",
            }))
          }
        },
        transitions: GMArray.toStruct([ "idle", "parse-secondary-assets" ]),
      },
      "parse-secondary-assets": {
        actions: {
          onStart: function(fsm, fsmState, tasks) { 
            var addTask = fsm.context.utils.addTask
            var executor = fsm.context.executor
            var promises = new Map(String, Promise, {
              "bullet": addTask(tasks.get("bullet"), executor),
              "lyrics": addTask(tasks.get("lyrics"), executor),
              "particle": addTask(tasks.get("particle"), executor),
              "shroom": addTask(tasks.get("shroom"), executor),
              "track": addTask(tasks.get("track"), executor),
            })

            tasks.forEach(function(task, key, acc) { 
              if (String.contains(key, ".json")) {
                acc.promises.add(acc.addTask(task, acc.executor), key)
              }
            }, { addTask: addTask, executor: executor, promises: promises })
            
            fsmState.state.set("tasks", tasks).set("promises", promises)
          },
        },
        update: function(fsm) {
          try {
            var promises = this.state.get("promises")
            var filtered = promises.filter(fsm.context.utils.filterPromise)
            if (filtered.size() != promises.size()) {
              return
            }

            fsm.dispatcher.send(new Event("transition", { name: "loaded" }))
          } catch (exception) {
            Logger.error("VisuTrackLoader", $"{exception.message}")
            fsm.dispatcher.send(new Event("transition", {
              name: "idle",
              data: $"'parse-secondary-assets' fatal error: {exception.message}",
            }))
          }
        },
        transitions: GMArray.toStruct([ "idle", "loaded" ]),
      },
      "loaded": {
        actions: {
          onStart: function(fsm, fsmState, tasks) { 
            fsm.context.controller.editor.send(new Event("open"))
          }
        },
        transitions: GMArray.toStruct([ "idle", "parse-manifest" ]),
      }
    }
  })

  ///@private
  ///@type {TaskExecutor}
  executor = new TaskExecutor(this, { catchException: false })

  ///@return {FSM}
  update = method(this, function() {
    this.fsm.update()
    this.executor.update()
    return this
  })
}
