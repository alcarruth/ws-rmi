#!/usr/bin/env coffee
#
#  file: /src/stack/tcp/options.coffee
#  package: ws-rmi-examples
#

{ Logger } = require('../logger')
logger = new Logger()

options = {

  # TCP host options
  # Used by both CLI client and server
  #
  protocol: 'wss'
  port: 8087
  path: ''
  host: 'alcarruth.net'
  log_level: 2
  log: logger.log
}

module.exports = options

