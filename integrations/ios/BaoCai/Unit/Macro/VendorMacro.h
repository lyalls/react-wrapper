//
//  VendorMacro.h
//  BaoCai
//
//  Created by 刘国龙 on 16/5/30.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#ifndef VendorMacro_h
#define VendorMacro_h

#if DEBUG
#define UMENGKEY             @"579f3d06e0f55afa6d0011c4"
#else
#define UMENGKEY             @"57917f2367e58ebd5f002c8a"
#endif

#define WECHATAPPID          @"wxe25adb4fadb74dd5"
#define WECHATAPPSECRET      @""

#define QQAPPID              @"1104104490"
#define QQAPPKEY             @"LOZFSIZk3Gibpna4"

#define SINAWEIBOAPPKEY      @"1483111062"
#define SINAWEIBOSECRET      @"8c06f11363a9e1d1747137613055bb57"
#define SINAWEIBOREDIRECTURL @"http://www.baocai.com"

#if DEBUG
#define CustomServiceAppKey @"baocaiwang#baocaitest"
#define CustomServiceAPNsCertName @"baocai_developer"
#define CustomServiceSessionID @"BaoCaiTest"
#else
#define CustomServiceAppKey @"baocaiwang#baocai"
#define CustomServiceAPNsCertName @"baocai_production"
#define CustomServiceSessionID @"BaoCai"
#endif

#endif /* VendorMacro_h */
