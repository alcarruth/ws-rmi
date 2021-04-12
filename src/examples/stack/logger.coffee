#!/usr/bin/env coffee
#
#  logger.coffee
#

util = require('util')

class Logger

  constructor: (options) ->
    @options = 
      colors: options?.colors || true
      depth: options?.depth || null

  log: (xs...) ->
    console.log("\n")
    for x in xs
      if typeof(x) == 'string'
        console.log(x)
      else
        console.log(util.inspect(x, @options))

exports.Logger = Logger
    
