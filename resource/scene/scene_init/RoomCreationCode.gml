Core.print("Init scene_init")

GMObjectUtil.factoryStructInstance(
	GMServiceInstance, 
	Scene.fetchLayer("instance_main", 100),
	{
	  updateBegin: function() {
	    if (!Global.inject("__GMRT_INITIALIZED", false)) {
        Core.print("========== RUN INIT SCRIPTS BEGIN ==========")

        init_Core()
        init_GMTF()
        init_Visu()

        Global.set("__GMRT_INITIALIZED", true)
        Core.print("========== RUN INIT SCRIPTS END ==========")
      }
	  }
	}
)

GMObjectUtil.factoryStructInstance(
	GMServiceInstance, 
	Scene.fetchLayer("instance_main", 100),
	{
	  timer: new Timer(3.0, { 
	    callback: function() {
	      Scene.open("scene_visu")
	    }
	  }),
	  update: function() {
			DeltaTime.deltaTime = 1.0
	    this.timer.update()
	  }
	}
)

/*
GMObjectUtil.factoryStructInstance(
	GMServiceInstance, 
	Scene.fetchLayer("instance_main", 100),
	{
    buffer: new BufferTest(),
	  update: function() {
      if (!this.buffer.growing) {
        Scene.open("scene_visu")
      }

			this.buffer.update()

      return this
	  },
	}
)
*/