//
//  HomeBannerTableViewCell.m
//  BaoCai
//
//  Created by 刘国龙 on 16/5/30.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "HomeBannerTableViewCell.h"
#import "SDCycleScrollView.h"

@interface HomeBannerTableViewCell () <SDCycleScrollViewDelegate>

@property (nonatomic, strong) BannerItemClickBlock clickBlock;

@property (weak, nonatomic) IBOutlet SDCycleScrollView *bannerView;

@property (nonatomic, strong) NSMutableArray *bannerArray;

@end

@implementation HomeBannerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setupView:(NSMutableArray *)dataArray bannerItemClickBlock:(BannerItemClickBlock)bannerItemClickBlock {
    self.clickBlock = bannerItemClickBlock;
    
    self.bannerArray = dataArray;
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    for (NSDictionary *dic in dataArray) {
        [array addObject:[dic objectForKey:@"imageUrl"]];
    }
    [self.bannerView setPageDotColor:[UIColor clearColor]];
    self.bannerView.imageURLStringsGroup = array;
    self.bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    self.bannerView.delegate = self;
    self.bannerView.pageDotImage = [UIImage imageNamed:@"dot_unselected.png"];
    self.bannerView.currentPageDotImage = [UIImage imageNamed:@"dot_selected.png"];
    
    self.bannerView.placeholderImage = [UIImage imageNamed:@"placeholder"];
    self.bannerView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    self.bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (self.clickBlock) {
        self.clickBlock([self.bannerArray objectAtIndex:index]);
    }
}

@end
