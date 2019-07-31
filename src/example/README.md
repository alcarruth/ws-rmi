
In one window start the server:

   $ ./server.coffee
   registering br549
   { br549:
      Stack {
        push: [Function: bound push],
        pop: [Function: bound pop],
        id: 'br549',
        stack: [] } }
   server listening at url: ws://localhost:8085

In another window start the client

   $ ./client.coffee
   stack> app.connect()
   stack> app.push(8, ->)
   stack> app.push('abc', ->)

Notice the activity on the server:

  client added: 4:127.0.0.1:8085
  [ 8 ]



 stack> app.push('abc', ->)
