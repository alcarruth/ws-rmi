
WS_RMI_Client = require('./ws_rmi_client.coffee').WS_RMI_Client
Stack_Stub = require('./example_object.coffee').Stack_Stub


client = new WS_RMI_Client('ws://alcarruth.net:8080')
stack_stub = new Stack_Stub('br549')

log = (res) ->
  console.log "result: #{res}"
  
client.register(stack_stub)
exports.stack = stack_stub
exports.client = client
exports.log = log

