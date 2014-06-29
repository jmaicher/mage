"use strict"

module = angular.module('mage.reactive_updates', ['mage.reactive'])

module.service 'ReactiveUpdates', (MageReactive) ->
  emitter = new EventEmitter()


  MageReactive.connect("/updates").then (conn) ->
    conn.on "backlog_item", (model) ->
      emitter.emit "backlog_item", model
   
  return emitter

