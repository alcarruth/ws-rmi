#!/usr/bin/env coffee
#
#  file: /src/test/ipc/client.coffee
#  package: ws-rmi
#

options = require('./options')
{ Stack_RMI_Client } = require('../stack_rmi_client')

client = new Stack_RMI_Client(options)

module.exports = client
