angular.module('calendarApp', ['ngResource', 'ngRoute', 'ngGrid', 'ui.bootstrap', 'daypilot'])
    .constant('urls', {
      BASE_URL: 'http://localhost:7070/api/v1/'
    })
    .config(['$routeProvider', '$httpProvider', function($routeProvider, $httpProvider) {
      $routeProvider
        .when("/", {
          templateUrl: "Calendar.html",
          controller: "calendarCtrl",
          controllerAs: "calCtrl"
        })        
        .otherwise({
          redirectTo: "/"
        });
      $httpProvider.defaults.headers.post['Content-Type'] = 'application/json';
    }]);