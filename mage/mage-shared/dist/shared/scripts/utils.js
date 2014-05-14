(function() {
  "use strict";
  var utils;

  utils = angular.module('mage.utils', []);

  utils.service('UUID', function() {
    var guid;
    guid = (function() {
      var s4;
      s4 = function() {
        return Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1);
      };
      return function() {
        return s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4();
      };
    })();
    return {
      generate: guid
    };
  });

}).call(this);

//# sourceMappingURL=utils.js.map
