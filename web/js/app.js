/*
** ANGULAR DEFINITIONS
*/

var bridge;
var launcher;
var enabler;

function updateAutoStart() {
    console.log("yeet");
    if (enabler.autostartEnabled()) {
        enabler.disableAutostart();
        console.log("is disabled");
    } else {
        enabler.enableAutostart();
        console.log("is enabled");
    }
}

window.onload = function () {
    new QWebChannel(qt.webChannelTransport, function(channel) {
        bridge = channel.objects.bridge;
        launcher = channel.objects.launcher;
        enabler = channel.objects.enabler;

        if (enabler.autostartEnabled()) {
            document.getElementById("autostart").checked = true;
        } else {
            document.getElementById("autostart").checked = false;
        }

        angular.bootstrap(document, ['welcome']);
        var deHelpElms = document.querySelectorAll(".de-help");
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

  $scope.close = function() {
    $scope.emit('close-request');
  };

  /* register for signals */
  $scope.$on('system-config', function(e, system) {
    $scope.system = system;
  });

  $scope.emit('get-system-config');
});
