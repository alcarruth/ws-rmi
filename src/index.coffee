# -*- coffee -*-
#
#  file: /src/index.coffee
#  package: ws-rmi
#

{
  random_id
  Logger
  RMI_Client
  RMI_Server
  # RMI_Proxy
  RMI_Connection
  RMI_Object
  RMI_Stub
  RMI_Object_Registry
  RMI_Stub_Registry
  #
} = require('./lib')

test = require('./test')

module.exports = {
  random_id
  Logger
  RMI_Client
  RMI_Server
  # RMI_Proxy
  RMI_Connection
  RMI_Object
  RMI_Stub
  RMI_Object_Registry
  RMI_Stub_Registry
  test
}
