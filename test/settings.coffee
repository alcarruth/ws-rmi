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
  path: ''
  protocol: 'ws'
  log_level: 2
  log: log

remote_options =
  host: 'alcarruth.net'
  port: 443
  path: '/wss/tickets_coffee'
  protocol: 'wss'
  log_level: 2
  log: console.log

exports.local_options = local_options
exports.remote_options = remote_options
