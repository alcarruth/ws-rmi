# -*- coffee -*-
#
#  file: /src/lib/index.coffee
#  package: ws-rmi
#

{ RMI_Client } = require('./rmi_client')
{ RMI_Server } = require('./rmi_server')
{ RMI_Proxy } = require('./rmi_proxy')
{ RMI_Connection } = require('./rmi_connection')
{ RMI_Object, RMI_Stub } = require('./rmi_object')
{ RMI_Object_Registry, RMI_Stub_Registry } = require('./rmi_registry')

module.exports = {
  RMI_Client
  RMI_Server
  RMI_Proxy
  RMI_Connection
  RMI_Object
  RMI_Stub
  RMI_Object_Registry
  RMI_Stub_Registry
}
