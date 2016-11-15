/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

WebApp.Config.mapiUrl = 'https://mapi.baocai.com';

// 跨域信息
angular.element(window).bind('load', function (e) {
    angular.element(document.querySelector('#crossmessage'));
});

// 消息回调
angular.element(window).bind("message", function (e) {
    var message = JSON.parse(e.originalEvent.data);
});

