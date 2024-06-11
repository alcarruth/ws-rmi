# -*- coffee -*-
#
#  file: /src/lib/index.coffee
#  package: ws-rmi
#

{
  random_id
  Logger
  RMI_Client
  RMI_Connection
  RMI_Object
  RMI_Object_Registry
  RMI_Stub
  RMI_Stub_Registry
  #
} = require('./rmi_client_nodep')

# { RMI_Proxy } = require('./rmi_proxy')
{ RMI_Server } = require('./rmi_server')

module.exports = {
  random_id
  Logger
  RMI_Client
  RMI_Server
  #RMI_Proxy
  RMI_Connection
  RMI_Object
  RMI_Stub
  RMI_Object_Registry
  RMI_Stub_Registry
}
