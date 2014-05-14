"use strict"

utils = angular.module('mage.utils', [])

utils.service 'UUID', ->
  
  guid = (->
    s4 = ->
      return Math.floor((1 + Math.random()) * 0x10000)
        .toString(16)
        .substring(1)

    return ->
      return s4() + s4() + '-' + s4() + '-' + s4() + '-' +
             s4() + '-' + s4() + s4() + s4()
  )()

  return {
    generate: guid
  }

