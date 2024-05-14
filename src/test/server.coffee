# -*- coffee -*-
#
#  file: /src/test/server.coffee
#  package: ws-rmi
#

{ RMI_Server, RMI_Connection } = require('../lib')
options_choices = require('./options')
examples = require('./examples')

class Test_Server extends RMI_Server
  constructor: (type = 'ipc') ->
    options = options_choices[type]
    super({ options })

  add_example: (name = 'stack') =>
    spec = examples[name]
    @add_object({
      obj: new spec.Class()
      method_names: spec.method_names
      })

module.exports = { Test_Server }
