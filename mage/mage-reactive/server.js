var express = require('express'),
    app = express(),
    io = require('socket.io').listen(9999),
    logger = io.log

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

app.post(api_base + '/messages', function (req, res) {
  var id = req.params.id,
      // nsPath[#room]
      recipient = req.body.recipient,
      message = req.body.message,
      ns, matches;

  logger.info("Received POST /messages with the following request body:");
  logger.info(req.body);

  if (recipient && recipient.indexOf('/') === 0) {
    matches = recipient.split('#');
    ns = matches[0];
    room = matches[1];
    
    if (!room) {
      io.of(ns).emit('message', message);
      return res.send(200);
    } else {
      res.send(400, 'namespace#room is not implemented yet');
    }
  }

  res.send(400, 'For now, only namespaces are allowed as recipient');
});

app.listen(9000);


// -------------------------------------------------
// -- ws api ---------------------------------------
// -------------------------------------------------

io.configure(function () {
  io.set('transports', ['websocket']);

  io.set('authorization', function (handshake, callback) {
    var nsPath = handshake.query.ns,
        meeting;
  
    if(nsPath && isMeetingPath(nsPath)) {
      meeting = VirtualMeeting.findOrCreate(nsPath, io);
      meeting.authorize(handshake, callback);
      return; 
    } else {
      // Accept globally, can still be denied by ns auth (e.g /devices/auth)
      callback(null, true);
    }
  });
});


// -- /devices/auth ---------------------------------

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


// -- /activities ------------------------------

io.of('/activities').authorization(function (handshake, callback) {
  callback(null, true); 
});


// -- /updates ------------------------------

io.of('/updates').authorization(function (handshake, callback) {
  callback(null, true); 
});


// -- /meetings/:id --------------------------------

function matchMeetingPath(path) {
  return path.match('^\\/meetings\\/(\\d+)$');
}

function isMeetingPath(path) {
  return !!matchMeetingPath(path)
}

function parseMeetingId(path) {
  return matchMeetingPath(path)[1];
}

function VirtualMeeting(nsPath, io) {
  this.nsPath = nsPath;
  this.ns = undefined;

  this.createSocketNamespace(io);
}

// Holds all available virtual meetings
VirtualMeeting.meetings = {};

VirtualMeeting.findOrCreate = function (nsPath, io) {
  return VirtualMeeting.find(nsPath)
    || VirtualMeeting.create(nsPath, io);
}

VirtualMeeting.find = function (nsPath) {
  return VirtualMeeting.meetings[nsPath];
}

VirtualMeeting.create = function (nsPath, io) {
  var meeting = new VirtualMeeting(nsPath, io);
  VirtualMeeting.meetings[nsPath] = meeting;
  return meeting;
}

VirtualMeeting.prototype.authorize = function (handshake, callback) {
  var identity = handshake.query.identity;

  if(identity) {
    identity = JSON.parse(identity);
    io.log.info('Authorizing connection for ' + this.nsPath);
    io.log.info(identity);

    callback(null, true);
    return;
  }

  callback("Sorry dude, no can do!", false);
}

VirtualMeeting.prototype.createSocketNamespace = function (io) {
  var self = this;
   
  io.log.info('Creating new socket namespace: ' + this.nsPath);
  this.ns = io.of(this.nsPath);

  this.ns.on('connection', function (socket) {
   
    socket.on('broadcast', function(message) {
      io.log.info('Broadcasting message: ' + message);
      socket.broadcast.emit('message', message);
    });

  });
}

