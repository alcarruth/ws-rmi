#!/usr/bin/env coffee
#
# server_example
#

WS_RMI_Server = require('ws_rmi_lib').WS_RMI_Server
Stack = require('./stack').Stack
settings = require('./settings')

class App

  constructor: (settings) ->
    @options = settings.local
    console.log @options
    @app_id = settings.app_id
    @stack = new Stack(@app_id)
    @server = new WS_RMI_Server(@options)
    @server.register(@stack)

app = new App(settings)

if module.parent
  exports.server = app.server
  exports.stack = app.stack
else
  app.server.start()
