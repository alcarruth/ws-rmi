



Files:
=======

  - file: ws_rmi_server.coffee - 70 lines
    - only needed server side - don't bundle for browser target
    - classes:
      - WS_RMI_Server_Common
      - WS_RMI_Server
      - WSS_RMI_Server

  - file: ws_rmi_client.coffee - 30 lines
    - needed for browser or nodejs client targets
    - bundle with ws_rmi_connection.coffee for browser target
    - classes:
      - WS_RMI_Client

  - file: ws_rmi_app.coffee - 350 lines
    - classes:
      - WS_RMI_Connection
      - WS_RMI_Object
      - WS_RMI_Stub


Classes:
========


 WS_RMI_Server
 --------------

  methods:
   start: =>
   stop: =>



 WS_RMI_Client
 --------------

  methods:

   # connect to ws_rmi_server
   # returns a WS_RMI_Connection
   connect: (url) =>



 WS_RMI_Connection
 ------------------
  TODO: add session functionality here

  methods:

   # event handlers:
   onOpen: (evt) =>
   onMessage: (evt) =>
   onClose: (evt) =>
   onError: (evt) =>

   # end the session and close the websocket
   disconnect: =>

   # Object registry
   register: (app) =>
   deregister: (id) =>

   # Administration
   init: =>
   init_stubs: =>

   # Generic messaging methods
   send_message: (type, msg) =>
   recv_message: (data) =>

   # Methods to Send and Receive RMI Responses
   send_response : (rmi_id, result, error) =>
   recv_response : (msg) =>

   # Methods to Send and Receive RMI Requests
   send_request: (obj_id, method, args) =>
   recv_request: (msg) =>


 WS_RMI_Object
 --------------

  - wraps a regular coffeescript class instance object
  - exposes only the methods intended for RMI
  - requires promise style methods from underlying object
  - returns promises for wrapped method invocations

  - TODO: possibly provide promise wrapper for cb type methods but this
    would seem to require some sort of type signature for the methods.

  methods:

   invoke: (name, args) ->
   - called by connection.handle_request()
   - executes the appropriate method and returns a promise.


 WS_RMI_Stub
 ------------

  methods:

   invoke: (name, args) ->
   - calls connection.send_request()
   - implements local stub methods and returns a promise
