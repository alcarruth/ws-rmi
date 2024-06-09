# -*- coffee -*-
#
#  file: /src/test/ipc_proxy/client.coffee
#  package: ws-rmi
#

{ RMI_Client } = require('../../lib')
options = require('../options')
{ stack } = require('../examples')

client = new RMI_Client({ options: options.ipc_proxy })
client.add_object({
  obj: new stack.Class()
  method_names: stack.method_names
  })

module.exports = client
