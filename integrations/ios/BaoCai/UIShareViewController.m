//
//  UIShareViewController.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/21.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "UIShareViewController.h"

#import "ShareItemCollectionViewCell.h"

#import "UMSocial.h"

@interface UIShareViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UMSocialUIDelegate>

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
    [dic1 setObject:UMShareToWechatSession forKey:@"type"];
    [self.displayArray addObject:dic1];
    
    NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic2 setObject:@"微信朋友圈" forKey:@"title"];
    [dic2 setObject:@"wechatTimeline.png" forKey:@"image"];
    [dic2 setObject:UMShareToWechatTimeline forKey:@"type"];
    [self.displayArray addObject:dic2];
    
    NSMutableDictionary *dic3 = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic3 setObject:@"新浪微博" forKey:@"title"];
    [dic3 setObject:@"sinaweibo.png" forKey:@"image"];
    [dic3 setObject:UMShareToSina forKey:@"type"];
    [self.displayArray addObject:dic3];
    
    NSMutableDictionary *dic4 = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic4 setObject:@"QQ好友" forKey:@"title"];
    [dic4 setObject:@"qq.png" forKey:@"image"];
    [dic4 setObject:UMShareToQQ forKey:@"type"];
    [self.displayArray addObject:dic4];
    
    NSMutableDictionary *dic5 = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic5 setObject:@"QQ空间" forKey:@"title"];
    [dic5 setObject:@"qzone.png" forKey:@"image"];
    [dic5 setObject:UMShareToQzone forKey:@"type"];
    [self.displayArray addObject:dic5];
    
    NSMutableDictionary *dic6 = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic6 setObject:@"短信" forKey:@"title"];
    [dic6 setObject:@"sms.png" forKey:@"image"];
    [dic6 setObject:UMShareToSms forKey:@"type"];
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
    return CGSizeMake(Screen_width / 3, 98);
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
    
    if ([dic objectForKey:@"type"] != UMShareToSms)
        [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([dic objectForKey:@"type"] == UMShareToWechatSession) {
        [self shareWechatSession];
    } else if ([dic objectForKey:@"type"] == UMShareToWechatTimeline) {
        [self shareWechatTimeline];
    } else if ([dic objectForKey:@"type"] == UMShareToSina) {
        [self shareSinaWeibo];
    } else if ([dic objectForKey:@"type"] == UMShareToQQ) {
        [self shareQQ];
    } else if ([dic objectForKey:@"type"] == UMShareToQzone) {
        [self shareQZone];
    } else if ([dic objectForKey:@"type"] == UMShareToSms) {
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
    
    [UMSocialData defaultData].extConfig.wechatSessionData.wxMessageType = UMSocialWXMessageTypeWeb;
    [UMSocialData defaultData].extConfig.wechatSessionData.title = self.shareTitle;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = self.shareUrl;
    UMSocialUrlResource *shareUrl = [[UMSocialUrlResource alloc] initWithSnsResourceType:(UMSocialUrlResourceTypeWeb) url:self.shareUrl];
    
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatSession] content:self.shareDesc image:[UIImage imageNamed:@"icon.png"] location:nil urlResource:shareUrl presentedController:self completion:^(UMSocialResponseEntity *shareResponse) {
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            if (self.block) {
                self.block(YES);
            }
        } else {
            if (self.block) {
                self.block(NO);
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
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.wxMessageType = UMSocialWXMessageTypeWeb;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.shareUrl;
    UMSocialUrlResource *shareUrl = [[UMSocialUrlResource alloc] initWithSnsResourceType:(UMSocialUrlResourceTypeWeb) url:self.shareUrl];
    
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToWechatTimeline] content:self.shareTitle image:[UIImage imageNamed:@"icon.png"] location:nil urlResource:shareUrl presentedController:self completion:^(UMSocialResponseEntity *shareResponse) {
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            if (self.block) {
                self.block(YES);
            }
        } else {
            if (self.block) {
                self.block(NO);
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
    
    UMSocialUrlResource *shareUrl = [[UMSocialUrlResource alloc] initWithSnsResourceType:(UMSocialUrlResourceTypeWeb) url:self.shareUrl];
    
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToSina] content:[NSString stringWithFormat:@"%@ %@", self.shareTitle, self.shareUrl] image:[UIImage imageNamed:@"icon.png"] location:nil urlResource:shareUrl presentedController:self completion:^(UMSocialResponseEntity *shareResponse) {
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            if (self.block) {
                self.block(YES);
            }
        } else {
            if (self.block) {
                self.block(NO);
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
    
    [UMSocialData defaultData].extConfig.qqData.title = self.shareTitle;
    [UMSocialData defaultData].extConfig.qqData.url = self.shareUrl;
    
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToQQ] content:self.shareDesc image:[UIImage imageNamed:@"icon.png"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse) {
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            if (self.block) {
                self.block(YES);
            }
        } else {
            if (self.block) {
                self.block(NO);
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
    
    [UMSocialData defaultData].extConfig.qzoneData.title = self.shareTitle;
    [UMSocialData defaultData].extConfig.qzoneData.url = self.shareUrl;
    
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToQzone] content:self.shareDesc image:[UIImage imageNamed:@"icon.png"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse) {
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            if (self.block) {
                self.block(YES);
            }
        } else {
            if (self.block) {
                self.block(NO);
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
    
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToSms] content:[NSString stringWithFormat:@"%@ %@", self.shareTitle, self.shareUrl] image:[UIImage imageNamed:@"icon.png"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse) {
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            if (self.block) {
                self.block(YES);
            }
        } else {
            if (self.block) {
                self.block(NO);
            }
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

@end
