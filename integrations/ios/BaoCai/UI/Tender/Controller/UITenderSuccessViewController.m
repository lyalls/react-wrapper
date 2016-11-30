//
//  UITenderSuccessViewController.m
//  BaoCai
//
//  Created by meng on 16/9/20.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "UITenderSuccessViewController.h"
#import "UIShareViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define TenderScale (SCREEN_HEIGHT - 64) / (568 - 64)

@interface UITenderSuccessViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *shareImage;
@property (weak, nonatomic) IBOutlet UILabel *successLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *successImageWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *successImageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *successLabelUpConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *successLabelDownConstraint;
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
    
    _successLabel.font = [UIFont systemFontOfSize:SCREEN_HEIGHT > 480 ? 22 * TenderScale : 22];
    _successLabel.text = self.successMessage;
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    self.successImageWidthConstraint.constant = SCREEN_HEIGHT > 480 ? 40 * TenderScale : 40;
    self.successImageHeightConstraint.constant = SCREEN_HEIGHT > 480 ? 40 * TenderScale : 40;
    self.successLabelUpConstraint.constant = SCREEN_HEIGHT > 480 ? 40 * TenderScale : 40;
    self.successLabelDownConstraint.constant = SCREEN_HEIGHT > 480 ? 45 * TenderScale : 45;
    self.shareViewUpConstraint.constant = SCREEN_HEIGHT > 480 ? 70 * TenderScale : 40;
    self.shareViewHeightConstraint.constant = 110 * (SCREEN_WIDTH - 20) / (320 - 20);
    self.shareViewDownConstraint.constant = SCREEN_HEIGHT > 480 ? 90 * TenderScale : 40;
}

-(void) shareClick
{
    [MobClick event:@"investment_genre1_ui_invest_ui_result_for_success_share" label:@"散标投资页_投资按钮_结果_投资成功_分享按钮"];
    UIShareViewController *view = [self getControllerByStoryBoardType:StoryBoardTypeMy identifier:@"UIShareViewController"];
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
