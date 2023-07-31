# -*- coffee -*-
#
#  src/server/index.coffee
#

{
  WS_RMI_Connection
  WS_RMI_Object
  WS_RMI_Stub
  random_id
  #
} = require('../common')

{ WS_RMI_Client } = require('./ws_rmi_client')
{ WS_RMI_Server } = require('./ws_rmi_server')

module.exports = {
  WS_RMI_Connection
  WS_RMI_Object
  WS_RMI_Stub
  random_id
  WS_RMI_Server
  WS_RMI_Client
}
