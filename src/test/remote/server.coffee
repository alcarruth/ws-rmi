# -*- coffee -*-
#
#  file: /src/test/nginx/server.coffee
#  package: ws-rmi
#

{ RMI_Server } = require('../../lib')
options = require('../options').ipc_server
spec = require('../examples').stack

server = new RMI_Server({ options })
server.add_object({
  obj: new spec.Class()
  method_names: spec.method_names
  })

module.exports = server
