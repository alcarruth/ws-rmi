#!/usr/bin/env coffee

app = require('./client').app

cs_repl = require('coffeescript/repl')

#repl = require('repl')
#app.setPrompt = repl.repl.setPrompt

cs_repl.start('ws_rmi').context.app = app
