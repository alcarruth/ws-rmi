
  constructor: ->
    @registry = {}
    @cnt = 0
    @cb_hash = {}
    @stubs = []

  # register an object for multiplex method invocation by the
  # invoke() method (below)
  # 
  register: (obj) =>
    @registry[obj.id] = obj

  # parse the request, use the obj_id to look up the
  # corresponding object and invoke the method on the
  # supplied arguments
  #   
  invoke: (args, cb) =>
    @cb_hash[@cnt] = cb 
    @cnt += 1
    obj = @registry[args.obj_id]
    obj[args.name](args.args, (res)=>
      @cb_hash[res.cb_id]()

    
    [obj_id, name, args, cb_id] = JSON.parse(msg)
    method = @registry[obj_id][name]
    

    @registry[obj_id][name](args, (res) =>
      y( [cb_id, res])))



