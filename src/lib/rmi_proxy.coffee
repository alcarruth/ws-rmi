#!/usr/bin/env coffee
#
#  file: /src/server/rmi_proxy.coffee
#  package: ws-rmi
#

{ random_id, Logger } = require('armazilla-util')
{ RMI_Connection } = require('./rmi_connection')
{ RMI_Server } = require('./rmi_server')
{ RMI_Client } = require('./rmi_client')

class RMI_Proxy

  constructor: ({ objects, options, Socket, Connection }) ->
    @id = random_id(this)
    @objects = objects || {}
    @options = options || {}
    @Socket = Socket || null
    @Connection = Connection || RMI_Connection
    @server = new RMI_Server({ @objects, @options, @Socket, @Connection })
    @backends = {}
    @logger = new Logger(this, { threshold: 2, options: options })
    @log = @logger.log

  add_backend: ({ options }) =>
    objects = @objects
    client = new RMI_Client({ objects, options, @Socket, @Connection })
    @backends[client.id] = client

  start_backend: (id) =>
    client = @backends[id]
    c = await client.connect()
    for id, stub of c.stub_registry.stubs
      @server.add_object({
        obj: stub
        method_names: stub.method_names
        })

  start_backends: =>
    for id, client of @backends
      @start_backend(id)


  del_backend: (client_id) =>
    conn = @backend[client_id].connection
    for id, stub of conn.stub_registry
      @server.del_object({ id })
    delete @backends[client_id]

module.exports = { RMI_Proxy }
