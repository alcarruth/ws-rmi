#!/usr/bin/env coffee
#
# file: /src/lib/rmi_router.coffee
# package: ws-rmi
#

{
  RMI_Server
  RMI_Client
  random_id
  #
} = require('.')


class RMI_Proxy extends RMI_Client

  constructor: ({ objects, options, Socket, Connection }) ->
    super({ objects, options, Socket, Connection })



class RMI_Router extends RMI_Server

  constructor: ({ objects, options, Socket, Connection }) ->
    super({ objects, options, Socket, Connection })

  add_proxy: ({ options }) ->
    proxy = new RMI_Proxy({ options })



module.exports = RMI_Router
