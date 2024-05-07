#!/usr/bin/env coffee
#
#  file: /src/examples/stack/browser/client.coffee
#  package: ws-rmi-examples
#

{ Stack_RMI_Client } = require('../stack_rmi_client')
{ options } = require('../settings')

client = new Stack_RMI_Client(options.remote_client)

if window?
  window.client = client
else
  module.exports = client
