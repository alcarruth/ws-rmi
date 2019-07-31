#
# example/settings.coffee
#

app_id = 'br549'
mk_options = (host = 'localhost', port = 8080, path='', protocol='ws') ->
  return
    host: host
    port: port
    path: path
    protocol: protocol
    url: "#{protocol}://#{host}:#{port}/#{path}"

local = mk_options(
  host = "localhost"
  port = 8085
  path = ""
  protocol = 'ws'
  )

external = mk_options(
  host = "armazilla.net"
  port = 443
  path = "/wss/rmi_example"
  protocol = 'wss'
  )

settings =
  local: local
  external: external
  app_id: app_id

if exports?
  exports.local = local
  exports.external = external
  exports.app_id = app_id
