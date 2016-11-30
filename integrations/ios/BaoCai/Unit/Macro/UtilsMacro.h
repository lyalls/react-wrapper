//
//  UtilsMacro.h
//  BaoCai
//
//  Created by 刘国龙 on 16/5/30.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import <AdSupport/AdSupport.h>

#ifndef UtilsMacro_h
#define UtilsMacro_h

#define BlueColor RGB_COLOR(62, 163, 255)

#define BackViewColor RGB_COLOR(242, 242, 242)

#define OrangeColor RGB_COLOR(255, 108, 0)

#define Color666666 RGB_COLOR(102, 102, 102)
#define Color999999 RGB_COLOR(153, 153, 153)

#define PI 3.14159265358979323846

#define PageMaxCount 20

#define IDFA [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]

//获取设备屏幕尺寸
#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define kScreen_Height [UIScreen mainScreen].bounds.size.height

#endif /* UtilsMacro_h */
