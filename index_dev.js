#!/usr/bin/env node

require('coffeescript/register')

lib = require('./src/lib/index')

exports.WS_RMI_Connection = lib.WS_RMI_Connection
exports.WS_RMI_Object = lib.WS_RMI_Object
exports.WS_RMI_Stub = lib.WS_RMI_Stub

exports.WS_RMI_Server = lib.WS_RMI_Server
exports.WS_RMI_Client = lib.WS_RMI_Client
