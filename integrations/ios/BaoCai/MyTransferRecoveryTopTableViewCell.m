//
//  MyTransferRecoveryTopTableViewCell.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/7.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "MyTransferRecoveryTopTableViewCell.h"

#import "MyTenderCapitalCollectionViewCell.h"

@interface MyTransferRecoveryTopTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *topLineView;

@property (nonatomic, strong) NSMutableArray *displayArray;

@property (weak, nonatomic) IBOutlet UILabel *changeCapitalWaitLabel;
@property (weak, nonatomic) IBOutlet UILabel *changeInterestWaitLabel;
@property (weak, nonatomic) IBOutlet UILabel *changePeriodLabel;
@property (weak, nonatomic) IBOutlet UILabel *borrowEndTimeLabel;

@end

@implementation MyTransferRecoveryTopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.topLineView.backgroundColor = [UIColor clearColor];
    [self drawDashLineWithLineView:self.topLineView width:Screen_width - 20 lineLength:1 lineSpacing:1 lineColor:RGB_COLOR(242, 242, 242)];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"MyTenderCapitalCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MyTenderCapitalCollectionViewCell"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - Custom Method

- (void)reloadData:(MyTransferListItemModel *)model {
    self.nameLabel.text = model.name;
    
    self.displayArray = [NSMutableArray arrayWithCapacity:0];
    NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic2 setObject:@"购入金额（元）" forKey:@"name"];
    [dic2 setObject:model.transferAmount forKey:@"value"];
    [self.displayArray addObject:dic2];
    
    NSMutableDictionary *dic3 = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic3 setObject:@"债权价值（元）" forKey:@"name"];
    [dic3 setObject:model.creditValue forKey:@"value"];
    [self.displayArray addObject:dic3];
    
    [self.collectionView reloadData];
    
    self.changeCapitalWaitLabel.text = [NSString stringWithFormat:@"%@元", model.changeCapitalWait];
    self.changeInterestWaitLabel.text = [NSString stringWithFormat:@"%@元", model.changeInterestWait];
    self.changePeriodLabel.text = [NSString stringWithFormat:@"%@个月", model.changePeriod];
    self.borrowEndTimeLabel.text = model.borrowEndTime;
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
