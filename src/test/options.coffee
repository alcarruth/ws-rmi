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
    port: null
    host: null
    path: '/tmp/stack-rmi'
    user: process.env.USER
    group: 'www-data'
    mode: 0o660
  }

  # Unix IPC options
  # Used by server and CLI client
  #
  ipc: {
    protocol: 'ws+unix'
    port: null
    host: null
    #uid: undefined # defaults to user starting server
    #gid: 33        # group 'www-data'
    user: process.env.USER
    group: 'www-data'
    mode: 0o660
    path: '/tmp/stack-rmi'
  }

  # NGINX IPC options
  # Used by nginx to connect to backend socket
  #
  nginx_ipc: {
    protocol: 'ws+unix'
    port: null
    host: null
    uid: process.env.USER
    gid: 'www-data'
    mode: 0o660
    path: '/tmp/stack-rmi'
  }

  # Remote client options
  # Used by remote cli client and by browser
  #
  remote_client: {
    protocol: 'wss'
    port: 443
    host: 'alcarruth.net'
    path: '/wss/ws-rmi-example'
  }


}




module.exports = options
