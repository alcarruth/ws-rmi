#!/usr/bin/env coffee
#
#  file: /src/test/options.coffee
#  package: ws-rmi
#

options = {

  # Local host options
  # Used by both CLI client and server
  #
  localhost: {
    protocol: 'ws'
    port: 8087
    host: 'localhost'
    path: ''
    user: process.env.USER
    group: 'www-data'
    mode: 0o660
  }

  # Unix IPC options
  # Used by server and CLI client
  #
  ipc: {
    protocol: 'ws+unix'
    host: null
    port: null
    path: '/tmp/stack-rmi'
    user: process.env.USER
    group: 'www-data'
    mode: 0o660
  }

  # NGINX IPC options
  # Used by nginx to connect to backend socket
  #
  nginx_ipc: {
    protocol: 'ws+unix'
    host: null
    port: null
    uid: process.env.USER
    gid: 'www-data'
    mode: 0o660
    path: '/tmp/stack-rmi'
  }

  # Remote client options
  # Used by remote cli client and by browser
  #
  remote: {
    protocol: 'wss'
    port: 443
    host: 'alcarruth.net'
    path: '/wss/ws-rmi-example'
  }


}




module.exports = options
