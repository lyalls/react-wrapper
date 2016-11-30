var App = {};
$(function()
  {
  App.platform.init();
  $('#logbtn').click(function()
                     {
                     if(!App.platform.isApp)
                     {
                     return;
                     }
                     App.platform.exec("openLoginPage","http://www.baidu.com",function(res)
                                       {
                                       $('#spantxt').text("登录失败");
                                       });
                     });
  $('#showmsg').click(function()
                      {
                      App.platform.exec("showMsg","test");
                      });
  $('#image').click(function()
                    {
                    var cmd={};
                    cmd.index = 0;
                    cmd.list=["http://127.0.0.1:3000/image/none.png","http://127.0.0.1:3000/image/none.png","http://127.0.0.1:3000/image/none.png"];
                    App.platform.exec("showImage",cmd);
                    });
  $('#pop').click(function()
                  {
                  App.platform.exec("pop","test");
                  });
  $('#video').click(function()
                    {
                    var cmd = {};
                    cmd.url = "1212121212";
                    App.platform.exec("showVideo",cmd);
                    });
  $('#showdialog').click(function()
                         {
                         var cmd = {};
                         cmd.title = "提示";
                         cmd.message = "确定要投资吗";
                         cmd.buttons = ["取消","确定"];
                         App.platform.exec("showDialog",cmd,function(id)
                                           {
                                           alert(id);
                                           });
                         });
  $('#sharebtn').click(function()
                       {
                       var cmd = {};
                       cmd.title = "分享测试测试";
                       cmd.desc = "这是分享内容文字";
                       cmd.image = "https://km.support.apple.com/kb/image.jsp?productid=133333&size=120x120";
                       cmd.url = "http://www.baocai.com";
                       App.platform.exec("openShare",cmd,function(res)
                                         {
                                         if(res)
                                         {
                                         alert("分享成功！");
                                         }
                                         });
                       });
  });
