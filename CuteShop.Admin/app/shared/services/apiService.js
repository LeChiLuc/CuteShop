/// <reference path="E:\_Hoctap\_Project\_MyProjects\Git\CuteShop\CuteShop.Admin\Assets/libs/angular/angular.js" />

(function (app) {
    app.service('apiService', apiService);

    apiService.$inject = ['$http', 'notificationService', 'authenticationService'];

    function apiService($http, notificationService, authenticationService) {
        var serviceBase = 'http://localhost:63198/';
        return {
            get: get,
            post: post,
            put: put,
            del: del
        }

        function del(url, data, success, failure) {
            authenticationService.setHeader();
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
            authenticationService.setHeader();
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
            authenticationService.setHeader();
            $http.get(serviceBase + url, params).then(function (result) {
                success(result);
            }, function (error) {
                failure(error);
            })
        }

        function put(url, data, success, failure) {
            authenticationService.setHeader();
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