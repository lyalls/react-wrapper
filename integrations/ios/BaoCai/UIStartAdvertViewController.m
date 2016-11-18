//
//  UIStartAdvertViewController.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/21.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "UIStartAdvertViewController.h"

#import "GeneralRequest.h"
#import <SDWebImage/UIButton+WebCache.h>

@interface UIStartAdvertViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *jumpBtn;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *jumpLabel;

@property (nonatomic, assign) BOOL isHidden;
@property (nonatomic, strong) NSString *actionUrl;

@end

@implementation UIStartAdvertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.topImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"launch%ld", (long)@(Screen_height).integerValue]];
    
    self.bottomView.hidden = YES;
    self.backButton.hidden = YES;
    self.jumpBtn.hidden = YES;
    self.secondLabel.hidden = YES;
    self.jumpBtn.hidden = YES;
    
    _jumpBtn.layer.cornerRadius = 12.5;
    _jumpBtn.layer.masksToBounds = YES;
    
    self.isHidden = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.isHidden) {
            [self.view removeFromSuperview];
        }
    });
    
    [GeneralRequest getActivityWithSuccess:^(NSDictionary *dic, BCError *error) {
        if (error.code == 0) {
            if ([dic stringForKey:@"imageUrl"].length != 0 && [dic stringForKey:@"actionUrl"].length != 0) {
                self.actionUrl = [dic objectForKey:@"actionUrl"];
                [self.backButton sd_setBackgroundImageWithURL:[[dic objectForKey:@"imageUrl"] toURL] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (error) {
                        [self.view removeFromSuperview];
                    }
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        self.isHidden = NO;
                        self.topImageView.hidden = YES;
                        
                        self.bottomView.hidden = NO;
                        self.backButton.hidden = NO;
                        self.jumpBtn.hidden = NO;
                        self.secondLabel.hidden = NO;
                        self.jumpBtn.hidden = NO;
                        
                        __block int timeout = 5; //倒计时时间
                        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
                        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
                        dispatch_source_set_event_handler(_timer, ^{
                            if(timeout <= 0){
                                dispatch_source_cancel(_timer);
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self jumpBtnClick:nil];
                                });
                            } else {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    _secondLabel.text = [NSString stringWithFormat:@"%d", timeout];
                                    
                                });
                                timeout--;
                            }
                        });
                        dispatch_resume(_timer);
                    });
                }];
            } else {
                [self.view removeFromSuperview];
            }
        } else {
            [self.view removeFromSuperview];
        }
    } failure:^(NSError *error) {
        [self.view removeFromSuperview];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom method

- (IBAction)jumpBtnClick:(id)sender {
    [self.view removeFromSuperview];
}

- (IBAction)advertBtnClick:(id)sender {
    [self.view removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(startAdvertOpenUrl:)]) {
        [self.delegate performSelector:@selector(startAdvertOpenUrl:) withObject:self.actionUrl];
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
