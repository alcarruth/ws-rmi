# -*- coffee -*-
#
#  file: /src/test/remote_client.coffee
#  package: ws-rmi
#

{ Test_Client } = require('./client')

remote_client = new Test_Client('remote')
remote_client.add_example('stack')

if window?
  window.client = remote_client
else
  module.exports = remote_client
