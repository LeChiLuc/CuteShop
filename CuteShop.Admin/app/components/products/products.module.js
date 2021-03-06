﻿/// <reference path="E:\_Hoctap\_Project\_MyProjects\Git\CuteShop\CuteShop.Admin\Assets/libs/angular/angular.js" />

(function () {
    angular.module('cuteshop.products', ['cuteshop.common']).config(config);

    config.$inject = ['$stateProvider', '$urlRouterProvider'];

    function config($stateProvider, $urlRouterProvider) {

        $stateProvider
            .state('products', {
                url: "/products.html",
                parent: 'base',
                templateUrl: "/app/components/products/productListView.html",
                controller: "productListController"
            }).state('add_product', {
                url: "/add_product.html",
                parent: 'base',
                templateUrl: "/app/components/products/productAddView.html",
                controller: "productAddController"
            }).state('edit_product', {
                url: "/edit_product.html/:id",
                parent: 'base',
                templateUrl: "/app/components/products/productEditView.html",
                controller: "productEditController"
            });
        //$locationProvider.html5Mode(true);
    }
})();