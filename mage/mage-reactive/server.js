var express = require('express'),
    app = express(),
    io = require('socket.io').listen(9999);

// -- global state ---------------------------------

// uuid -> socket
var uuidMap = {};


// -- http api -------------------------------------

var bodyParser = require('body-parser');
app.use(bodyParser());

var api_base = '/api'

app.post(api_base + '/devices/sessions/confirm', function (req, res) {
  var uuid = req.body.uuid,
      authenticable = req.body.authenticable,
      socket = uuidMap[uuid];

  if(socket) {
    socket.emit('message', {
      type: 'device.authenticated',
      payload: authenticable
    });

    res.send(200);
  } else {
    res.send(400, 'UUID not found');
  }


});

app.listen(9000);


// -------------------------------------------------
// -- ws api ---------------------------------------
// -------------------------------------------------

// -- /device/auth ---------------------------------

io.of('/devices/auth').authorization(function (handshake, callback) {
  uuid = handshake.query.uuid;
  if (uuid) {
    handshake.uuid = uuid;
    callback(null, true);
  } else {
    callback("No uuid provided", false);
  }
});

io.of('/devices/auth').on('connection', function (socket) {
  uuidMap[socket.handshake.uuid] = socket;
  io.log.info('New device connected: ' + socket.handshake.uuid);
  socket.on('disconnect', function(){
    io.log.info('Device disconnected: ' + socket.handshake.uuid);
    delete uuidMap[socket.handshake.uuid];
  });
});



io.configure(function () {
  io.set('transports', ['websocket']);

  io.set('authorization', function (handshake, callback) {
    callback(null, true);
  });
});



