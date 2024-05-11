#!/usr/bin/env coffee
#
#  file: /src/test/index.coffee
#  package: ws-rmi
#

client = require('./client')
server = require('./server')
options = require('./options')
examples = require('./examples')

module.exports = {
  client
  server
  options
  examples
}
