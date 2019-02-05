#!/usr/bin/env node

// file: index_coffee.js
// package: ws_rmi

require('coffeescript/register');
var c = require('./lib/coffee/ws_rmi_client.coffee');
var s = require('./lib/coffee/ws_rmi_server.coffee');

exports.WS_RMI_Client = c.WS_RMI_Client
exports.WS_RMI_Stub = c.WS_RMI_Stub

exports.WS_RMI_Server = s.WS_RMI_Server
exports.WSS_RMI_Server = s.WSS_RMI_Server
