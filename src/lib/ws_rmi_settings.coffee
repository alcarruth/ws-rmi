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

  remote:
    host: "alcarruth.net"
    port: 443
    path: "/wss/ws_rmirmi_example"
    protocol: 'wss'

class WS_RMI_Settings

  constructor: (settings) ->
    @__keys = ['host', 'port', 'path', 'protocol']
    @__defalt = defalt_settings

    @set_app_id(settings.app_id)
    @set_local(settings.local)
    @set_remote(settings.remote)

  set_app_id: (app_id) =>
    @__app_id = app_id || @__defalt.app_id

  set_local: (options) =>
    @__local = {}
    for key in @__keys
      @__local[key] = options?[key] || @__defalt.local[key]

  set_remote: (options) =>
    @__remote = {}
    for key in @__keys
      @__remote[key] = options?[key] || @__defalt.remote[key]

  app_id: => @__app_id
  local:  => @__local
  remote: => @__remote


exports.Settings = WS_RMI_Settings
