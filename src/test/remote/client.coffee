# -*- coffee -*-
#
#  file: /src/test/remote/client.coffee
#  package: ws-rmi
#

if window?
  { RMI_Client, random_id, Logger } = window.ws_rmi
else
  { RMI_Client, random_id, Logger } = require('./../../client')


class Stack

  constructor: ->
    @id = random_id(this)
    @name = 'stack'
    @stack = []

  push: (x) =>
    new Promise (resolve, reject) =>
      try
        resolve(@stack.push(x))
        console.log @stack
      catch error
        reject(error)

  pop: =>
    new Promise (resolve, reject) =>
      try
        resolve(@stack.pop())
        console.log @stack
      catch error
        reject(error)

spec = {
  Class: Stack
  method_names: [ 'push', 'pop' ]
}

options = {
  protocol: 'wss'
  port: 443
  host: 'alcarruth.net'
  path: '/wss/ws-rmi-example'
}



client = new RMI_Client({ options })
client.add_object({
  obj: new spec.Class()
  method_names: spec.method_names
  })


if window?
  window.client = client
else
  module.exports = client
