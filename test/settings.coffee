#!/usr/bin/env coffee
#
#  settings.coffee
#

{ log } = require('logger')

ipc_options =
  path: ''
  log_level: 2
  log: log

local_options =
  host: 'localhost'
  port: 8087
  protocol: 'ws'
  path: ''
  log_level: 2
  log: log

remote_options =
  host: 'alcarruth.net'
  port: 443
  protocol: 'wss'
  path: '/wss/tickets_coffee'
  log_level: 2
  log: console.log

exports.local_options = local_options
exports.remote_options = remote_options
exports.ipc_options = ipc_options
