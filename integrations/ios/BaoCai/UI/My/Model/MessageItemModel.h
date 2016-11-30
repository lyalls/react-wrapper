//
//  MessageItemModel.h
//  BaoCai
//
//  Created by 刘国龙 on 16/7/8.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageItemModel : NSObject

/**
 *  消息ID
 */
@property (nonatomic, strong) NSString *messageId;
/**
 *  消息标题
 */
@property (nonatomic, strong) NSString *messageTitle;
/**
 *  消息时间
 */
@property (nonatomic, strong) NSString *messageDate;
/**
 *  消息内容
 */
@property (nonatomic, strong) NSString *messageContent;

/**
 * 消息状态
 */
@property (nonatomic,strong) NSString *messageStatus;

- (instancetype)initWithDic:(NSDictionary *)dic;

- (void)reloadData:(NSDictionary *)dic;

@end
