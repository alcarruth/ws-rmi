#!/usr/bin/env coffee
#
#  file: src/examples/stack/wss/client.coffee
#  package: ws-rmi-examples
#

{ Stack_RMI_Client } = require('../stack_rmi_client')
options = require('./options').public_client

client = new Stack_RMI_Client(options)

if window?
  window.client = client
else
  module.exports = client
