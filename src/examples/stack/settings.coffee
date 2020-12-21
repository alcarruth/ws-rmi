#!/usr/bin/env coffee
#
#  settings.coffee
#

util = require('util')

log_options =
  colors: true
  depth: null

log = (xs...) ->
  console.log("\n")
  for x in xs
    if typeof(x) == 'string'
      console.log(x)
    else
      console.log(util.inspect(x, log_options))

ipc_options =
  protocol: 'ws+unix'
  port: null
  host: null
  path: '/tmp/stack-rmi'
  log_level: 2
  log: log

local_options =
  protocol: 'ws'
  port: 8087
  path: ''
  host: 'localhost'
  log_level: 1
  log: log

remote_options =
  protocol: 'wss'
  port: 443
  host: 'alcarruth.net'
  path: '/wss/tickets_coffee'
  log_level: 1
  log: console.log

exports.local_options = local_options
exports.remote_options = remote_options
exports.ipc_options = ipc_options
