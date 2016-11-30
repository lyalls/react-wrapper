//
//  UIShareViewController.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/21.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "UIShareViewController.h"

#import "ShareItemCollectionViewCell.h"

#import <UMSocialCore/UMSocialCore.h>

@interface UIShareViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) IBOutlet UIView *topView;
@property (nonatomic, strong) NSMutableArray *displayArray;

@end

@implementation UIShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ShareItemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ShareItemCollectionViewCell"];
    
    self.displayArray = [NSMutableArray arrayWithCapacity:0];
    
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic1 setObject:@"微信好友" forKey:@"title"];
    [dic1 setObject:@"wechatSession.png" forKey:@"image"];
    [dic1 setObject:@(UMSocialPlatformType_WechatSession) forKey:@"type"];
    [self.displayArray addObject:dic1];
    
    NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic2 setObject:@"微信朋友圈" forKey:@"title"];
    [dic2 setObject:@"wechatTimeline.png" forKey:@"image"];
    [dic2 setObject:@(UMSocialPlatformType_WechatTimeLine) forKey:@"type"];
    [self.displayArray addObject:dic2];
    
    NSMutableDictionary *dic3 = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic3 setObject:@"新浪微博" forKey:@"title"];
    [dic3 setObject:@"sinaweibo.png" forKey:@"image"];
    [dic3 setObject:@(UMSocialPlatformType_Sina) forKey:@"type"];
    [self.displayArray addObject:dic3];
    
    NSMutableDictionary *dic4 = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic4 setObject:@"QQ好友" forKey:@"title"];
    [dic4 setObject:@"qq.png" forKey:@"image"];
    [dic4 setObject:@(UMSocialPlatformType_QQ) forKey:@"type"];
    [self.displayArray addObject:dic4];
    
    NSMutableDictionary *dic5 = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic5 setObject:@"QQ空间" forKey:@"title"];
    [dic5 setObject:@"qzone.png" forKey:@"image"];
    [dic5 setObject:@(UMSocialPlatformType_Qzone) forKey:@"type"];
    [self.displayArray addObject:dic5];
    
    NSMutableDictionary *dic6 = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic6 setObject:@"短信" forKey:@"title"];
    [dic6 setObject:@"sms.png" forKey:@"image"];
    [dic6 setObject:@(UMSocialPlatformType_Sms) forKey:@"type"];
    [self.displayArray addObject:dic6];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom method

- (IBAction)closeBtnClick:(id)sender {
    if (self.block) {
        self.block(NO);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Collection view data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.displayArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShareItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShareItemCollectionViewCell" forIndexPath:indexPath];
    
    [cell reloadData:[self.displayArray objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - Collection view flow layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREEN_WIDTH / 3, 98);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark - Collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [self.displayArray objectAtIndex:indexPath.row];
    
    if ([dic integerForKey:@"type"] != UMSocialPlatformType_Sms)
        [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([dic integerForKey:@"type"] == UMSocialPlatformType_WechatSession) {
        [self shareWechatSession];
    } else if ([dic integerForKey:@"type"] == UMSocialPlatformType_WechatTimeLine) {
        [self shareWechatTimeline];
    } else if ([dic integerForKey:@"type"] == UMSocialPlatformType_Sina) {
        [self shareSinaWeibo];
    } else if ([dic integerForKey:@"type"] == UMSocialPlatformType_QQ) {
        [self shareQQ];
    } else if ([dic integerForKey:@"type"] == UMSocialPlatformType_Qzone) {
        [self shareQZone];
    } else if ([dic integerForKey:@"type"] == UMSocialPlatformType_Sms) {
        [self shareSms];
    }
    
    [UserDefaultsHelper sharedManager].isShareExit = YES;
}

- (void)shareWechatSession {
    if (self.shareDic) {
        NSDictionary *dic = [self.shareDic objectForKey:@"webChatFriends"];
        self.shareTitle = [dic objectForKey:@"title"];
        self.shareUrl = [dic objectForKey:@"url"];
        self.shareDesc = [dic objectForKey:@"msg"];
        self.shareImageUrl = [dic objectForKey:@"icon"];
    }
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.shareTitle descr:self.shareDesc thumImage:self.shareImageUrl];
    shareObject.webpageUrl = self.shareUrl;
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatSession messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            if (self.block) {
                self.block(NO);
            }
        } else {
            if (self.block) {
                self.block(YES);
            }
        }
    }];
}

