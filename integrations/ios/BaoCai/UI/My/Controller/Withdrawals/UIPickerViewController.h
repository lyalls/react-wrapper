//
//  UIPickerViewController.h
//  BaoCai
//
//  Created by 刘国龙 on 16/7/19.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PickerDisplayType) {
    PickerDisplayTypeBankList,
    PickerDisplayTypeAreaList
};

typedef void (^PickerViewDone)(NSMutableArray *selectArray);

@interface UIPickerViewController : UIViewController

@property (nonatomic, strong) PickerViewDone doneBlock;
@property (nonatomic, assign) PickerDisplayType displayType;

@end
