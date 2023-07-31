# file: index.js
# package: ws-rmi

lib = require('./lib/index')

exports.Connection = lib.WS_RMI_Connection
exports.Object = lib.WS_RMI_Object
exports.Stub = lib.WS_RMI_Stub

exports.Server = lib.WS_RMI_Server
exports.Client = lib.WS_RMI_Client
