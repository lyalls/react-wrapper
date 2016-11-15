//
// `$drag` example: drag to dismiss
//
WebApp.Instance.directive('financingDetail', ['$log', '$http', '$templateCache', '$compile', '$parse', function ($log, $http, $templateCache, $compile, $parse) {
        return {
            restrict: 'E',
            templateUrl: function (elem, attr) {
                return 'financing_' + attr.type + '.html';
            },
            replace: true

        };
    }]);



