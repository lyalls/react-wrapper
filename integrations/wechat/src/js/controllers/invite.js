// 邀请好友控制器

WebApp.Instance.controller('InviteController', function ($scope, $location, md5, $modal, notify, InviteService, $timeout, $cookies, $log) {
    $scope.allReward = 0;
    $scope.inviteCode = 0;
    $scope.rewardRank = null;
    $scope.receiveTotalReward = 0;
    $scope.waitTotalReward = 0;
    $scope.inviteList = null;
    // 如果是微信那么直接跳转链接
    $scope.isWeChat = WebApp.Terminal.platform.weChat;
    var activityUrl = '/activity/invite/index.html';
    $scope.inviteUrl = $location.protocol() + "://" + $location.host() + activityUrl;
    
    // share info 
    var title = '一次邀请，享两年奖励，邀好友奖现金啦！';
    var desc = '小伙伴，有钱一起赚。我邀请你，你邀请TA，我们去抱财赚钱花~';
    var img = 'http://image.baocai.com/data/mbaocai/images/activity/share.png';
    var img_title = '一次邀请，享两年奖励，邀好友奖现金啦！';
    var from = '抱财网';
    var to_app= "";
    // 初始化一些分享的信息
    var bLevel = { 
            qq: {forbid: 0, lower: 1, higher: 2},
            uc: {forbid: 0, allow: 1}
        };
    var UA = navigator.appVersion;
    var shareRes = false;
    var isqqBrowser = (UA.split("MQQBrowser/").length > 1) ? bLevel.qq.higher : bLevel.qq.forbid;
    var isucBrowser = (UA.split("UCBrowser/").length > 1) ? bLevel.uc.allow : bLevel.uc.forbid;
    var version_qq = "";
    if(isqqBrowser){
        var a = UA.split("MQQBrowser/")[1].split("."); 
        var version_qq = parseFloat(a[0] + "." + a[1]);
        var qApiSrc = {
            lower: "http://3gimg.qq.com/html5/js/qb.js",
            higher: "http://jsapi.qq.com/get?api=app.share"
        };
        var local_b = (version_qq < 5.4) ? qApiSrc.lower : qApiSrc.higher;
        var local_d = document.createElement("script");
        var local_a = document.getElementsByTagName("body")[0];
        local_d.setAttribute("src", local_b);
        local_a.appendChild(local_d);
    }
     
     // 初始化分享信息
    InviteService.inviteInfo(function (data) {
        $scope.inviteCode = data.invitationCode;
        $scope.allReward = data.userReward;
        $scope.rewardRank = data.rewardRank;
        $scope.receiveTotalReward = data.receiveTotalReward;
        $scope.waitTotalReward = data.waitTotalReward;
        // 拼接微信活动跳转链接
        $scope.inviteUrl = $scope.inviteUrl + "?invitationCode=" + data.invitationCode;
    }, function (data) {
        notify.closeAll();
        $cookies.put('login_url', WebApp.Router.INVITE);
        notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
        return;
    });

    // 邀请好友列表跳转函数
    $scope.getInviteList = function () {
        $timeout(function () {
            $location.path(WebApp.Router.INVITE_LIST);
        }, 0);
    };
    
    // 邀请好友列表
    $scope.initInviteList = function(){
        // TODO 
        InviteService.inviteList(function (data){
            if(data.list.length)
            {
                $scope.inviteList = data.list;
                $scope.inviteListShow = true;
            }
            else
            {
               $scope.inviteListShow = false; 
            }
        }, function (data) {
            notify.closeAll();
            $cookies.put('login_url', WebApp.Router.INVITE_LIST);
            notify({message: WebApp.dealHttp(data, $location, $timeout), duration: WebApp.duration});
            return;
        });
    };
    
    // 复制到剪切板
    $scope.inviteCopyFuc = function()
    {
        var clipboard = new Clipboard('.btn');
        clipboard.on('success', function(e) {
            notify.closeAll();
            notify({message: "成功复制", duration: WebApp.duration});
        });
        clipboard.on('error', function(e) {
            notify.closeAll();
            notify({message: "复制失败", duration: WebApp.duration});
        });
        WebApp.mInstance.close();
    };

    $scope.inviteShare = function(inviteCode){
        // uc浏览器分享
        if(isucBrowser)
        {
            shareRes = share2UCBrowser();
        }
        if(isqqBrowser)
        {
            shareRes = share2QQBrowser(isqqBrowser);
        }
        if(!shareRes)
        {
            // 复制链接
            inviteWarn();
        }
    };
    
    function share2UCBrowser()
    {
        if (typeof(ucweb) != "undefined") {
            ucweb.startRequest("shell.page_share", [title, desc, $scope.inviteUrl, to_app, '', "@" + from, '']);
        } else {
            if (typeof(ucbrowser) != "undefined") {
                ucbrowser.web_share(title, desc, $scope.inviteUrl, to_app, "", "@" + from, '');
            } else {
                return false;
            }
        }
        return true;
    };
    
    function share2QQBrowser(isqqBrowser)
    {
        var ah = {
            url: $scope.inviteUrl,
            title: title,
            description: desc,
            img_url: img,
            img_title: img_title,
            to_app: "",//微信好友1,腾讯微博2,QQ空间3,QQ好友4,生成二维码7,微信朋友圈8,啾啾分享9,复制网址10,分享到微博11,创意分享13
            cus_txt: "请输入此时此刻想要分享的内容"
        };
        var bLevel = { 
            qq: {forbid: 0, lower: 1, higher: 2},
            uc: {forbid: 0, allow: 1}
        };
        if (typeof(browser) != "undefined") {
            if (typeof(browser.app) != "undefined" && isqqBrowser == bLevel.qq.higher) {
                browser.app.share(ah)
            }
        } else {
            if (typeof(window.qb) != "undefined" && isqqBrowser == bLevel.qq.lower) {
                window.qb.share(ah)
            } else {
                return false;
            }
        }
        return true;
    };

    // 复制url地址弹窗
    function inviteWarn() {
         $scope.animationsEnabled = true;
         var modalInstance = $modal.open({
             animation: $scope.animationsEnabled,
             templateUrl: 'inviteUrlCopy',
             controller: 'ModalInstanceCtrl',
             resolve: {
                 items: function () {
                     return $scope.items;
                 }
             }
         });

         WebApp.mInstance = modalInstance;
         modalInstance.result.then(function (selectedItem) {
             $scope.selected = selectedItem;
         }, function () {
             $log.info('Modal dismissed at:' + new Date());
         });
     };
});