- (void)shareWechatTimeline {
    if (self.shareDic) {
        NSDictionary *dic = [self.shareDic objectForKey:@"webChatMoments"];
        self.shareTitle = [dic objectForKey:@"title"];
        self.shareUrl = [dic objectForKey:@"url"];
        self.shareDesc = [dic objectForKey:@"msg"];
        self.shareImageUrl = [dic objectForKey:@"icon"];
    }
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.shareTitle descr:self.shareDesc thumImage:self.shareImageUrl];
    shareObject.webpageUrl = self.shareUrl;
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatTimeLine messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            if (self.block) {
                self.block(NO);
            }
        } else {
            if (self.block) {
                self.block(YES);
            }
        }
    }];
}

- (void)shareSinaWeibo {
    if (self.shareDic) {
        NSDictionary *dic = [self.shareDic objectForKey:@"microBlog"];
        self.shareTitle = [dic objectForKey:@"title"];
        self.shareUrl = [dic objectForKey:@"url"];
        self.shareDesc = [dic objectForKey:@"msg"];
        self.shareImageUrl = [dic objectForKey:@"icon"];
    }
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    messageObject.text = [NSString stringWithFormat:@"%@ %@", self.shareTitle, self.shareUrl];
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    [shareObject setShareImage:self.shareImageUrl];
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_Sina messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            if (self.block) {
                self.block(NO);
            }
        } else {
            if (self.block) {
                self.block(YES);
            }
        }
    }];
}

- (void)shareQQ {
    if (self.shareDic) {
        NSDictionary *dic = [self.shareDic objectForKey:@"qqFriends"];
        self.shareTitle = [dic objectForKey:@"title"];
        self.shareUrl = [dic objectForKey:@"url"];
        self.shareDesc = [dic objectForKey:@"msg"];
        self.shareImageUrl = [dic objectForKey:@"icon"];
    }
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.shareTitle descr:self.shareDesc thumImage:self.shareImageUrl];
    shareObject.webpageUrl = self.shareUrl;
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_QQ messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            if (self.block) {
                self.block(NO);
            }
        } else {
            if (self.block) {
                self.block(YES);
            }
        }
    }];
}

- (void)shareQZone {
    if (self.shareDic) {
        NSDictionary *dic = [self.shareDic objectForKey:@"qqZone"];
        self.shareTitle = [dic objectForKey:@"title"];
        self.shareUrl = [dic objectForKey:@"url"];
        self.shareDesc = [dic objectForKey:@"msg"];
        self.shareImageUrl = [dic objectForKey:@"icon"];
    }
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.shareTitle descr:self.shareDesc thumImage:self.shareImageUrl];
    shareObject.webpageUrl = self.shareUrl;
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_Qzone messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            if (self.block) {
                self.block(NO);
            }
        } else {
            if (self.block) {
                self.block(YES);
            }
        }
    }];
}

- (void)shareSms {
    if (self.shareDic) {
        NSDictionary *dic = [self.shareDic objectForKey:@"sms"];
        self.shareTitle = [dic objectForKey:@"title"];
        self.shareUrl = [dic objectForKey:@"url"];
        self.shareDesc = [dic objectForKey:@"msg"];
        self.shareImageUrl = [dic objectForKey:@"icon"];
    }
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    messageObject.text = [NSString stringWithFormat:@"%@ %@", self.shareTitle, self.shareUrl];
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    [shareObject setShareImage:self.shareImageUrl];
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_Sms messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            if (self.block) {
                self.block(NO);
            }
        } else {
            if (self.block) {
                self.block(YES);
            }
        }
    }];
}

@end
