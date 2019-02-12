app = require('./client').app

#repl = require('repl')

repl.start('> ').context.app = app
