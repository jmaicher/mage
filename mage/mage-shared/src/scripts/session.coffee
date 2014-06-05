"use strict"

module = angular.module('mage.session', ['mage.storage', 'mage.utils'])

module.service 'SessionService', (Storage, UUID) ->
  authenticable = undefined
  uuid = UUID.generate()

  # restore from session
  authenticable = Storage.get('session')

  setAuthenticable = (_authenticable) ->
    authenticable = _authenticable
    Storage.set('session', authenticable)

  getAuthenticable = -> authenticable

  logout = ->
    Storage.remove('session')
    authenticable = undefined

  getApiToken = ->

  getIdentity = ->
    return undefined if !authenticable
    return {
      id: getAuthenticable().id,
      type: "TODO"
    }

  return {
    isAuthenticated: -> !!authenticable
    getUUID: -> uuid
    getAuthenticable: getAuthenticable
    getUser: getAuthenticable
    getDevice: getAuthenticable
    getIdentity: getIdentity
    setAuthenticable: setAuthenticable
    setUser: setAuthenticable
    setDevice: setAuthenticable
    logout: logout
  }

