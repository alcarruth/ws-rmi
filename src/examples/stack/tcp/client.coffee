#!/usr/bin/env coffee
#
#  file: src/examples/stack/tcp/client.coffee
#

{ Stack_RMI_Client } = require('../stack_rmi_client')
options = require('./settings').local_options

client = new Stack_RMI_Client(options)

module.exports = client
