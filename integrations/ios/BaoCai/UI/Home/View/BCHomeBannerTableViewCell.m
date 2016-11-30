//
//  BCHomeBannerTableViewCell.m
//  BaoCai
//
//  Created by 刘国龙 on 2016/10/26.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "BCHomeBannerTableViewCell.h"

#import <SDCycleScrollView/SDCycleScrollView.h>

@interface BCHomeBannerTableViewCell () <SDCycleScrollViewDelegate>

@property (nonatomic, strong) BannerItemClickBlock clickBlock;

@property (nonatomic, strong) NSMutableArray *bannerArray;

@property (nonatomic, strong) SDCycleScrollView *bannerScrollView;

@end

@implementation BCHomeBannerTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupView {
    self.bannerScrollView = [[SDCycleScrollView alloc] init];
    self.bannerScrollView.delegate = self;
    [self.bannerScrollView setPageDotColor:[UIColor clearColor]];
    self.bannerScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    self.bannerScrollView.pageDotImage = [UIImage imageNamed:@"dot_unselected.png"];
    self.bannerScrollView.currentPageDotImage = [UIImage imageNamed:@"dot_selected.png"];
    self.bannerScrollView.placeholderImage = [UIImage imageNamed:@"placeholder"];
    self.bannerScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    self.bannerScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    [self.contentView addSubview:self.bannerScrollView];
    
    [self.bannerScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

#pragma mark - Custom method

- (void)reloadBannerData:(NSMutableArray *)imageArray bannerItemClickBlock:(BannerItemClickBlock)bannerItemClickBlock {
    self.bannerArray = imageArray;
    self.clickBlock = bannerItemClickBlock;
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dic in imageArray) {
        [array addObject:[dic objectForKey:@"imageUrl"]];
    }
    self.bannerScrollView.imageURLStringsGroup = array;
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (self.clickBlock) {
        self.clickBlock([self.bannerArray objectAtIndex:index]);
    }
}

@end
