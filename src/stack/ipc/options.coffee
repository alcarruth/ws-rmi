#!/usr/bin/env coffee
#
#  file: /src/stack/ipc/options.coffee
#  package: ws-rmi-examples
#

{ Logger } = require('../logger')
logger = new Logger()

# Unix IPC options
# Used by server and CLI client
#
options = {
  protocol: 'ws+unix'
  port: null
  host: null
  user: process.env.USER
  group: 'www-data'
  mode: 0o660
  path: '/tmp/stack-rmi'
  log_level: 2
  log: logger.log
}

module.exports = options
