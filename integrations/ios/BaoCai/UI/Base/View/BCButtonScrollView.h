//
//  BCButtonScrollView.h
//  BaoCai
//
//  Created by 刘国龙 on 2016/11/3.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BCButtonScrollViewDelegate <NSObject>

- (void)buttonScrollViewDidChangeIndexPage:(NSInteger)pageIndex;

@end

@interface BCButtonScrollView : UIView

@property (nonatomic, assign) id<BCButtonScrollViewDelegate> delegate;
@property (nonatomic, strong) UIScrollView *scrollView;

- (instancetype)initWithItems:(NSMutableArray *)items;

- (void)reloadDisplay:(NSMutableArray *)items;

@end

@interface BCButtonScrollItemModel : NSObject

@property (nonatomic, strong) NSString *buttonName;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) UIView *displayView;

@end
