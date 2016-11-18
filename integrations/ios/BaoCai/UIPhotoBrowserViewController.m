//
//  UIPhotoBrowserViewController.m
//  BaoCai
//
//  Created by lishuo on 16/10/9.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "UIPhotoBrowserViewController.h"
#import <MWPhotoBrowser/MWPhotoBrowser.h>
@interface UIPhotoBrowserViewController ()<MWPhotoBrowserDelegate>
{
    UILabel *_titleLabel;
}

@end

@implementation UIPhotoBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    MWPhotoBrowser *photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    photoBrowser.displayActionButton = NO;
    photoBrowser.displayNavArrows = NO;
    photoBrowser.displaySelectionButtons = NO;
    photoBrowser.alwaysShowControls = NO;
    photoBrowser.zoomPhotosToFill = YES;
    photoBrowser.enableGrid = NO;
    photoBrowser.startOnGrid = NO;
    photoBrowser.enableSwipeToDismiss = NO;
    
    [photoBrowser setCurrentPhotoIndex:self.currentIndex];

    
    [self addChildViewController:photoBrowser];
    [self.view addSubview:photoBrowser.view];
   
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.frame = CGRectMake(0, 64, Screen_width, 20);
    _titleLabel.alpha = 0.6;
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = RGB_COLOR(240, 240, 240);
    _titleLabel.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_titleLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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

- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index
{
   
    return nil;
}

- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index
{
    MWPhoto *photo = self.imageArray[index];
    _titleLabel.text = photo.caption;
    
    return  nil;
}
@end
