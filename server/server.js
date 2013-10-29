var SocketIO 	= require('socket.io').listen(424242),
	logger 		= console.log;

	SocketIO.sockets.on('connection', function(socket) {
		logger('The socket ' + socket.id + ' has been established');

		socket.on('location_update', function(data) {
			logger('[' + socket.id + '] Update:' + JSON.stringify(data, null, 4));
			socket.broadcast.emit('location_notification', data);
		})

		socket.on('disconnect', function() {
			logger('The socket ' + socket.id + ' has been established');			
		})
	})