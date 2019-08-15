# `ws-rmi`

Package `ws-rmi`, is a coffeescript implementation for *remote method
invocation* over websockets.  It is being developed in conjunction
with my [`web-worm`](https://github.com/alcarruth/web-worm) and
[`web-tix`](https://github.com/alcarruth/web-tix)
packages.  `web-worm` has a component `db_rmi` which basically just
extends this project for the specific case where the remote objects
represent database tables and rows.

## Overview

Two fundamental classes are `WS-RMI_App_Server` and
`WS-RMI_App_Client`.  An instance of the first, say `app_server` is
started and an `app_client` connects to it over a websocket.  The
`app_server` has one or more `app_object`s registered with it, and so
provides a means for the `app_client` to obtain a specification
suitable for the creation of the corresponding `app_object_stub`s.
Thereafter, methods invoked on the stub objects are executed by the
remote object and the result, if any, is returned to the stub.

### Asynchrony Model

`ws-rmi` currently uses callbacks and the remote object is assumed to
also require a callback argument. This means that the stub should as
well.  For a simple example, the stack class definition (in
coffeescript) looks like this:

```
class Stack

  # note that the object must have an id in order to
  # register and operate with the rmi server
  #
  constructor: (@id) ->
    @stack = []

  push: (x, cb) =>
    @stack.push(x)
    console.log @stack
    cb(true)

  pop: (cb) =>
    cb( @stack.pop())
    console.log @stack

class Stack_Stub extends WS-RMI_Stub
  @add_stub('push')
  @add_stub('pop')
```

Ideally the `ws-rmi` implementation should be flexible with respect to
the async style of the remote object making it as easy as possible for
the programmer.  Unlike the stack example the `db_orm` uses promises,
so now would be a good time for me to have a look at re-implementing
`ws-rmi` using promises as well.


## To Do

The code is still very much in flux. The design is still unsettled and
evolving as I learn more about problems inherent in the goals of the
project.  It's even fairly likely that when I'm done I'll start over
with a more informed design and re-develop the whole thing.

Perhaps most pressing is the fact that the code is woefully short on
comments and error handling.  Now that the design is beginning to
settle I'll have a better idea of what to say in my comments and error
messages so I've got no excuse except to get it done.
