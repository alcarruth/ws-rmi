#!/bin/env/ coffee
#
# ws_rmi_app
#

{ WS_RMI_Server, WSS_RMI_Server } = require('./ws_rmi_server')
{ WS_RMI_Client, WSS_RMI_Client } = require('./ws_rmi_client')

class WS_RMI_App

  constructor: (@settings, @controller) ->
    @id = @settings.app_id
    @server = new WS_RMI_Server(this, @settings.local)
    @client = new WS_RMI_Client(this, @settings.local)
