(function() {
  "use strict";
  var reactive;

  reactive = angular.module('mage.reactive', ['mage.hosts']);

  reactive.service('MageReactive', function($q, Hosts) {
    var connect, connected, emitter, on_connect, on_disconnect, on_error, on_message, socket;
    connected = false;
    socket = null;
    emitter = new Emitter;
    on_connect = function() {
      socket.on('message', on_message);
      return socket.on('disconnect', on_disconnect);
    };
    on_message = function(msg) {
      var payload, type;
      type = msg.type;
      payload = msg.payload;
      if (type) {
        return emitter.emit(type, payload);
      }
    };
    on_disconnect = function() {
      return console.warn("Disconnected from mage-reactive");
    };
    on_error = function() {
      return console.error("Could not establish connection to mage-reactive (" + Hosts.reactive + ")");
    };
    connect = function(uuid) {
      var dfd;
      dfd = $q.defer();
      socket = io.connect(Hosts.reactive, {
        query: 'uuid=' + uuid
      });
      socket.on('error', on_error);
      socket.on('connect', function() {
        on_connect();
        return dfd.resolve();
      });
      return dfd.promise;
    };
    return {
      connect: connect,
      on: function(ev, fn) {
        return emitter.on(ev, fn);
      },
      off: function(ev, fn) {
        return emitter.off(ev, fn);
      },
      once: function(ev, fn) {
        return emitter.once(ev, fn);
      }
    };
  });

}).call(this);

//# sourceMappingURL=reactive.js.map
