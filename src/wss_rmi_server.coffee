#!/bin/env/ coffee
#
# ws_rmi_server
#

# WS_RMI_Server_Common contains code common to both
# WS_RMI_Server and WSS_RMI_Server defined below
#
WS_RMI_Server_Common = require('./ws_rmi_server_common').WS_RMI_Server_Common

https = require('https')

# WSS_RMI_Server is the secure version and requires
# access to SSL credentials for the site.
#
class WSS_RMI_Server extends WS_RMI_Server_Common
  constructor: (host, port, path, credentials) ->
    webserver = https.createServer(null, credentials)
    super(webserver, host, port, path)
    @protocol = 'wss'

exports.WSS_RMI_Server = WSS_RMI_Server
