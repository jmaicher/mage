"use strict"

reactive = angular.module('mage.reactive', ['mage.hosts'])

reactive.service 'MageReactive', ($q, Hosts) ->
  connected = false
  socket = null
  emitter = new Emitter

  on_connect = ->
    socket.on 'message', on_message
    socket.on 'disconnect', on_disconnect

  on_message = (msg) ->
    type = msg.type
    payload = msg.payload

    if(type)
      emitter.emit type, payload

  on_disconnect = ->
    console.warn "Disconnected from mage-reactive"

  on_error = ->
    console.error "Could not establish connection to mage-reactive (#{Hosts.reactive})"

  connect = (uuid) ->
    dfd = $q.defer()
    socket = io.connect(Hosts.reactive, {
      query: 'uuid=' + uuid
    })

    socket.on 'error', on_error
    socket.on 'connect', ->
      on_connect()
      dfd.resolve()

    dfd.promise


  return {
    connect: connect
    on: (ev, fn) -> emitter.on(ev, fn)
    off: (ev, fn) -> emitter.off(ev, fn)
    once: (ev, fn) -> emitter.once(ev, fn)
  }

