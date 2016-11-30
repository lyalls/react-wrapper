//
//  BCBackButton.m
//  BaoCai
//
//  Created by 刘国龙 on 2016/11/2.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "BCBackButton.h"

@implementation BCBackButton

- (instancetype)init {
    self = [self initWithFrame:CGRectMake(0, 0, 16, 16)];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setImage:[UIImage imageNamed:@"backImage"] forState:UIControlStateNormal];
    }
    return self;
}

@end
