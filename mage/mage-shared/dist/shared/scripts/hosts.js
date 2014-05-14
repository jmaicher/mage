(function() {
  "use strict";
  var hosts;

  hosts = angular.module('mage.hosts', []);

  hosts.service('Hosts', function() {
    var base_host, expand_base_host, subdomains, this_host, this_host_name, this_host_port;
    this_host = window.location.host;
    this_host_name = window.location.hostname;
    this_host_port = window.location.port;
    subdomains = isNaN(this_host_name.split('.')[0]);
    if (subdomains) {
      base_host = this_host.substr(this_host.indexOf('.') + 1);
    } else {
      base_host = this_host_name;
    }
    expand_base_host = function(path_or_subdomain, port, options) {
      var base, host;
      if (options == null) {
        options = {};
      }
      if (subdomains && !options.path) {
        host = "" + path_or_subdomain + "." + base_host;
      } else if (subdomains && options.path) {
        host = "" + base_host + "/" + path_or_subdomain;
      } else {
        base = "" + base_host + ":" + port;
        host = options.path ? "" + base + "/" + path_or_subdomain : base;
      }
      return "http://" + host;
    };
    return {
      api: expand_base_host('api', 3000, {
        path: true
      }),
      reactive: expand_base_host('reactive', 9999, {
        path: false
      })
    };
  });

}).call(this);

//# sourceMappingURL=hosts.js.map
