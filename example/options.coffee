
WS_RMI_Stub = WS_RMI_Stub || require('./ws_rmi_client').WS_RMI_Stub

class Options

  constructor: (obj) ->
    @host = obj.host || 'localhost'
    @port = obj.port || 8080
    @path = obj.path || ''
    @protocol = obj.protocal || 'ws'

  url: =>
    "#{@protocol}://#{@host}:#{@port}/#{@path}"

private_options = new Options
  host: "localhost"
  port: 8085
  path: ""
  protocol: 'ws'

public_options = new Options
  host: "armazilla.net"
  port: 443
  path: "/wss/ws_rmi_example"
  protocol: 'wss'


exports.public = public_options
exports.private = private_options
