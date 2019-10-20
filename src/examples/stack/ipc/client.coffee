#!/usr/bin/env coffee
#
#  test/ipc/client.coffee
#

{ Client } = require('../stack-rmi')
options = require('../settings').ipc_options

client = new Client(options)

module.exports = client
