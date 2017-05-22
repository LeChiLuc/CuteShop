(function (app) {
    app.controller('productAddController', productAddController);

    productAddController.$inject = ['$scope', 'apiService', 'notificationService', '$state', 'commonService'];

    function productAddController($scope, apiService, notificationService, $state, commonService) {
        $scope.product = {
            CreatedDate: new Date(),
            Status: true
        }
        $scope.flatFolders = [];
        $scope.categories = [];
        $scope.ckeditorOptions = {
            language: 'vi',
            height: '200px',
            uiColor: '#AADC6E',
            allowedContent: true,
            entities: false,
        }
        $scope.AddProduct = AddProduct;
        $scope.getListProductCategories = getListProductCategories;
        $scope.GetSeoTitle = GetSeoTitle;

        function GetSeoTitle() {
            $scope.product.Alias = commonService.getSeoTitle($scope.product.Name);
        }

        function AddProduct() {
            $scope.product.MoreImages = JSON.stringify($scope.moreImages)
            apiService.post('api/product/create', $scope.product,
                function (result) {
                    notificationService.displaySuccess(result.data.Name + ' đã được thêm mới.');
                    $state.go('products');
                }, function (error) {
                    notificationService.displayError('Thêm mới không thành công.')
                });
        }

        function getListProductCategories() {
            apiService.get('api/productcategory/getallparents', null, function (result) {
                //$scope.productCategories = result.data;
                $scope.categories = commonService.getTree(result.data, 'ID', 'ParentID');
                $scope.categories.forEach(function (item) {
                    recur(item, 0, $scope.flatFolders);
                });
            }, function (error) {
                console.log('Get product category failed');
            })
        }
        $scope.ChooseImage = function () {
            var finder = new CKFinder();
            finder.selectActionFunction = function (fileUrl) {
                $scope.$apply(function () {
                    $scope.product.Image = fileUrl;
                })                
            }
            finder.popup();
        }
        $scope.moreImages = [];
        $scope.ChooseMoreImage = function () {
            var finder = new CKFinder();
            finder.selectActionFunction = function (fileUrl) {
                $scope.$apply(function () {
                    $scope.moreImages.push(fileUrl);
                })        
            }
            finder.popup();
        }
        function times(n, str) {
            var result = '';
            for (var i = 0; i < n; i++) {
                result += str;
            }
            return result;
        };
        function recur(item, level, arr) {
            arr.push({
                Name: times(level, '–') + ' ' + item.Name,
                ID: item.ID,
                Level: level,
                Indent: times(level, '–')
            });

            if (item.children) {
                item.children.forEach(function (item) {
                    recur(item, level + 1, arr);
                });
            }
        };

        getListProductCategories();
    }

})(angular.module('cuteshop.products'));