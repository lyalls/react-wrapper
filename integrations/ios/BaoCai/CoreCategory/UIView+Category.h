//
//  UIView+Category.h
//  CoreCategory
//
//  Created by LiuGuolong on 15/7/7.
//  Copyright (c) 2015年 LiuGuolong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Screen_bounds [[UIScreen mainScreen] bounds]
#define Screen_width CGRectGetWidth([[UIScreen mainScreen] bounds])
#define Screen_height CGRectGetHeight([[UIScreen mainScreen] bounds])

#define autoSizeScaleWidth ((Screen_height > 568) ? (Screen_width / 320) : 1.0f)
#define autoSizeScaleHeight ((Screen_height > 568) ? (Screen_height / 568) : 1.0f)

#define homeHeightScale (((Screen_height - 113) > (568 - 113)) ? ((Screen_height - 113) / (568 - 113)) : 1.0f)

// View 圆角和加边框
#define ViewBorderRadius(View, Radius, Width, Color)\
                                \
                                [View.layer setCornerRadius:(Radius)];\
                                [View.layer setMasksToBounds:YES];\
                                [View.layer setBorderWidth:(Width)];\
                                [View.layer setBorderColor:[Color CGColor]]

// View 圆角
#define ViewRadius(View, Radius)\
                                \
                                [View.layer setCornerRadius:(Radius)];\
                                [View.layer setMasksToBounds:YES]

typedef void (^GestureActionBlock)(UIGestureRecognizer *gestureRecoginzer);

@interface UIView (Category) <UIGestureRecognizerDelegate>

CGRect CGRectMakeCustom(CGFloat x, CGFloat y, CGFloat width, CGFloat height);

- (CGFloat)x;
- (void)setX:(CGFloat)x;
- (CGFloat)y;
- (void)setY:(CGFloat)y;
- (CGFloat)width;
- (void)setWidth:(CGFloat)width;
- (CGFloat)height;
- (void)setHeight:(CGFloat)height;

- (CGFloat)left;
- (CGFloat)top;
- (CGFloat)right;
- (CGFloat)bottom;

- (void)setBorder:(UIColor *)color width:(CGFloat)width;

//获取当前视图所在的视图控制器
- (UIViewController *)viewController;

//删除当前视图内的所有子视图
- (void)removeChildViews;

//给视图添加点按事件
- (void)addTapActionWithBlock:(GestureActionBlock)block;

//给视图添加长按事件
- (void)addLongPressActionWithBlock:(GestureActionBlock)block;

@end

@interface UIView (AutoLayout)

//view距superViews首部距离约束
- (void)leadingToSuperview:(CGFloat)leading;

//view距superViews尾部距离约束
- (void)trailingToSuperview:(CGFloat)trailing;

//view距superViews首部距离、尾部距离约束
- (void)leadingToSuperview:(CGFloat)leading trailing:(CGFloat)trailing;

//view距superViews上部距离约束
- (void)topToSuperview:(CGFloat)top;

//view距superViews下部距离约束
- (void)bottomToSuperview:(CGFloat)bottom;

//view距superViews上部距离、下部距离约束
- (void)topToSuperview:(CGFloat)top bottom:(CGFloat)bottom;

//view与superView中心点位置：centerX取值：0--相等；负数--负向偏移；正数--正向偏移。
- (void)centerXToSuperview:(CGFloat)centerX;

//view与superView中心点位置：centerY取值：0--相等；负数--负向偏移；正数--正向偏移。
- (void)centerYToSuperview:(CGFloat)centerY;

//view1与view2左边缘约束
- (void)leftEdgesToView:(UIView *)view edges:(CGFloat)edges;

//view1与view2右边缘约束
- (void)rightEdgesToView:(UIView *)view edges:(CGFloat)edges;

//view1与view2上边缘约束
- (void)topEdgesToView:(UIView *)view edges:(CGFloat)edges;

//view1与view2下边缘约束
- (void)bottomEdgesToView:(UIView *)view edges:(CGFloat)edges;

//view1与view2水平间距（view2.left = view1.right + space）
- (void)horizontalSpaceToLeftview:(UIView *)view space:(CGFloat)space;

//view1与view2竖直间距（view2.top = view1.bottom + space）
- (void)verticalSpaceToTopview:(UIView *)view space:(CGFloat)space;

//view宽度约束
- (void)widthConstraint:(CGFloat)width;

//view高度约束
- (void)heightConstraint:(CGFloat)height;

//view1与view2宽度约束（view2.width = view1.width * multiplier + constant）
- (void)widthEquallyView:(UIView *)view constant:(CGFloat)constant multiplier:(CGFloat)multiplier;

//view1与view2高度约束（view2.height = view1.height * multiplier + constant）
- (void)heightEquallyView:(UIView *)view constant:(CGFloat)constant multiplier:(CGFloat)multiplier;

@end
