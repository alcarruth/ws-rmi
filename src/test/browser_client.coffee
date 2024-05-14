# -*- coffee -*-
#
#  file: /src/test/browser_client.coffee
#  package: ws-rmi
#

{ Test_Client } = require('./client')

browser_client = new Test_Client('remote')
browser_client.add_example('stack')

if window?
  window.client = browser_client
else
  module.exports = browser_client
