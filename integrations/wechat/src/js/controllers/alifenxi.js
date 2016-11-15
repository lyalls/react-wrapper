//
// For this trivial demo we have just a unique Controller 
// for everything
//
WebApp.Instance.controller('AlifenxiController', function ($scope, $log, AlifenxiService) {
    $scope.initAli = function () {
        AlifenxiService.getConfig(function (data) {
            !function (a, b) {
                if (!b.__SV) {
                    var c, d, e, f;
                    window.dplus = b, b._i = [], b.init = function (a, c, d) {
                        function g(a, b) {
                            var c = b.split(".");
                            2 == c.length && (a = a[c[0]], b = c[1]), a[b] = function () {
                                a.push([b].concat(Array.prototype.slice.call(arguments, 0)))
                            }
                        }
                        var h = b;
                        for ("undefined" != typeof d?h = b[d] = []:d = "dplus", h.people = h.people || [], h.toString = function (a) {
                            var b = "dplus";
                            return"dplus" !== d && (b += "." + d), a || (b += " (stub)"), b
                        }, h.people.toString = function () {
                            return h.toString(1) + ".people (stub)"
                        }, e = "disable track track_pageview track_links track_forms register register_once alias unregister identify name_tag set_config get_distinct_id people.set people.set_unset people.delete_user".split(" "), f = 0; f < e.length; f++)
                            g(h, e[f]);
                        b._i.push([a, c, d])
                    }, b.__SV = 1.1,
                            c = a.createElement("script"),
                            c.type = "text/javascript",
                            c.charset = "utf-8", c.async = !0,
                            c.src = "//w.cnzz.com/dplus.php?token=" + data.aliOss,
                            d = a.getElementsByTagName("script")[0],
                            d.parentNode.insertBefore(c, d)
                }
            }(document, window.dplus || []),
                    dplus.init(data.aliOss);
            dplus.track("PV");
        }, function () {

        });
    };
});
