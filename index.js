#!/usr/bin/env node

// file: index.js
// package: ws_rmi

require('coffeescript/register')


// client = require('./src/lib/ws_rmi_client')
// exports.Client = client.WS_RMI_Client
// exports.Client_Stub = client.WS_RMI_Stub

// server = require('./src/lib/ws_rmi_server')
// exports.Server = server.WS_RMI_Server
// exports.Secure_Server = server.WSS_RMI_Server

app = require('./src/lib/ws_rmi_app')

exports.App_Server = app.Server
exports.App_Client = app.Client

exports.App_Object = app.Object
exports.App_Stub = app.Stub

exports.App_Admin_Object = app.Admin_Object
exports.App_Admin_Stub = app.Admin_Stub
