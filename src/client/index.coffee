# -*- coffee -*-
#
#  file: /src/client/index.coffee
#  package: ws-rmi
#

{
  WS_RMI_Connection
  WS_RMI_Object
  #
} = require('../common')

{ WS_RMI_Client } = require('../lib/ws_rmi_client')


module.exports = {
  #
  WS_RMI_Client
  WS_RMI_Connection
  WS_RMI_Object
}
