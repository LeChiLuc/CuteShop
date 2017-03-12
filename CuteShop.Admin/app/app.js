﻿/// <reference path="E:\_Hoctap\_Project\_MyProjects\Git\CuteShop\CuteShop.Admin\Assets/libs/angular/angular.js" />

(function () {
    angular.module('cuteshop',
        ['cuteshop.products',
          'cuteshop.product_categories',
          'cuteshop.common'])
        .config(config);

    config.$inject = ['$stateProvider', '$urlRouterProvider'];

    function config($stateProvider, $urlRouterProvider) {
        $stateProvider.state('home', {
            url: "/admin",
            templateUrl: "/app/components/home/homeView.html",
            controller:"homeController"
        });
        $urlRouterProvider.otherwise('/admin');
    }
})();