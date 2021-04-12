#!/usr/bin/env coffee

{ WS_RMI_Object, WS_RMI_Stub } = require('./ws_rmi_object')
{ WS_RMI_Connection } = require('./ws_rmi_connection')

{ WS_RMI_Client } = require('./ws_rmi_client')
{ WS_RMI_Server } = require('./ws_rmi_server')

exports.Object = WS_RMI_Object
exports.Stub = WS_RMI_Stub
exports.Connection = WS_RMI_Connection

exports.Client = WS_RMI_Client
exports.Server = WS_RMI_Server
