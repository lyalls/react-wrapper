//
//  BCButtonScrollView.m
//  BaoCai
//
//  Created by 刘国龙 on 2016/11/3.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "BCButtonScrollView.h"

@interface BCButtonScrollView () <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *displayItems;

@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, assign) NSInteger lastSelectedButtonTag;

@end

@implementation BCButtonScrollView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.buttonView = [[UIView alloc] initWithFrame:CGRectNull];
        self.buttonView.backgroundColor = BackViewColor;
        [self addSubview:self.buttonView];
        
        [self.buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(40);
        }];
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectNull];
        self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, 0);
        self.scrollView.pagingEnabled = YES;
        self.scrollView.delegate = self;
        self.scrollView.backgroundColor = BackViewColor;
        [self addSubview:self.scrollView];
        
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(41, 0, 0, 0));
        }];
    }
    return self;
}

- (instancetype)initWithItems:(NSMutableArray *)items {
    self = [self init];
    if (self) {
        self.displayItems = items;
        [self setupView];
    }
    return self;
}

- (void)setupView {
    UIButton *lastButton = nil;
    NSInteger isSelectedIndex = -1;
    
    for (NSInteger i = 0; i < self.displayItems.count; i++) {
        BCButtonScrollItemModel *model = [self.displayItems objectAtIndex:i];
        
        UIButton *button = [[UIButton alloc] init];
        button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [button setTitle:model.buttonName forState:UIControlStateNormal];
        [button setTitleColor:Color666666 forState:UIControlStateNormal];
        [button setTitleColor:RGB_COLOR(228, 0, 18) forState:UIControlStateSelected];
        button.backgroundColor = [UIColor whiteColor];
        [button addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i + 1000;
        [self.buttonView addSubview:button];
        
        if (i == 0) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.bottom.equalTo(0);
                if (i == self.displayItems.count - 1) {
                    make.right.equalTo(0);
                }
            }];
        } else if (i == self.displayItems.count - 1) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.right.mas_equalTo(0);
                make.left.equalTo(lastButton.mas_right).mas_offset(1);
                make.width.equalTo(lastButton);
            }];
        } else {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(0);
                make.left.equalTo(lastButton.mas_right).mas_offset(1);
                make.width.equalTo(lastButton);
            }];
        }
        
        if (model.isSelected) {
            isSelectedIndex = i;
        }
        
        lastButton = button;
    }
    
    if (isSelectedIndex == -1)
        return;
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = RGB_COLOR(228, 0, 18);
    [self.buttonView addSubview:self.lineView];
    
    NSInteger buttonTag = isSelectedIndex + 1000;
    self.lastSelectedButtonTag = buttonTag;
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo([self.buttonView viewWithTag:buttonTag]);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(2);
    }];
    
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * isSelectedIndex, 0) animated:YES];
    
    [self setupScrollView];
}

- (void)setupScrollView {
    UIView *lastView = nil;
    
    for (NSInteger i = 0; i < self.displayItems.count; i++) {
        BCButtonScrollItemModel *model = [self.displayItems objectAtIndex:i];
        
        [self.scrollView addSubview:model.displayView];
        
        if (i == 0) {
            [model.displayView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.equalTo(self.scrollView);
                make.height.equalTo(self.scrollView.mas_height);
                make.width.equalTo(self.scrollView.mas_width);
                if (i == self.displayItems.count - 1) {
                    make.right.equalTo(self.scrollView);
                }
            }];
        } else if (i == self.displayItems.count - 1) {
            [model.displayView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastView.mas_right);
                make.top.bottom.right.equalTo(self.scrollView);
                make.height.equalTo(self.scrollView.mas_height);
                make.width.equalTo(self.scrollView.mas_width);
            }];
        } else {
            [model.displayView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastView.mas_right);
                make.top.bottom.equalTo(self.scrollView);
                make.height.equalTo(self.scrollView.mas_height);
                make.width.equalTo(self.scrollView.mas_width);
            }];
        }
        
        lastView = model.displayView;
    }
}

#pragma mark - Custom method

- (void)reloadDisplay:(NSMutableArray *)items {
    self.displayItems = items;
    
    if (self.buttonView) {
        [self.buttonView removeChildViews];
    }
    if (self.scrollView) {
        [self.scrollView removeChildViews];
    }
    
    [self setupView];
}

- (void)typeBtnClick:(UIButton *)button {
    NSInteger buttonTag = button.tag;
    [self setButtonStatus:buttonTag];
    
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * (buttonTag - 1000), 0) animated:YES];
}

- (void)setButtonStatus:(NSInteger)tag {
    UIButton *lastSelectedButton = [self.buttonView viewWithTag:self.lastSelectedButtonTag];
    lastSelectedButton.selected = NO;
    
    self.lastSelectedButtonTag = tag;
    
    UIButton *currentButton = [self.buttonView viewWithTag:self.lastSelectedButtonTag];
    currentButton.selected = YES;
    
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(currentButton);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(2);
    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(buttonScrollViewDidChangeIndexPage:)]) {
        [self.delegate buttonScrollViewDidChangeIndexPage:tag - 1000];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        int currentPage = floor((scrollView.contentOffset.x - SCREEN_WIDTH / 2) / SCREEN_WIDTH) + 1;
        
        [self setButtonStatus:currentPage + 1000];
    }
}

@end

@implementation BCButtonScrollItemModel

@end
