//
//  UITenderSuccessViewController.m
//  BaoCai
//
//  Created by meng on 16/9/20.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "UITenderSuccessViewController.h"
#import "UIShareViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define TenderScale (Screen_height - 64 - 45 - 130 * (Screen_width - 20) / (375 - 20)) / (667 - 64 - 45 - 130)

@interface UITenderSuccessViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *shareImage;
@property (weak, nonatomic) IBOutlet UILabel *successLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *successImageUpConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *successImageWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *successImageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *successImageDownConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareViewUpConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareViewDownConstraint;

@end

@implementation UITenderSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.sharebtnIsShow)
    {
        [_shareImage sd_setImageWithURL:[self.sharebtnImageUrl toURL]];
        _shareImage.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shareClick)];
        [_shareImage addGestureRecognizer:tap];
    }
    else
    {
        _shareImage.hidden = YES;
    }
    
    _successLabel.font = [UIFont systemFontOfSize:Screen_height > 480 ? 20 * TenderScale : 16];
    _successLabel.text = self.successMessage;
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    self.successImageUpConstraint.constant = Screen_height > 480 ? 58 * TenderScale : 47;
    self.successImageWidthConstraint.constant = Screen_height > 480 ? 60 * TenderScale : 49;
    self.successImageHeightConstraint.constant = Screen_height > 480 ? 60 * TenderScale : 49;
    self.successImageDownConstraint.constant = Screen_height > 480 ? 38 * TenderScale : 31;
    self.shareViewUpConstraint.constant = Screen_height > 480 ? 70 * TenderScale : 35;
    self.shareViewHeightConstraint.constant = 130 * (Screen_width - 20) / (375 - 20);
    self.shareViewDownConstraint.constant = Screen_height > 480 ? 110 * TenderScale : 55;
}

-(void) shareClick
{
    [MobClick event:@"investment_genre1_ui_invest_ui_result_for_success_share" label:@"散标投资页_投资按钮_结果_投资成功_分享按钮"];
    UIShareViewController *view = [self getControllerByMainStoryWithIdentifier:@"UIShareViewController"];
    view.shareTitle = self.shareTitle;
    view.shareDesc = self.shareDesc;
    view.shareUrl = self.shareUrl;
    view.shareImageUrl = self.shareImageUrl;
    view.block = ^(BOOL ret) {
        if (ret) {
            [MobClick event:@"investment_genre1_ui_invest_ui_result_for_success_share_for_success" label:@"散标投资页_投资按钮_结果_投资成功_分享按钮_分享成功"];
        }
    };
    [self presentTranslucentViewController:view animated:YES];
}
- (IBAction)touziClick:(id)sender {
    if(self.callback)
    {
        self.callback(0);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)touziListClick:(id)sender {
    if(self.callback)
    {
        self.callback(1);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
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
