//
//  UIViewController+WebView.h
//  BaoCai
//
//  Created by 刘国龙 on 16/8/1.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "InviteFriendsModel.h"

#import <MWPhotoBrowser/MWPhotoBrowser.h>

@interface UIViewController (WebView) <MWPhotoBrowserDelegate> 

@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) UILabel *titleLabel;

- (NSMutableURLRequest *)getWebBrowserRequestWithUrl:(NSString *)url;

- (BOOL)handelWebBrowserJsonMethod:(NSString *)url;

- (BOOL)handelWebBrowserJsonMethod:(NSString *)url inviteFriendsModel:(InviteFriendsModel *)inviteFriendsModel;

- (NSString *) webPath;

@end
