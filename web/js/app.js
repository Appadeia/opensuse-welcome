/*
** ANGULAR DEFINITIONS
*/

var bridge;

window.onload = function () {
    new QWebChannel(qt.webChannelTransport, function(channel) {
        bridge = channel.objects.bridge;
        angular.bootstrap(document, ['welcome']);
    });
}

var app = angular.module("welcome", ['lens.bridge', 'lens.ui']);

app.controller('WelcomeCtrl', function($scope) {
    $scope.system = {
      arch:       bridge.arch,
      distribution: {
        codename:   'n/a',
        desktop:    'n/a',
        version:    bridge.os,
        live:       true,
      }
    };

  $scope.autostart = false;

  $scope.isDE = function(desktop) {
    return $scope.system.distribution.desktop.toLowerCase() === desktop.toLowerCase();
  }

  $scope.openURI = function(uri) {
    bridge.openURL(uri);
  };

  $scope.command = function(cmd) {
    $scope.emit('command', cmd);
  };

  $scope.updateAutoStart = function() {
    $scope.emit('set-autostart', $scope.autostart);
  };

  $scope.close = function() {
    $scope.emit('close-request');
  };

  /* register for signals */
  $scope.$on('system-config', function(e, system) {
    $scope.system = system;
  });

  $scope.emit('get-system-config');
});
