#!/usr/bin/env coffee
#
#  file: /src/lib/rmi_object.coffee
#

{ random_id, Logger } = require('armazilla-util')

#----------------------------------------------------------------------
# RMI_Object
# RMI_Object wraps a regular coffeescript class instance object,
# exposing only those methods explicitly intended for RMI.
#
class RMI_Object

  constructor: ({ obj, name, method_names, options }) ->
    @id = random_id(this)
    @obj = obj
    @name = name || @id
    @method_names = method_names || []
    @options = options || {}
    @logger = new Logger( obj: this, threshold: 0, options: options )
    @log = @logger.log

    for name in @method_names
      this[name] = ((method_name) =>
        (args...) =>
          @invoke({ method_name, args }))(name)

  get_stub_spec: => return {
    obj_id: @id
    name: @name
    method_names: @method_names
    }

  # Method invoke() is called by connection.recv_request() it executes
  # the appropriate method and returns a promise.
  #
  invoke: ({ method_name, args }) =>
    obj_id = @id
    @log({ obj_id, method_name, args })
    return new Promise (resolve, reject) =>
      try
        # call the method of the underlying object
        #res = @obj[method_name].apply(@obj, args)
        res = @obj[method_name](args...)
        resolve(res)
      catch err
        @logger.log("rmi failed", {method_name, args})
        reject(err.msg)


#-----------------------------------------------------------------------
# RMI_Stub

class RMI_Stub

  constructor: ({ obj_id, name, method_names, send_request, options }) ->
    @id = random_id(this)
    @obj_id = obj_id
    @name = name || @obj_id
    @method_names = method_names || []
    @send_request = send_request || null
    @options = options || {}
    @logger = new Logger( obj: this, threshold: 0, options: @options )
    @log = @logger.log

    for name in @method_names
      this[name] = ((method_name) =>
        (args...) ->
          @invoke({ method_name, args }))(name)

  # Method invoke() implements local stub methods by calling
  # RMI_Connection.send_request() which returns a Promise.
  #
  invoke: ({ method_name, args }) =>
    obj_id = @obj_id
    request = { obj_id, method_name, args }
    @log(request)
    return new Promise (resolve, reject) =>
      try
        res = @send_request(request)
        resolve(res)
      catch err
        @log("rmi failed", request)
        reject(err.msg)

#----------------------------------------------------------------------

module.exports = {
  RMI_Object
  RMI_Stub
}
