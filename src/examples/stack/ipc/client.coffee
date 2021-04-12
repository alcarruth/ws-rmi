#!/usr/bin/env coffee
#
#  file: src/examples/stack/ipc/client.coffee
#

{ Stack_RMI_Client } = require('../stack_rmi_client')
options = require('./settings').ipc_options

client = new Stack_RMI_Client(options)

module.exports = client
