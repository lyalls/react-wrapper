//
//  UIPhotoBrowserViewController.h
//  BaoCai
//
//  Created by lishuo on 16/10/9.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPhotoBrowserViewController : UIViewController

@property (nonatomic,assign) NSInteger currentIndex;
@property (nonatomic,strong) NSMutableArray *imageArray;
@end
