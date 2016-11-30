//
//  UIActionSheet+Category.h
//  QMEDICAL
//
//  Created by 刘国龙 on 15/10/17.
//  Copyright © 2015年 LiuGuolong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ClickedButtonBlock)(NSInteger buttonIndex);

@interface UIActionSheet (Category) <UIActionSheetDelegate>

- (void)clickedButtonEvent:(ClickedButtonBlock)event;

@end
