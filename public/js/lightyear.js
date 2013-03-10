// lightyear.js
// Collection of some scripts to drive the client

var socket;

$(document).ready( function() {
	setupSocketIO();
	registerHandlers();
});

function setupSocketIO(){
	socket = io.connect();
	socket.on('connect', function (data){
		console.log('Connected to server! Msg: ' + data.msg);
	});
}

function registerHandlers(){
	$('#openDoor').mousedown(handleButtonDown);
	$('#openDoor').mouseup(handleButtonUp);
}

function handleButtonDown(){
	socket.emit('button', { msg: "OPEN"}, function (data){
		console.log("Server ACK'd button message");
	});
}

function handleButtonUp(){
	socket.emit('button', { msg: "CLOSE"}, function (data){
		console.log("Server ACK'd button message");
	});
}