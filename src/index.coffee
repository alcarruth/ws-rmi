#!/usr/bin/env coffee

{ WS_RMI_Client } = require('./ws/client')
{ WS_RMI_Server } = require('./ws/server')

exports.WS_Server = WS_RMI_Server
exports.WS_Client = WS_RMI_Client

{ IPC_RMI_Client } = require('./ipc/client')
{ IPC_RMI_Server } = require('./ipc/server')

exports.IPC_Server = IPC_RMI_Server
exports.IPC_Client = IPC_RMI_Client

{ RMI_Connection, RMI_Object, RMI_Stub } = require('./rmi')

exports.Connection = RMI_Connection
exports.Object = RMI_Object
exports.Stub = RMI_Stub
