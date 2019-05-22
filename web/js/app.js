/*
** ANGULAR DEFINITIONS
*/

var bridge;
var launcher;

window.onload = function () {
    new QWebChannel(qt.webChannelTransport, function(channel) {
        bridge = channel.objects.bridge;
        launcher = channel.objects.launcher;
        settings = channel.objects.settings;
        angular.bootstrap(document, ['welcome']);
        var deHelpElms = document.querySelectorAll(".de-help");
        console.log(deHelpElms);
        console.log(bridge.de);
        for (var i = 0; i < deHelpElms.length; i++) {
            var name = deHelpElms[i].getAttribute("data-de");
            console.log(name);
            if (name.toLowerCase().includes(bridge.de.toLowerCase())) {
                deHelpElms[i].classList.add("current");
            }
        }
    });
}

var app = angular.module("welcome", ['lens.bridge', 'lens.ui']);

app.controller('WelcomeCtrl', function($scope) {
    $scope.system = {
      arch:       bridge.arch,
      distribution: {
        codename:   'n/a',
        desktop:    bridge.de,
        version:    bridge.os,
        live:       true,
      }
    };

  $scope.autostart = false;

  $scope.isDE = function(desktop) {
    console.log("does " + bridge.de + " include " + desktop + "?");
    return bridge.de.toLowerCase().includes(desktop.toLowerCase());
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
