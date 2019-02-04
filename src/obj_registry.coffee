

class Remote_Registry

  constructor: ->
    @registry = {}

  register: (obj) =>
    @registry[obj.id] = obj

  invoke: (obj_id, method, args) =>
    console.log obj_id
    console.log method
    console.log args
    @registry[obj_id][method](args)

  stub: (obj_id, method_names) =>
    stub_obj = {}
    for method in method_names
      stub_obj[method] = @stub_method(obj_id, method)
    return stub_obj

  stub_method: (obj_id, method) =>
    (args) =>
      @invoke(obj_id, method, args)



class Local_Registry

  constructor: (@remote) ->
    @registry = {}

  register: (obj) =>
    @registry[obj.id] = obj

  invoke: (obj_id, method, args) =>
    console.log obj_id
    console.log method
    console.log args
    @registry[obj_id][method](args)

  stub: (obj_id, method_names) =>
    stub_obj = {}
    for method in method_names
      stub_obj[method] = @stub_method(obj_id, method)
    return stub_obj

  stub_method: (obj_id, method) =>
    (args) =>
      @invoke(obj_id, method, args)


class Arithmetic

  constructor: (@id) ->
  add: (a) => a.x + a.y
  sub: (a) => a.x - a.y
  mul: (a) => a.x * a.y
  div: (a) => a.x / a.y
  mod: (a) => a.x % a.y
  abs: (a) => a.x>0 && a.x || -a.x
  

    
arith = new Arithmetic('asdf')
registry = new Obj_Registry()
registry.register(arith)
arith_stub = registry.stub('asdf', ['add','sub','mul','div','mod','abs'])

exports.arith = arith
exports.registry = registry
exports.arith_stub = arith_stub

