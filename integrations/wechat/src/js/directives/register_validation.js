//验证手机号
WebApp.Instance.directive('bcMobilePhone', function ($http) {
    return {
        require: 'ngModel',
        link: function (scope, element, attr, ngModel) {
            if (ngModel) {
                var mobilePhoneExp = /^(13|14|15|17|18)\d{9}$/;
            }
            var mobilePhoneValidator = function (value) {
                var validity = ngModel.$isEmpty(value) || mobilePhoneExp.test(value);
                ngModel.$setValidity("bcMobilePhone", validity);
                return validity ? value : undefined;
            };
            ngModel.$formatters.push(mobilePhoneValidator);
            ngModel.$parsers.push(mobilePhoneValidator);
        }
    };
});

//验证用户名
WebApp.Instance.directive('bcUserName', function ($http) {
    return {
        require: 'ngModel',
        link: function (scope, element, attr, ngModel) {
            if (ngModel) {
                //var userNameDigitExp = /^[A-Za-z0-9\u4E00-\u9FA5]{4,16}$/;
                var userNameDigitExp = /^.{4,16}$/;
                var userNameNumberExp = /^\d+$/;
                var userNameElementExp = /^[0-9a-zA-Z\u4E00-\u9FA5]+$/;
            }
            var userNameValidator = function (value) {
                var digit_validity = userNameDigitExp.test(value);
                var number_validity = userNameNumberExp.test(value);
                var content_validity = userNameElementExp.test(value);
                ngModel.$setValidity("bcDigit", true);
                ngModel.$setValidity("bcNumber", true);
                ngModel.$setValidity("bcContent", true);
                if (!digit_validity) {
                    ngModel.$setValidity("bcUserName", digit_validity);
                    ngModel.$setValidity("bcDigit", false);
                }
                if (digit_validity && number_validity) {
                    ngModel.$setValidity("bcUserName", number_validity);
                    ngModel.$setValidity("bcNumber", false);
                }
                if (digit_validity && !number_validity && !content_validity) {
                    ngModel.$setValidity("bcUserName", number_validity);
                    ngModel.$setValidity("bcContent", false);
                }
                return value;

            };
            ngModel.$formatters.push(userNameValidator);
            ngModel.$parsers.push(userNameValidator);
        }
    };
});

//验证密码
WebApp.Instance.directive('bcPassWord', function () {
    return {
        require: 'ngModel',
        link: function (scope, element, attr, ngModel) {
            if (ngModel) {
                //var userNameDigitExp = /^[A-Za-z0-9\u4E00-\u9FA5]{4,16}$/;
                var passwordDigitExp = /^.{6,16}$/;
                var passwordNumberExp = /^\d+$/;
                var passwordElementExp = /^[a-zA-Z]+$/;
                //var userNameElementExp=/^[\u4E00-\u9FA5]+$/;
            }
            var passwordValidator = function (value) {
                var digit_validity = passwordDigitExp.test(value);
                var number_validity = passwordNumberExp.test(value);
                var content_validity = passwordElementExp.test(value);
                ngModel.$setValidity("bcDigit", true);
                ngModel.$setValidity("bcNumber", true);
                ngModel.$setValidity("bcContent", true);
                if (!digit_validity) {
                    ngModel.$setValidity("bcPassWord", digit_validity);
                    ngModel.$setValidity("bcDigit", false);
                }
                if (number_validity) {
                    ngModel.$setValidity("bcPassWord", number_validity);
                    ngModel.$setValidity("bcNumber", false);
                }
                if (content_validity) {
                    ngModel.$setValidity("bcPassWord", number_validity);
                    ngModel.$setValidity("bcContent", false);
                }
                return  value;
            };
            ngModel.$formatters.push(passwordValidator);
            ngModel.$parsers.push(passwordValidator);
        }
    };
});

//验证真实姓名
WebApp.Instance.directive('bcRealName', function () {
    return {
        require: 'ngModel',
        link: function (scope, element, attr, ngModel) {
            if (ngModel) {
                var realNameExp = /^[\u4E00-\u9FA5]+$/;
            }
            var realNameValidator = function (value) {
                var validity = ngModel.$isEmpty(value) || realNameExp.test(value);
                ngModel.$setValidity("bcRealName", validity);
                return validity ? value : undefined;
            };
            ngModel.$formatters.push(realNameValidator);
            ngModel.$parsers.push(realNameValidator);
        }
    };
});

//验证身份证号
WebApp.Instance.directive('bcIdCard', function () {
    return {
        require: 'ngModel',
        link: function (scope, element, attr, ngModel) {
            if (ngModel) {
                //var idCardExp = /^.{18}$/;
                var idCardExp1 = /^[1-9]\d{7}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}$/;
                var idCardExp2 = /^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}(\d|X|x){1}$/;
            }
            var idCardValidator = function (value) {
                var validity = ngModel.$isEmpty(value) || idCardExp1.test(value) || idCardExp2.test(value);
                ngModel.$setValidity("bcIdCard", validity);
                return validity ? value : undefined;
            };
            ngModel.$formatters.push(idCardValidator);
            ngModel.$parsers.push(idCardValidator);
        }
    };
});

// 处理号码报错情况 
// https://docs.angularjs.org/error/ngModel/numfmt?p0=function%20()%7B%7D
WebApp.Instance.directive('stringToNumber', function() {
  return {
    require: 'ngModel',
    link: function(scope, element, attrs, ngModel) {
      ngModel.$parsers.push(function(value) {
        return '' + value;
      });
      ngModel.$formatters.push(function(value) {
        return parseFloat(value);
      });
    }
  };
});

