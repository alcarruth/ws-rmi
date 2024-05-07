# -*- coffee -*-
#
#  file: /src/client/index.coffee
#  package: ws-rmi
#

{ RMI_Client } = require('../lib/rmi_client')
{ RMI_Connection } = require('../lib/rmi_connection')
{ RMI_Object, RMI_Stub } = require('../lib/rmi_object')
{ RMI_Object_Registry, RMI_Stub_Registry } = require('../lib/rmi_registry')

module.exports = {
  RMI_Client
  RMI_Connection
  RMI_Object
  RMI_Stub
  RMI_Object_Registry
  RMI_Stub_Registry
}
