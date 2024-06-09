# -*- coffee -*-
#
#  file: /src/test/ipc_proxy/proxy.coffee
#  package: ws-rmi
#

{ RMI_Proxy } = require('../../lib')
options = require('../options')

proxy = new RMI_Proxy({ options: options.ipc_proxy })
proxy.add_backend({ options: options.ipc_server })

module.exports = proxy
