# -*- coffee -*-
#
#  file: /src/test/ipc_client.coffee
#  package: ws-rmi
#

{ Test_Client } = require('./client')

ipc_client = new Test_Client('ipc')
ipc_client.add_example('stack')

module.exports = ipc_client
