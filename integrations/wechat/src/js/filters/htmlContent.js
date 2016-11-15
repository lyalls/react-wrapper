/**
 * @abstract 显示html文本
 * @author heguangyu
 */

WebApp.Instance.filter('htmlContent', ['$sce', function($sce) {
    return function (input)
    {
        return $sce.trustAsHtml(input);
    }
}]);

