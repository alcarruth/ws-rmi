# -*- coffee -*-
#
# src/lib/ws_rmi_object.coffee
#

{ random_id } = require('./random_id')

#----------------------------------------------------------------------
# WS_RMI_Object

# RMI_Object wraps a regular coffeescript class instance object,
# exposing only those methods explicitly intended for RMI.
#
class WS_RMI_Object

  constructor: (@name, @obj, @method_names, @options) ->
    @id = random_id(@name)
    @log_level = @options?.log_level || 1
    @log = @options?.log || console.log

    for name in @method_names
      this[name] = ((name) =>
        (args...) ->
          @invoke(name, args))(name)

  set_connection: (conn) =>
    @connection = conn

  # Method invoke() is called by connection.recv_request() it executes
  # the appropriate method and returns a promise.
  #
  invoke: (method_name, args) ->

    # error handler used in .catch() just below.
    eh = (err) =>
      msg = "\nWS_RMI_Object:"
      msg += (id: @id, method: name, args: args).toString()
      return new Error(msg)

    if @log_level > 1
      @log("invoke(): ", {method_name, args})

    # call the method of the underlying object
    @obj[method_name].apply(@obj, args) # .catch(eh)


#-----------------------------------------------------------------------
# WS_RMI_Stub

class WS_RMI_Stub

  constructor: (@id, @name, @method_names, @connection, @options) ->
    @log_level = @options?.log_level || 0
    @log = @options?.log || console.log

    for name in @method_names
      this[name] = ((name) =>
        (args...) ->
          @invoke(name, args))(name)

  # Method invoke() implements local stub methods by calling
  # WS_RMI_Connection.send_request() which returns a Promise.
  #
  invoke: (name, args) ->
    if @log_level > 1
      @log("invoke(): ", {name, args})

    eh = (err) =>
      msg = "\nWS_RMI_Stub:"
      msg += (id: @id, method: name, args: args).toString()
      return new Error(msg)

    @connection.send_request(@id, name, args).catch(eh)


#----------------------------------------------------------------------

exports.WS_RMI_Object = WS_RMI_Object
exports.WS_RMI_Stub = WS_RMI_Stub
