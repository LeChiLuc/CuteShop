/// <reference path="E:\_Hoctap\_Project\_MyProjects\Git\CuteShop\CuteShop.Admin\Assets/libs/angular/angular.js" />

(function (app) {
    app.service('apiService', apiService);

    apiService.$inject = ['$http','notificationService'];

    function apiService($http, notificationService) {
        var serviceBase = 'http://localhost:63198/';
        return {
            get: get,
            post: post,
            put: put,
            del: del
        }

        function del(url, data, success, failure) {
            $http.delete(serviceBase + url, data).then(function (result) {
                success(result);
            }, function (error) {
                if (error.status === 401) {
                    notificationService.displayError('Authenticate is required.');
                }
                else if (failure != null) {
                    failure(error);
                }

            });
        }

        function post(url, data, success, failure) {
            $http.post(serviceBase + url, data).then(function (result) {
                success(result);
            }, function (error) {
                if (error.status === 401) {
                    notificationService.displayError('Authenticate is required.');
                }
                else if (failure != null) {
                    failure(error);
                }
                
            });
        }

        function get(url, params, success, failure) {
            $http.get(serviceBase + url, params).then(function (result) {
                success(result);
            }, function (error) {
                failure(error);
            })
        }

        function put(url, data, success, failure) {
            $http.put(serviceBase + url, data).then(function (result) {
                success(result);
            }, function (error) {
                if (error.status === 401) {
                    notificationService.displayError('Authenticate is required.');
                }
                else if (failure != null) {
                    failure(error);
                }

            });
        }
    }
})(angular.module('cuteshop.common'));