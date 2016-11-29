//
//  UIViewController+WebView.m
//  BaoCai
//
//  Created by 刘国龙 on 16/8/1.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "UIViewController+WebView.h"

#import <objc/runtime.h>
#import "DeviceUtils.h"
#import "UIShareViewController.h"
#import "UIPlayViewController.h"


static const void *ImageArrayBlockKey = &ImageArrayBlockKey;

static const void *TitleLabelBlockKey = &TitleLabelBlockKey;

@implementation UIViewController (WebView)

- (void)setImageArray:(NSMutableArray *)imageArray {
    objc_setAssociatedObject(self, ImageArrayBlockKey, imageArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)imageArray {
    return objc_getAssociatedObject(self, ImageArrayBlockKey);
}

-(void)setTitleLabel:(UILabel *)titleLabel
{
    objc_setAssociatedObject(self, TitleLabelBlockKey, titleLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UILabel *)titleLabel
{
    return objc_getAssociatedObject(self, TitleLabelBlockKey);
}
-(NSString*) webPath
{
    return [NSString stringWithFormat:@"%@%@",[DeviceUtils documentsPath],@"www/"];
}

- (NSMutableURLRequest *)getWebBrowserRequestWithUrl:(NSString *)url {
    if ([url rangeOfString:@"views"].location != NSNotFound) {
        if ([url rangeOfString:@"?"].location == NSNotFound) {
            url = [NSString stringWithFormat:@"%@?t=%f", url, [NSDate timeIntervalSinceReferenceDate]];
        } else {
            url = [NSString stringWithFormat:@"%@&t=%f", url, [NSDate timeIntervalSinceReferenceDate]];
        }
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url toURL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    [request setValue:@"3" forHTTPHeaderField:@"X-Authorization-From"];
    [request setValue:SHORTVERSION forHTTPHeaderField:@"X-Authorization-Version"];
    if ([UserDefaultsHelper sharedManager].userInfo)
        [request setValue:[UserInfoModel sharedModel].token forHTTPHeaderField:@"X-Authorization"];
    
    return request;
}

- (BOOL)handelWebBrowserJsonMethod:(NSString *)url {
    return [self handelWebBrowserJsonMethod:url inviteFriendsModel:nil];
}

- (BOOL)handelWebBrowserJsonMethod:(NSString *)url inviteFriendsModel:(InviteFriendsModel *)inviteFriendsModel {
    NSString *webUrl = [url decodeString];
    NSRange range = [webUrl rangeOfString:@"baocaiAction="];
    if (range.length > 0) {
        webUrl = [webUrl stringByReplacingOccurrencesOfString:@"\r\n" withString:@"%5cr%5cn"];
        NSString *jsonStr = [webUrl substringFromIndex:(range.location + range.length)];
        [self handleJsonMethod:jsonStr inviteFriendsModel:inviteFriendsModel];
        
        return NO;
    }
    return YES;
}

- (void)handleJsonMethod:(NSString *)jsonStr inviteFriendsModel:(InviteFriendsModel *)inviteFriendsModel {
    NSDictionary *dic = [jsonStr objectFromJSONString];
    if (dic) {
        NSString *type = [dic objectForKey:@"type"];
        if ([type isEqualToString:@"alert"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[dic objectForKey:@"title"] message:[dic objectForKey:@"message"] delegate:nil cancelButtonTitle:[dic objectForKey:@"buttonName"] otherButtonTitles:nil, nil];
            [alertView show];
        }
        if ([type isEqualToString:@"toast"]) {
            SHOWTOAST([dic objectForKey:@"message"]);
        }
        if ([type isEqualToString:@"close"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        if ([type isEqualToString:@"share"]) {
            UIShareViewController *view = [self getControllerByMainStoryWithIdentifier:@"UIShareViewController"];
            if (inviteFriendsModel) {
                view.shareTitle = inviteFriendsModel.invitationTitle;
                view.shareDesc = inviteFriendsModel.invitationDesc;
                view.shareUrl = inviteFriendsModel.invitationUrl;
                view.shareImageUrl = inviteFriendsModel.invitationImageUrl;
            } else {
                view.shareTitle = [dic objectForKey:@"title"];
                view.shareDesc = [dic objectForKey:@"desc"];
                view.shareUrl = [dic objectForKey:@"url"];
                view.shareImageUrl = [dic objectForKey:@"imageUrl"];
            }
            [self presentTranslucentViewController:view animated:YES];
        }
        if ([type isEqualToString:@"tel"]) {
            NSString *deviceType = [UIDevice currentDevice].model;
            
            if ([deviceType isEqualToString:@"iPod touch"] || [deviceType isEqualToString:@"iPad"] || [deviceType isEqualToString:@"iPhone Simulator"]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的设备不能打电话" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                [alert show];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[[dic objectForKey:@"message"] stringByReplacingOccurrencesOfString:@"%5cr%5cn" withString:@"\r\n"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫", nil];
                [alert show];
                [alert clickedButtonEvent:^(NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        [[UIApplication sharedApplication] openURL:[[NSString stringWithFormat:@"tel://%@", [dic objectForKey:@"tel"]] toURL]];
                    }
                }];
            }
        }
        if ([type isEqualToString:@"showImageBrowser"]) {
            NSArray *array = [dic objectForKey:@"imageArray"];
            
           self.imageArray = [NSMutableArray arrayWithCapacity:0];
            
            for (NSString *object in array) {
                MWPhoto *photo = [MWPhoto photoWithURL:[object toURL]];
                [self.imageArray addObject:photo];
            }

//            array = [dic objectForKey:@"titles"];
//            
//            for (NSInteger i = 0; i < array.count;i++) {
//                MWPhoto *photo = [self.imageArray objectAtIndex:i];
//                photo.caption = [array objectAtIndex:i];
//            }
             NSInteger currentIndex = [dic integerForKey:@"index"];
            
            
            MWPhotoBrowser *photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
            photoBrowser.displayActionButton = NO;
            photoBrowser.displayNavArrows = NO;
            photoBrowser.displaySelectionButtons = NO;
            photoBrowser.alwaysShowControls = NO;
            photoBrowser.zoomPhotosToFill = YES;
            photoBrowser.enableGrid = NO;
            photoBrowser.startOnGrid = NO;
            photoBrowser.enableSwipeToDismiss = NO;
            
            [photoBrowser setCurrentPhotoIndex:currentIndex];
            [self.navigationController pushViewController:photoBrowser animated:YES];
            
//            self.titleLabel = [[UILabel alloc] init];
//            self.titleLabel.frame = CGRectMake(0, 64, Screen_width, 20);
//            self.titleLabel.alpha = 0.6;
//            self.titleLabel.font = [UIFont systemFontOfSize:20];
//            self.titleLabel.textAlignment = NSTextAlignmentCenter;
//            self.titleLabel.textColor = RGB_COLOR(240, 240, 240);
//            self.titleLabel.backgroundColor = [UIColor blackColor];
//            
//            [photoBrowser.view addSubview:self.titleLabel];
//            
//            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 64)];
//            view.backgroundColor = [UIColor blackColor];
//            view.alpha = 0.6;
//            [photoBrowser.view addSubview:view];
        }
        if([type isEqualToString:@"showVideo"])
        {
            UIPlayViewController *play = [self getControllerByMainStoryWithIdentifier:@"UIPlayViewController"];
            play.videoURL = [dic objectForKey:@"url"];;
            [self.navigationController pushViewController:play animated:YES];
            
        }
    }
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    return self.imageArray.count;
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    if (index < self.imageArray.count) {
        return self.imageArray[index];
    }
    return nil;
}

//- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index
//{
//    MWPhoto *photo = self.imageArray[index];
//    self.titleLabel.text = photo.caption;
//    
//    return nil;
//}


@end
