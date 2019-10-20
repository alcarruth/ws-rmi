#!/usr/bin/env coffee
#
#  test/tcp/client.coffee
#

{ Client } = require('../stack-rmi')
options = require('../settings').local_options

client = new Client(options)

module.exports = client
