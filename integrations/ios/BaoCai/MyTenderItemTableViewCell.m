//
//  MyTenderItemTableViewCell.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/6.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "MyTenderItemTableViewCell.h"

#import "MyTenderCapitalCollectionViewCell.h"

@interface MyTenderItemTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIView *topLineView;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@property (weak, nonatomic) IBOutlet UILabel *tenderNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *recoverTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *periodLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *displayArray;

@end

@implementation MyTenderItemTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.recoverTimeLabel.font = [UIFont systemFontOfSize:11 * homeHeightScale];
    self.periodLabel.font = [UIFont systemFontOfSize:11 * homeHeightScale];
    
    self.topLineView.backgroundColor = [UIColor clearColor];
    self.bottomLineView.backgroundColor = [UIColor clearColor];
    [self drawDashLineWithLineView:self.topLineView width:Screen_width - 20 lineLength:1 lineSpacing:1 lineColor:RGB_COLOR(242, 242, 242)];
    [self drawDashLineWithLineView:self.bottomLineView width:Screen_width - 20 lineLength:1 lineSpacing:1 lineColor:RGB_COLOR(242, 242, 242)];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"MyTenderCapitalCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MyTenderCapitalCollectionViewCell"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - Custom Method

- (void)reloadData:(MyTenderListItemModel *)model myTenderItemTableViewCellType:(MyTenderItemTableViewCellType)type {
    self.tenderNameLabel.text = model.name;
    
    self.displayArray = [NSMutableArray arrayWithCapacity:0];
    
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic1 setObject:@"投资本金（元）" forKey:@"name"];
    [dic1 setObject:model.investmentAmount forKey:@"value"];
    [self.displayArray addObject:dic1];
    
    switch (type) {
        case MyTenderItemTableViewCellTypeRecovery: {
            self.recoverTimeLabel.text = [NSString stringWithFormat:@"最近还款日期：%@", model.recoverTime];
            self.periodLabel.text = [NSString stringWithFormat:@"已还%@期/共%@期", model.recoverNum, model.borrowPeriod];
            
            NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithCapacity:0];
            [dic2 setObject:@"已收本息（元）" forKey:@"name"];
            [dic2 setObject:model.receivingPrincipalInterest forKey:@"value"];
            [self.displayArray addObject:dic2];
            
            NSMutableDictionary *dic3 = [NSMutableDictionary dictionaryWithCapacity:0];
            [dic3 setObject:@"待收本息（元）" forKey:@"name"];
            [dic3 setObject:model.stayPrincipalInterest forKey:@"value"];
            [self.displayArray addObject:dic3];
            
            break;
        }
        case MyTenderItemTableViewCellTypeTender: {
            self.recoverTimeLabel.text = [NSString stringWithFormat:@"投标日期：%@", model.tenderTime];
            self.periodLabel.text = @"";
            
            NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithCapacity:0];
            [dic2 setObject:@"年利率" forKey:@"name"];
            [dic2 setObject:model.annualRate forKey:@"value"];
            [self.displayArray addObject:dic2];
            
            break;
        }
        case MyTenderItemTableViewCellTypeAlreadyRecovery: {
            self.recoverTimeLabel.text = [NSString stringWithFormat:@"结清日期：%@", model.repayLastTime];
            self.periodLabel.text = [NSString stringWithFormat:@"共%@期", model.borrowPeriod];
            
            NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithCapacity:0];
            [dic2 setObject:@"已收本息（元）" forKey:@"name"];
            [dic2 setObject:model.receivingPrincipalInterest forKey:@"value"];
            [self.displayArray addObject:dic2];
            
            break;
        }
    }
    
    [self.collectionView reloadData];
}

