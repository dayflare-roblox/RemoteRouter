# RemoteRouter

RemoteRouter is a new way to easily create and fetch remote events, aswell as containing debug methods.

RemoteRouter.new:
```
local RemoteRouter = require(game.ReplicatedStorage.RemoteRouter)
local PlayerEvent = RemoteRouter.new("RemoteEvent", "TestEvent", true)
```
``Parameters: RemoteEvent/RemoteFunction, NameOfEvent, BooleanLogs``

RemoteRouter.get:
```
local RemoteRouter = require(game.ReplicatedStorage.RemoteRouter)
RemoteRouter.get()
```
``Parameters: NameOfEvent``

Note, this is a server and client module, but use of client could lead to exploitation issues as exploiters can easily find remove events.
