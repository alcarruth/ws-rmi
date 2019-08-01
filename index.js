#!/usr/bin/env node

// file: index.js
// package: ws_rmi

lib = require('./lib/index')
// example = require('./example/index.js')

exports.WS_RMI_Client = lib.WS_RMI_Client
exports.WS_RMI_Stub = lib.WS_RMI_Stub
exports.WS_RMI_Server = lib.WS_RMI_Server
exports.WSS_RMI_Server = lib.WSS_RMI_Server
