#!/usr/bin/env coffee

rmi = require('./rmi')
WS_RMI_Client = require('./ws_rmi_client')
WS_RMI_Server = require('./ws_rmi_server')

exports.Server = WS_RMI_Server
exports.Client = WS_RMI_Client

exports.Connection = rmi.Connection
exports.Object = rmi.Object
exports.Stub = rmi.Stub
