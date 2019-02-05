#!/usr/bin/env node

// file: index_js5.js
// package: ws_rmi

var c = require('lib/js5/ws_rmi_client.js')
var s = require('lib/js5/ws_rmi_server.js')

exports.WS_RMI_Client = c.WS_RMI_Client
exports.WS_RMI_Stub = c.WS_RMI_Stub

exports.WS_RMI_Server = s.WS_RMI_Server
exports.WSS_RMI_Server = s.WSS_RMI_Server
