# -*- coffee -*-
#
#  file: /src/test/ipc/client.coffee
#  package: ws-rmi
#

{ RMI_Client } = require('../../lib')
options = require('../options')
{ stack } = require('../examples')

client = new RMI_Client({ options: options.ipc_server })
client.add_object({
  obj: new stack.Class()
  method_names: stack.method_names
  })

module.exports = client
