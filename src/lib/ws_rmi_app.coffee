#!/bin/env/ coffee
#
# ws_rmi_app.coffee
#

WS_RMI_Server = require('./ws_rmi_server').Server
WS_RMI_Client = require('./ws_rmi_client').Client

random_id = (name) ->
  "#{name}-#{Math.random().toString()[2..]}"

#----------------------------------------------------------------------


class WS_RMI_App_Server

  constructor: (@id, options) ->
    @ws_rmi_server = new WS_RMI_Server(options)
    @app_objects = {}
    @add_admin_obj('admin')

  add_admin_obj: (admin_id) =>
    @admin = new WS_RMI_App_Admin_Object(admin_id, this)
    @add_app_obj(@admin)
    @load(admin_id)

  add_app_obj: (app_obj) =>
    @app_objects[app_obj.id] = app_obj

  remove_app_obj: (app_obj) =>
    id = app_obj.id
    @unload(id)
    delete @app_objects[id]

  load: (id) =>
    @ws_rmi_server.register(@app_objects[id])

  unload: (id) =>
    @ws_rmi_server.deregister(@app_objects[id])

  start: =>
    @ws_rmi_server.start()

  stop: =>
    @ws_rmi_server.stop()



#----------------------------------------------------------------------

class WS_RMI_App_Client

  constructor: (@id, options) ->
    @ws_rmi_client = new WS_RMI_Client(options)
    @app_stubs = {}
    @add_admin_stub('admin')

  add_admin_stub: (admin_id) =>
    @admin = new WS_RMI_App_Admin_Stub( admin_id, this)
    @add_app_stub( @admin)
    @load( admin_id)

  add_app_stub: (app_stub) =>
    @app_stubs[app_stub.id] = app_stub

  load: (id) =>
    @ws_rmi_client.register(@app_stubs[id])

  unload: (id) =>
    @ws_rmi_client.deregister(@app_stubs[id])

  start: =>
    @ws_rmi_client.connect()

  stop: =>
    @ws_rmi_client.disconnect()


#----------------------------------------------------------------------

class WS_RMI_App_Object

  constructor: (@name, obj, @method_names, @server) ->

    @id = random_id("table")
    @obj = obj || this

    for name in @method_names
      this[name] = ((name) =>
        (args, cb) ->
          @invoke_async(name, args, cb))(name)

     # TODO:
     # Need to handle async calls !!

  invoke_async: (name, args, cb) ->

    console.log("\nApp_Object: invoke_async()")
    console.log(id: @id, method: name, args: args, cb: cb)

    result = await @obj[name].apply(@obj, args)
    cb(result)


  invoke: (name, args, cb) ->

    console.log("\nApp_Object: invoke()")
    console.log(id: @id, method: name, args: args, cb: cb)

    args.push(cb)
    @obj[name].apply(@obj, args)



#----------------------------------------------------------------------


class WS_RMI_App_Stub

  constructor: (@id, @name, @method_names, @client) ->

    for name in @method_names
      this[name] = ((name) =>
        (args..., cb) ->
          @invoke(name, args, cb))(name)


  invoke: (name, args, cb) ->

    console.log("\nApp_Stub:")
    console.log(id: @id, method: name, args: args, cb: cb)

    @client.ws_rmi_client.send_request(@id, name, args, cb)




#----------------------------------------------------------------------


class WS_RMI_App_Admin_Object extends WS_RMI_App_Object

  constructor: (name, server) ->
    super(name, null, [], server)
    @id = @name

  init: (args, cb) =>
    specs = {}
    for id, app_obj of @server.app_objects
      specs[id] =
        name: app_obj.name
        methods: app_obj.method_names
    cb(specs)



#----------------------------------------------------------------------


class WS_RMI_App_Admin_Stub extends WS_RMI_App_Stub

  constructor: (name, client) ->
    super(name, name, [], client)

  init: =>
    @invoke('init', [], @init_cb)

  init_cb: (result) =>

    console.log(result)

    for id, spec of result
      { name, methods } = spec
      app_stub = new WS_RMI_App_Stub(id, name, methods, @client)
      @client.add_app_stub(app_stub)


#----------------------------------------------------------------------


exports.Client = WS_RMI_App_Client
exports.Server = WS_RMI_App_Server

exports.Object = WS_RMI_App_Object
exports.Stub = WS_RMI_App_Stub

exports.Admin_Object = WS_RMI_App_Admin_Object
exports.Admin_Stub = WS_RMI_App_Admin_Stub
