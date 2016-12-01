//
//  BCMyTenderItemTableViewCell.m
//  BaoCai
//
//  Created by 刘国龙 on 2016/11/4.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "BCMyTenderItemTableViewCell.h"

#import "BCMyTenderCapitalCollectionViewCell.h"

@interface BCMyTenderItemTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UILabel *tenderNameLabel;
@property (nonatomic, strong) UILabel *recoverTimeLabel;
@property (nonatomic, strong) UILabel *periodLabel;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *displayArray;

@property (nonatomic, strong) CAShapeLayer *border;

@end

@implementation BCMyTenderItemTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutIfNeeded {
    [super layoutIfNeeded];
    
    [self setTopViewBorder:BackViewColor];
}

- (void)setNeedsLayout {
    [super setNeedsLayout];
    
    [self setTopViewBorder:BackViewColor];
}

- (void)setupView {
    self.backgroundColor = BackViewColor;
    self.contentView.backgroundColor = BackViewColor;
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(10);
        make.left.right.bottom.equalTo(0);
    }];
    
    self.tenderNameLabel = [[UILabel alloc] init];
    self.tenderNameLabel.font = [UIFont systemFontOfSize:16.0f];
    self.tenderNameLabel.textColor = Color666666;
    [backView addSubview:self.tenderNameLabel];
    
    [self.tenderNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(10);
        make.right.equalTo(-10);
    }];
    
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectNull collectionViewLayout:collectionViewFlowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.bounces = YES;
    self.collectionView.scrollEnabled = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.userInteractionEnabled = NO;
    [backView addSubview:self.collectionView];
    
    [self.collectionView registerClass:[BCMyTenderCapitalCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([BCMyTenderCapitalCollectionViewCell class])];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(-1);
        make.right.equalTo(1);
        make.top.equalTo(self.tenderNameLabel.mas_bottom).mas_offset(10);
        make.height.equalTo(61);
    }];
    
    self.recoverTimeLabel = [[UILabel alloc] init];
    self.recoverTimeLabel.font = [UIFont systemFontOfSize:11.0f * homeHeightScale];
    self.recoverTimeLabel.textColor = RGB_COLOR(135, 135, 135);
    [backView addSubview:self.recoverTimeLabel];
    
    [self.recoverTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(self.collectionView.mas_bottom).mas_offset(7);
    }];
    
    self.periodLabel = [[UILabel alloc] init];
    self.periodLabel.font = [UIFont systemFontOfSize:11.0f * homeHeightScale];
    self.periodLabel.textColor = RGB_COLOR(135, 135, 135);
    [backView addSubview:self.periodLabel];
    
    [self.periodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(-10);
        make.top.equalTo(self.collectionView.mas_bottom).mas_offset(7);
    }];
}

#pragma mark - Custom method

- (void)reloadData:(MyTenderListItemModel *)model myTenderItemTableViewCellType:(MyTenderItemTableViewCellType)type {
    [self layoutIfNeeded];
    
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
    [self layoutIfNeeded];
    
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
    BCMyTenderCapitalCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BCMyTenderCapitalCollectionViewCell class]) forIndexPath:indexPath];
    
    [cell reloadData:[self.displayArray objectAtIndex:indexPath.row] isEnd:indexPath.row == self.displayArray.count - 1 isCenter:self.displayArray.count == 2];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.collectionView.bounds.size.width / self.displayArray.count, 60);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark - Private method

- (void)setTopViewBorder:(UIColor *)borderColor {
    CAShapeLayer *border1 = [CAShapeLayer layer];
    border1.strokeColor = borderColor.CGColor;
    border1.fillColor = nil;
    border1.path = [UIBezierPath bezierPathWithRect:self.collectionView.bounds].CGPath;
    border1.frame = self.collectionView.bounds;
    border1.lineWidth = 1;
    border1.lineCap = @"square";
    border1.lineDashPattern = @[@2, @2];
    if (self.border) {
        [self.border removeFromSuperlayer];
    }
    [self.collectionView.layer addSublayer:border1];
    
    self.border = border1;
}

@end
