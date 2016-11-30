//
//  GuideView.m
//  BaoCai
//
//  Created by 刘国龙 on 16/8/3.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "GuideView.h"

@interface GuideView () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewContentViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view2LeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view3LeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *image3RightConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;

@end

@implementation GuideView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, SCREEN_HEIGHT);
    self.scrollViewContentViewConstraint.constant = SCREEN_WIDTH * 3;
    self.view2LeftConstraint.constant = SCREEN_WIDTH;
    self.view3LeftConstraint.constant = SCREEN_WIDTH * 2;
    
    self.image3RightConstraint.constant = 0;
}

- (void)reloadData {
    self.image1.image = [UIImage imageNamed:[NSString stringWithFormat:@"guide1_%ld.png", (long)@(SCREEN_HEIGHT).integerValue]];
    self.image2.image = [UIImage imageNamed:[NSString stringWithFormat:@"guide2_%ld.png", (long)@(SCREEN_HEIGHT).integerValue]];
    self.image3.image = [UIImage imageNamed:[NSString stringWithFormat:@"guide3_%ld.png", (long)@(SCREEN_HEIGHT).integerValue]];
}

- (IBAction)hiddenView:(id)sender {
    [self removeFromSuperview];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}

@end
