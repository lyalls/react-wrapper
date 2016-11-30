//
//  AppMacro.h
//  BaoCai
//
//  Created by 刘国龙 on 16/5/30.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h
//#if DEBUG
//#define kServerAddress @"https://api.baocai.com/v2/"
//#else
#define kServerAddress @"https://mapi.baocai.com/v2/"
//#endif

#define VERSION [NSString stringWithFormat:@"ios_baocai_%@", [[[NSBundle mainBundle] infoDictionary] stringForKey:@"CFBundleShortVersionString"]]

#define SHORTVERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

//服务器接口路径

#define WEBUPDATE @"h5/update"

#endif /* AppMacro_h */
