/// <reference path="E:\_Hoctap\_Project\_MyProjects\Git\CuteShop\CuteShop.Admin\Assets/libs/angular/angular.js" />

(function () {
    angular.module('cuteshop',
        ['cuteshop.products',
          'cuteshop.product_categories',
          'cuteshop.common'])
        .config(config);

    config.$inject = ['$stateProvider', '$urlRouterProvider', '$locationProvider'];

    function config($stateProvider, $urlRouterProvider, $locationProvider) {

        $stateProvider.state('home', {
            url: "/admin.html",
            templateUrl: "/app/components/home/homeView.html",
            controller:"homeController"
        });
        $urlRouterProvider.otherwise('/admin.html');
        $locationProvider.html5Mode(true);
    }
})();