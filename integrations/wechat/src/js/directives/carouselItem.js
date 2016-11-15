//
// `$drag` example: drag to dismiss
//
WebApp.Instance.directive('carouselItem', function ($drag) {
    return {
        restrict: 'C',
        require: '^carousel',
        scope: {},
        transclude: true,
        template: '<div class="item"><div ng-transclude></div></div>',
        link: function (scope, elem, attrs, carousel) {
            scope.carousel = carousel;
            var id = carousel.addItem();

            var zIndex = function () {
                var res = 0;
                if (id == carousel.activeItem) {
                    res = 2000;
                } else if (carousel.activeItem < id) {
                    res = 2000 - (id - carousel.activeItem);
                } else {
                    res = 2000 - (carousel.itemCount - 1 - carousel.activeItem + id);
                }
                return res;
            };

            scope.$watch(function () {
                return carousel.activeItem;
            }, function (n, o) {
                elem[0].style['z-index'] = zIndex();
            });


            $drag.bind(elem, {
                constraint: {minY: 0, maxY: 0},
                adaptTransform: function (t, dx, dy, x, y, x0, y0) {
                    var maxAngle = 15;
                    var velocity = 0.02;
                    var r = t.getRotation();
                    var newRot = r + Math.round(dx * velocity);
                    newRot = Math.min(newRot, maxAngle);
                    newRot = Math.max(newRot, -maxAngle);
                    t.rotate(-r);
                    t.rotate(newRot);
                },
                move: function (c) {
                    if (c.left >= c.width / 4 || c.left <= -(c.width / 4)) {
                        elem.addClass('dismiss');
                    } else {
                        elem.removeClass('dismiss');
                    }
                },
                cancel: function () {
                    elem.removeClass('dismiss');
                },
                end: function (c, undo, reset) {
                    elem.removeClass('dismiss');
                    if (c.left >= c.width / 4) {
                        scope.$apply(function () {
                            carousel.next();
                        });
                    } else if (c.left <= -(c.width / 4)) {
                        scope.$apply(function () {
                            carousel.next();
                        });
                    }
                    reset();
                }
            });
        }
    };
});