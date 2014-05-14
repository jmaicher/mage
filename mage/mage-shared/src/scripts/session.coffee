"use strict"

module = angular.module('mage.session', ['mage.utils'])

module.service 'SessionService', (UUID) ->
  authenticable = undefined
  uuid = UUID.generate()

  setAuthenticable = (_authenticable) ->
    authenticable = _authenticable

  getAuthenticable = -> authenticable

  return {
    isAuthenticated: -> !!authenticable
    getUUID: -> uuid
    getAuthenticable: getAuthenticable
    getUser: getAuthenticable
    getDevice: getAuthenticable
    setAuthenticable: setAuthenticable
    setUser: setAuthenticable
    setDevice: setAuthenticable
  }

