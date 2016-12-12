if(App == null)
{
    var App = {};
}
App.GetDeviceVersion = function () {
    var userAgent = navigator.userAgent;
    var ver = {};
    var index = userAgent.indexOf("iPhone OS");
    if (index > 0) {
        ver.OS = "IOS";
        ver.version = userAgent.substring(index + 10, index + 11);
    }
    else {
        index = userAgent.indexOf("Android")
        if (index > 0) {
            ver.OS = "Android";
            ver.version = parseFloat(userAgent.slice(index + 8));
        }
    }
    
    return ver;
    
};
App.platform =
{
	callbackId:0,
    msg:[],
    execIframe:null,
    isApp : false,
    init:function(callback)
    {
        var userAgent = navigator.userAgent;
        var ver = {};
        var index = userAgent.indexOf("BaoCaiApp");
        if (index <= 0)
        {
            return;
        }
        App.platform.isApp = true;
 
       App.platform.exec("AppInit",null,callback)
    },
    fetchMessage:function()
    {
       if (this.timer) {
         clearTimeout(this.timer);
         this.timer = 0;
       }
       // Each entry in commandQueue is a JSON string already.
       if (!this.msg.length) {
       return '';
       }
       var json = '[' + this.msg.join(',') + ']';
       this.msg.length = 0;
       return json;
    },
    callback:function(callbackId,param)
    {
       if(callbackId != '' && callbackId != null)
       {
           var fun = App.platform[callbackId];
           var pa = param;
           if(param && typeof param === 'string'){
             try{
                pa = JSON.parse(param);
             }catch(e){
                pa = param;
             }
           }
           setTimeout(function()
           {
             fun(pa);
             fun = null;
           });
           delete App.platform[callbackId];
       }
   
    },
    pushMessage:function(msg)
    {
       if(typeof msg !== 'string')
       {
          msg = JSON.stringify(msg)
       }
       this.msg.push(msg);
    },
    timeout:function(callback,time)
    {
        if(time == null)
        {
          time = 0;
        }
        return setTimeout(callback,time);
    },
    titleChanged:function()
    {
      this.exec("titleChanged");
    },
    pageLoad:function(callback)
    {
      this.exec("page_Load",null,callback);
    },
    exec:function(action,params,callback)
        {
          var callbackId = null;
          if(callback)
          {
              callbackId = 'callback' + this.callbackId++;
              App.platform[callbackId] = callback;
          }
          this.pushMessage([action,params,callbackId]);
          switch(App.GetDeviceVersion().OS)
          {
            case 'IOS':
                this.IOSCall();
                break;
            case 'Android':
                this.AndroidCall();
                break;
           default:
                break;
          }
        },
      	//调用ios
      	IOSCall:function()
      	{
              if (this.execIframe && this.execIframe.contentWindow) {
                    this.execIframe.contentWindow.location = 'jscall://ready';
              } else {
              this.execIframe = document.createElement('iframe');
              this.execIframe.style.display = 'none';
              this.execIframe.src = 'jscall://ready';
              document.body.appendChild(this.execIframe);
            }
           var that = this;
            this.timer = this.timeout(function()
              {
                if(that.msg.length)
                {
                  that.IOSCall();
                }
              },50);

      	},
      	//调用Android
      	AndroidCall:function()
      	{
            var msg = this.fetchMessage();
            //调用安卓系统
            if(window.baocaijs && window.baocaijs.call)
            {
                window.baocaijs.call(msg);
            }
      	}
}