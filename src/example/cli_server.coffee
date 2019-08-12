#!/usr/bin/env coffee
#

{ Stack_Server } = require('./stack')
options = require('./options')

server = new Stack_Server(options)

if module.parent
  exports.server = server

else
  # invoked from command line start REPL
  repl = require('repl')
  repl.start('server> ').context.app = server
