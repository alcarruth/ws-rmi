# -*- coffee -*-
#
#  file: /src/test/ipc/server.coffee
#  package: ws-rmi
#

{ RMI_Server } = require('../../lib')
options = require('../options').router
spec = require('../examples').router

server = new RMI_Server({ options })
server.add_object({
  obj: new spec.Class()
  method_names: spec.method_names
  })

module.exports = server
