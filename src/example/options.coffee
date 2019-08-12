#!/usr/bin/env coffee
#

options =
  host: 'localhost'
  port: 8086
  path: ''
  protocol: 'ws'
  log_level: 0


for k,v of options
  exports[k] = v
