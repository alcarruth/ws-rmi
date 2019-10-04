#!/usr/bin/env coffee

{ WS_RMI_Client } = require('./client')
{ WS_RMI_Server } = require('./server')

exports.Server = WS_RMI_Server
exports.Client = WS_RMI_Client

{ RMI_Connection, RMI_Object, RMI_Stub } = require('./rmi')

exports.Connection = RMI_Connection
exports.Object = RMI_Object
exports.Stub = RMI_Stub
