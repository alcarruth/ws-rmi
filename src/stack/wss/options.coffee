#!/usr/bin/env coffee
#
#  file: /src/stack/wss/options.coffee
#  package: ws-rmi-examples
# 

{ Logger } = require('../logger')
logger = new Logger()

port = 8087
key_file = '/etc/letsencrypt/live/alcarruth.net/privkey.pem'
cert_file = '/etc/letsencrypt/live/alcarruth.net/fullchain.pem'

options = {

  # Local host server
  #
  local_server:
    protocol: 'wss'
    key_file: key_file
    cert_file: cert_file
    port: port
    path: '/'
    host: 'localhost'
    log_level: 2
    log: logger.log

  # Public server
  #
  public_server:
    protocol: 'wss'
    key_file: key_file
    cert_file: cert_file
    port: port
    path: '/'
    host: 'alcarruth.net'
    log_level: 2
    log: logger.log

  # local client options
  #
  local_client:
    protocol: 'wss'
    port: port
    host: 'localhost'
    path: '/'
    log_level: 1
    log: logger.log

  # public client options
  #
  public_client:
    protocol: 'wss'
    port: port
    host: 'alcarruth.net'
    path: '/'
    log_level: 1
    log: console.log

}

module.exports = options
