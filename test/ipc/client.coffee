#!/usr/bin/env coffee
#
#  client.coffee
#

{ Client } = require('./stack-rmi')
options = require('../settings').ipc_options

client = new Client(options)

exports.client = client
