# -*- coffee -*-
#
#  file: /src/test/proxy.coffee
#  package: ws-rmi
#

{ RMI_Proxy, RMI_Connection } = require('../lib')
options_choices = require('./options')

class Test_Proxy extends RMI_Proxy
  constructor: (type = 'ipc_proxy') ->
    super({ options: options_choices[type] })
    @type = type

module.exports = { Test_Proxy }
