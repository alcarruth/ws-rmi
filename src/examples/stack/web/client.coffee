#!/usr/bin/env coffee
#
# src/examples/web/client.coffee
#

{ Client } = require('../stack-rmi')
options = require('../settings').remote_options

client = new Client(options)

window.client = client
