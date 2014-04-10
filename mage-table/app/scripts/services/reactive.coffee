"use strict"

services = angular.module('mage.services')

services.provider 'MageReactive', ->
  url = null

  @setUrl = (_url) -> url = _url

  @$get = ["$q", ($q) ->
    connected = false
    sock = null

    onmessage = (msg) ->
      console.log msg
    onclose = ->
      console.warn "Disconnected from MageReactive"

    connect = ->
      dfd = $q.defer()
      sock = new SockJS url
      sock.onopen = ->
        console.log "Connected to MageReactive"
        sock.onmessage = onmessage
        sock.onclose = onclose
        dfd.resolve()

      sock.onclose = ->
        console.warn "Could not establish connection to MageReactive (#{url})"
        dfd.reject()

      dfd.promise

    publish = (message) ->
      sock.send JSON.stringify(message)

    return {
      connect: connect
      publish: publish
    }

  ]

  return

