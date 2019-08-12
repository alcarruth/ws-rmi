#!/usr/bin/env coffee
#

{ Stack_Client } = require('./stack')
options = require('./options')

client = new Stack_Client(options)

if module.parent
  exports.cli = cli

else
  # invoked from command line start REPL
  repl = require('repl')
  repl.start('client> ').context.app = client
