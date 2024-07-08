# -*- coffee -*-
#
#  file: /src/test/ipc/client.coffee
#  package: ws-rmi
#

{ RMI_Client } = require('../../lib')
options = require('../options').ipc_server
spec = require('../examples').stack

client = new RMI_Client({ options })
client.add_object({
  obj: new spec.Class()
  method_names: spec.method_names
  })

module.exports = client
