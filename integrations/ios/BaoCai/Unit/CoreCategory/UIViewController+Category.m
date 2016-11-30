//
//  UIViewController+Category.m
//  CoreCategory
//
//  Created by LiuGuolong on 15/7/9.
//  Copyright (c) 2015年 LiuGuolong. All rights reserved.
//

#import "UIViewController+Category.h"

@implementation UIViewController (Category)

- (void)setTitleColor:(UIColor *)color {
    NSMutableDictionary *titleAttrDic = [NSMutableDictionary dictionary];
    [titleAttrDic setObject:[UIFont systemFontOfSize:18] forKey:NSFontAttributeName];
    [titleAttrDic setObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = titleAttrDic;
}

- (void)onNavigationBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)gotoNavigationRoot {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)setBackBarButtonTitle:(NSString *)title {
    if (title == nil) {
        title = @"返回";
    }
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:nil];
}

- (void)setLeftBarButtonTitle:(NSString *)title action:(SEL)action {
    if (action == nil) {
        action = @selector(onNavigationBack);
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:action];
}

- (void)setRightBarButtonTitle:(NSString *)title action:(SEL)action {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:action];
}

- (void)setLeftBarButtonOfDefault:(SEL)action {
    [self setLeftBarButtonImage:[UIImage imageNamed:@"nav_back"] highlightImage:nil action:action];
}

- (void)setLeftBarButtonImage:(UIImage *)image highlightImage:(UIImage *)highlightImage action:(SEL)action {
    if (action == nil) {
        action = @selector(onNavigationBack);
    }
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:image forState:UIControlStateNormal];
    [leftButton setImage:highlightImage forState:UIControlStateHighlighted];
    [leftButton setFrame:CGRectMake(0, 0, 44, 44)];
    [leftButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -16;
    
    self.navigationItem.leftBarButtonItems  = @[negativeSpacer, leftItem];
}

- (void)setRightBarButtonImage:(UIImage *)image highlightImage:(UIImage *)highlightImage action:(SEL)action {
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:image forState:UIControlStateNormal];
    [rightButton setImage:highlightImage forState:UIControlStateHighlighted];
    [rightButton setFrame:CGRectMake(0, 0, 44, 44)];
    [rightButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -16;
    
    self.navigationItem.rightBarButtonItems  = @[negativeSpacer, rightItem];
}

- (void)setNavigationBarWithColor:(UIColor *)color {
    CGSize size = CGSizeMake(1,1);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self setNavigationBarWithImage:theImage];
}

- (void)setNavigationBarWithImage:(UIImage *)image {
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}

- (NSString *)cellIdentifier {
    NSString *className = NSStringFromClass(self.class);
    return [className stringByAppendingString:@"_Cell"];
}

- (void)setupForDismissKeyboard {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnywhereToDismissKeyboard:)];
    
    __weak UIViewController *weakSelf = self;
    
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification object:nil queue:mainQuene usingBlock:^(NSNotification * _Nonnull note) {
        [weakSelf.view addGestureRecognizer:singleTapGR];
    }];
    [nc addObserverForName:UIKeyboardWillHideNotification object:nil queue:mainQuene usingBlock:^(NSNotification * _Nonnull note) {
        [weakSelf.view removeGestureRecognizer:singleTapGR];
    }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
}

@end
