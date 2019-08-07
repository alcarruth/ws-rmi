#!/usr/bin/env coffee
#
# ws_rmi_settings.coffee
#

defalt_settings =

  app_id: 'br549'

  local:
    host: "localhost"
    port: 8085
    path: ""
    protocol: 'ws'

  remmote:
    host: "alcarruth.net"
    port: 443
    path: "/wss/ws_rmirmi_example"
    protocol: 'wss'


class WS_RMI_Settings

  constructor: (@settings) ->
    @defalt = defalt_settings

  app_id: =>
    @settings.app_id || defalt.app_id

  local: =>
    options = {}
    for k,v of defalt.local
      options[k] = @settings[k] || @defalt[k]
    return options

  remote: =>
    options = {}
    for k,v of defalt.remote
      options[k] = @settings[k] || @defalt[k]
    return options

exports.WS_RMI_Settings = WS_RMI_Settings
