"use strict"

hosts = angular.module('mage.hosts', [])

hosts.service 'Hosts', ->
  this_host = window.location.host
  this_host_name = window.location.hostname
  this_host_port = window.location.port

  # subdomain.host:port vs. 127.0.0.1:port
  subdomains = isNaN(this_host_name.split('.')[0])

  if subdomains
    base_host = this_host.substr(this_host.indexOf('.') + 1)
  else # ip address
    base_host = this_host_name

  expand_base_host = (path_or_subdomain, port, options = {}) ->
    if subdomains && !options.path
      host = "#{path_or_subdomain}.#{base_host}"
    else if subdomains && options.path
      host = "#{base_host}/#{path_or_subdomain}"
    else # ip address
      base = "#{base_host}:#{port}"
      host = if options.path then "#{base}/#{path_or_subdomain}" else base

    return "http://#{host}"

  return {
    api: expand_base_host('api', 3000, path: true)
    reactive: expand_base_host('reactive', 9999, path: false)
  }

