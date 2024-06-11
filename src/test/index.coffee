#!/usr/bin/env coffee
#
#  file: /src/test/index.coffee
#  package: ws-rmi
#

options = require('./options')
examples = require('./examples')

ipc = require('./ipc')
remote = require('./remote')

module.exports = {
  ipc
  remote
  options
  examples
}
