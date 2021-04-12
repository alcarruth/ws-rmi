#!/usr/bin/env coffee
#
#  file: src/examples/stack/web/client.coffee
#

{ Stack_RMI_Client } = require('../stack_rmi_client')

options =
  protocol: 'wss'
  port: 443
  host: 'alcarruth.net'
  path: '/wss/ws-rmi-example'
  log_level: 1
  log: console.log

client = new Stack_RMI_Client(options)

window.client = client
