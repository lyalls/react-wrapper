//
//  UIStartAdvertViewController.h
//  BaoCai
//
//  Created by 刘国龙 on 16/7/21.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIStartAdvertViewControllerDelegate;

@interface UIStartAdvertViewController : UIViewController

@property (nonatomic, assign) id<UIStartAdvertViewControllerDelegate> delegate;

@end

@protocol UIStartAdvertViewControllerDelegate <NSObject>

- (void)startAdvertOpenUrl:(NSString *)url;

@end
