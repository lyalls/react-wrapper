//
//  BCTextFieldTableViewCell.h
//  BaoCai
//
//  Created by 刘国龙 on 2016/11/9.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCTextFieldTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *textField;

- (void)reloadCellWithTitle:(NSString *)title textFieldPlaceholder:(NSString *)textFieldPlaceholder;

@end
