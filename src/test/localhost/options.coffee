#!/usr/bin/env coffee
#
#  file: /src/stack/localhost/options.coffee
#  package: ws-rmi-examples
#

{ Logger } = require('../logger')
logger = new Logger()

# Local host options
# Used by both CLI client and server
#
options = {
  protocol: 'ws'
  port: 8087
  path: ''
  host: 'localhost'
  log_level: 2
  log: logger.log
}

module.exports = options
