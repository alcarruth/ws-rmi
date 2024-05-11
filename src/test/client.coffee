# -*- coffee -*-
#
#  file: /src/test/client.coffee
#  package: ws-rmi
#

{ RMI_Client, RMI_Connection } = require('../lib')
options_choices = require('./options')
examples = require('./examples')

class Test_Client extends RMI_Client
  constructor: (type = 'ipc') ->
    options = options_choices[type]
    super({ options })

  add_example: (name = 'stack') =>
    spec = examples[name]
    @add_object({
      obj: new spec.Class()
      method_names: spec.method_names
      })

client = new Test_Client()
client.add_example()

module.exports = client
