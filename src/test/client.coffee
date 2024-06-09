# -*- coffee -*-
#
#  file: /src/test/client.coffee
#  package: ws-rmi
#

{ RMI_Client, RMI_Connection } = require('../client')
options_choices = require('./options')
examples = require('./examples')

class Test_Client extends RMI_Client
  constructor: (type = 'ipc_server') ->
    options = options_choices[type]
    super({ options })
    @type = type

  add_example: (name = 'stack') =>
    spec = examples[name]
    @add_object({
      obj: new spec.Class()
      method_names: spec.method_names
      })

module.exports = { Test_Client }
