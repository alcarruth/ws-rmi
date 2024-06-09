# -*- coffee -*-
#
#  file: /src/test/ipc_proxy/server.coffee
#  package: ws-rmi
#

{ RMI_Server } = require('../../lib')
options = require('../options')
{ stack } = require('../examples')

server = new RMI_Server({ options: options.ipc_server })
server.add_object({
  obj: new stack.Class()
  method_names: stack.method_names
  })

module.exports = server
