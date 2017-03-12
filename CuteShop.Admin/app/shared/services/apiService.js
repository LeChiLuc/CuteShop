/// <reference path="E:\_Hoctap\_Project\_MyProjects\Git\CuteShop\CuteShop.Admin\Assets/libs/angular/angular.js" />

(function (app) {
    app.service('apiService', apiService);

    apiService.$inject = ['$http'];

    function apiService($http) {
        var serviceBase = 'http://localhost:63198/';
        return {
            get: get
        }
        function get(url, params, success, failure) {
            $http.get(serviceBase + url, params).then(function (result) {
                success(result);
            }, function (error) {
                failure(error);
            })
        }
    }
})(angular.module('cuteshop.common'));