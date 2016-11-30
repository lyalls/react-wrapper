//
//  BCHomePropagateTableViewCell.h
//  BaoCai
//
//  Created by 刘国龙 on 2016/10/31.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePropagateItem : NSObject

@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *detailTitle;

@end

@interface BCHomePropagateTableViewCell : UITableViewCell

@end