- (void)reloadData:(MyTransferListItemModel *)model myTransferItemTableViewCellType:(MyTransferItemTableViewCellType)type {
    self.tenderNameLabel.text = model.name;
    
    self.displayArray = [NSMutableArray arrayWithCapacity:0];
    
    switch (type) {
        case MyTransferItemTableViewCellTypeTransfer: {
            self.recoverTimeLabel.text = [NSString stringWithFormat:@"转让操作日期:%@", model.transferTime];
            self.periodLabel.text = @"";
            
            NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithCapacity:0];
            [dic2 setObject:@"投资本金（元）" forKey:@"name"];
            [dic2 setObject:model.investmentAmount forKey:@"value"];
            [self.displayArray addObject:dic2];
            
            NSMutableDictionary *dic3 = [NSMutableDictionary dictionaryWithCapacity:0];
            [dic3 setObject:@"转让价格（元）" forKey:@"name"];
            [dic3 setObject:model.transferAmount forKey:@"value"];
            [self.displayArray addObject:dic3];
            
            NSMutableDictionary *dic4 = [NSMutableDictionary dictionaryWithCapacity:0];
            [dic4 setObject:@"手续费（元）" forKey:@"name"];
            [dic4 setObject:model.counterFee forKey:@"value"];
            [self.displayArray addObject:dic4];
            break;
        }
        case MyTransferItemTableViewCellTypeTurnOut: {
            self.recoverTimeLabel.text = [NSString stringWithFormat:@"转让成功日期:%@", model.transferTime];
            self.periodLabel.text = @"";
            
            NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithCapacity:0];
            [dic2 setObject:@"投资本金（元）" forKey:@"name"];
            [dic2 setObject:model.investmentAmount forKey:@"value"];
            [self.displayArray addObject:dic2];
            
            NSMutableDictionary *dic3 = [NSMutableDictionary dictionaryWithCapacity:0];
            [dic3 setObject:@"转让价格（元）" forKey:@"name"];
            [dic3 setObject:model.transferAmount forKey:@"value"];
            [self.displayArray addObject:dic3];
            
            NSMutableDictionary *dic4 = [NSMutableDictionary dictionaryWithCapacity:0];
            [dic4 setObject:@"手续费（元）" forKey:@"name"];
            [dic4 setObject:model.counterFee forKey:@"value"];
            [self.displayArray addObject:dic4];
            break;
        }
        case MyTransferItemTableViewCellTypeRecovery: {
            self.recoverTimeLabel.text = [NSString stringWithFormat:@"最近还款日期:%@", model.recoverTime];
            self.periodLabel.text = [NSString stringWithFormat:@"剩余%@期", model.recoverNum];
            
            NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithCapacity:0];
            [dic2 setObject:@"购入金额（元）" forKey:@"name"];
            [dic2 setObject:model.transferAmount forKey:@"value"];
            [self.displayArray addObject:dic2];
            
            NSMutableDictionary *dic3 = [NSMutableDictionary dictionaryWithCapacity:0];
            [dic3 setObject:@"已收本息（元）" forKey:@"name"];
            [dic3 setObject:model.receivingPrincipalInterest forKey:@"value"];
            [self.displayArray addObject:dic3];
            
            NSMutableDictionary *dic4 = [NSMutableDictionary dictionaryWithCapacity:0];
            [dic4 setObject:@"待收本息（元）" forKey:@"name"];
            [dic4 setObject:model.stayPrincipalInterest forKey:@"value"];
            [self.displayArray addObject:dic4];
            break;
        }
        case MyTransferItemTableViewCellTypeAlreadyRecovery: {
            self.recoverTimeLabel.text = [NSString stringWithFormat:@"结清日期:%@", model.repayLastTime];
            self.periodLabel.text = @"";
            
            NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithCapacity:0];
            [dic2 setObject:@"购入金额（元）" forKey:@"name"];
            [dic2 setObject:model.transferAmount forKey:@"value"];
            [self.displayArray addObject:dic2];
            
            NSMutableDictionary *dic3 = [NSMutableDictionary dictionaryWithCapacity:0];
            [dic3 setObject:@"已收本息（元）" forKey:@"name"];
            [dic3 setObject:model.receivingPrincipalInterest forKey:@"value"];
            [self.displayArray addObject:dic3];
            break;
        }
    }
    
    [self.collectionView reloadData];
}

#pragma mark - Collection view data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.displayArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyTenderCapitalCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyTenderCapitalCollectionViewCell" forIndexPath:indexPath];
    
    [cell reloadData:[self.displayArray objectAtIndex:indexPath.row] isEnd:indexPath.row == self.displayArray.count - 1 isCenter:self.displayArray.count == 2];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.collectionView.bounds.size.width / self.displayArray.count, 59);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark - Private method

- (void)drawDashLineWithLineView:(UIView *)lineView width:(CGFloat)width lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.bounds) / 2, CGRectGetHeight(lineView.bounds))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.bounds)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, width, 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}

@end
