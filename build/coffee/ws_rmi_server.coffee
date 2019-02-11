#!/bin/env/ coffee
#
# ws_rmi_server.coffee
#

# WS_RMI_Server_Common contains code common to both
# WS_RMI_Server and WSS_RMI_Server defined below
#
WS_RMI_Server_Common = require('./ws_rmi_server_common.coffee').WS_RMI_Server_Common

http = require('http')

# WS_RMI_Server is the insecure version and can be run without root
# access since it does not require access to the SSL credentials
#
class WS_RMI_Server extends WS_RMI_Server_Common
  constructor: (host, port, path) ->
    webserver = http.createServer(null)
    super(webserver, host, port, path)
    @protocol = 'ws'

exports.WS_RMI_Server = WS_RMI_Server
