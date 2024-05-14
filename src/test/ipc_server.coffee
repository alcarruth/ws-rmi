# -*- coffee -*-
#
#  file: /src/test/ipc_server.coffee
#  package: ws-rmi
#

{ Test_Server } = require('./server')

ipc_server = new Test_Server('ipc')
ipc_server.add_example('stack')

module.exports = ipc_server

