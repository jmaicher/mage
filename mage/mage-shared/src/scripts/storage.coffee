"use strict"

module = angular.module('mage.storage', [])

module.provider 'Storage', ->
  prefix = undefined

  @initialize = (_prefix) ->
    prefix = _prefix

  prefixed = (key) -> "#{prefix}-#{key}"

  get = (key) ->
    value = localStorage.getItem prefixed(key)
    try
      JSON.parse(value)
    catch e
      value

  set = (key, value) ->
    localStorage.setItem prefixed(key), JSON.stringify(value)

  remove = (key) ->
    localStorage.removeItem prefixed(key)

  @$get = ->
    get: get,
    set: set,
    remove: remove
  # this.$get

  return @
