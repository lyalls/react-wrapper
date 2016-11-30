//
//  UIWebBrowserViewController.h
//  BaoCai
//
//  Created by 刘国龙 on 16/5/27.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "InviteFriendsModel.h"

@interface UIWebBrowserViewController : UIViewController

@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) InviteFriendsModel *inviteFirends;

@end
