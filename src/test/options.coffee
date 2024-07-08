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
  ipc_server: {
    protocol: 'ws+unix'
    host: null
    port: null
    path: '/var/local/ws-rmi/stack-rmi'
    user: process.env.USER
    group: 'www-data'
    mode: 0o660
  }

  # Unix IPC options
  # Used by server and CLI client
  #
  ipc_router: {
    name: 'ipc_router'
    public_url: {
      protocol: 'ws+unix'
      host: 'alcarruth.net'
      port: '433'
      path: '/ws-rmi'
    }
    upstream_socket: {
      socket: '/var/local/ws-rmi/alcarruth.net/ipc_router'
      mode: 432
      user: 'carruth'
      group: 'www-data'
    }
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
    path: '/var/local/ws-rmi/stack-rmi'
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
