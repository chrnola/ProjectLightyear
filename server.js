var express = require('express')
	, app = express()
	, server = require('http').createServer(app)
	, io = require('socket.io').listen(server)
	, gpio = require('pi-gpio');
	
app.use(express.static(__dirname + '/public'));

server.listen(80);

app.get('/', function (req, res) {
	res.sendfile(__dirname + '\\public\\index.html');
});

io.sockets.on('connection', function (socket) {
	console.log("Greeting client...");
	
	socket.emit('connect', { msg: 'hello, client!' }, function (data){
		console.log("Client ACK'd connection!");
	});
	
	socket.on('button', function (data) {
		console.log('client hit button!!!! ' + data.msg);
	});
});