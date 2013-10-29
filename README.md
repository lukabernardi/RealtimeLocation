Realtime Location Demo
==========

This is the demo project shown during my talk "Full-duplex cloud app with WebSocket" at Pragma Conference 2013.

It shows how to use socket.io (WebSocket) and iOS to realize an app similar to Find My Friends where you can see other people on the map in realtime.

#Server

All the server side code is inside the folder named `server'.

Before run the server you need to install all the npm dependecies by using:

`npm install`

To start the server (from the project root) launch:

```
node server/server.js
```

#Client

Before open the project run cocoapods in order to install all the project dependecies (and don't forget to open the .xcworkspace file):

`pod install`

The client is configured to use a random walk algorithm in order to simulate the movement on the map.
To use the real GPS data just use `LBRLocationSourceSensor` instead of `LBRLocationSourceCanned`.

The project also includes .gpx files to be able to simulate other locations in the simulator.