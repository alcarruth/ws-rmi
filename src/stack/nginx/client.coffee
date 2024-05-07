#!/usr/bin/env coffee
#
#  file: /src/stack/nginx/client.coffee
#  package: ws-rmi-examples
#

{ Stack_RMI_Client } = require('../stack_rmi_client')
options = require('./options').remote_client
console.log options

client = new Stack_RMI_Client(options)

if window?
  window.client = client
else
  module.exports = client
