# `ws-rmi`

Package `ws-rmi`, is a coffeescript implementation for *remote method
invocation* over websockets.  It is being developed in conjunction
with my [`web-worm`](https://github.com/alcarruth/web-worm) and
[`web-tix`](https://github.com/alcarruth/web-tix)
packages.  `web-worm` has a component `db_rmi` which
extends this project for the specific case where the remote objects
represent database tables and rows.

## Overview

This package provides five classes `ws-rmi.Server`, `ws-rmi.Client`,
`ws-rmi.Connection`, `ws-rmi.Object` and `ws-rmi.Stub`. Using it
involves starting a `ws-rmi.Server`, and registering one or more
`ws-rmi.Object`s with it. Then a `ws-rmi.Client` is started and
connects to the server using a websocket url.  When this happens, both
the client and the server wrap the websocket with a
`ws-rmi.Connection` class.  As part of the initialization the server
sends information to the client sufficient for the client to create a
`ws-rmi.Stub` for each `ws-rmi.Object` registered with the server.
Thereafter, methods invoked on the stub objects are executed by the
remote object and the result, if any, is returned to the stub.

### Asynchrony Model

`ws-rmi` uses Promises and the remote object is assumed to as well.
For a simple example, the stack class definition (in
coffeescript) looks like this:

```
class Stack

  constructor: ->
    @stack = []

  push: (x) =>
    new Promise (resolve, reject) =>
      try
        resolve(@stack.push(x))
        console.log @stack
      catch error
        reject(error)

  pop: =>
    new Promise (resolve, reject) =>
      try
        resolve(@stack.pop())
        console.log @stack
      catch error
        reject(error)
```
