#!/usr/bin/env coffee
#
#  file: /src/stack/localhost/client.coffee
#  package: ws-rmi-examples
#

{ Stack_RMI_Client } = require('../stack_rmi_client')
options = require('./options')

client = new Stack_RMI_Client(options)

module.exports = client
