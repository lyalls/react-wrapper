//
//  BCMyTransferRecoveryTopTableViewCell.m
//  BaoCai
//
//  Created by 刘国龙 on 2016/11/8.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "BCMyTransferRecoveryTopTableViewCell.h"

#import "BCMyTenderCapitalCollectionViewCell.h"

@interface BCMyTransferRecoveryTopTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *topLineView;

@property (nonatomic, strong) NSMutableArray *displayArray;

@property (nonatomic, strong) UILabel *changeCapitalWaitLabel;
@property (nonatomic, strong) UILabel *changeInterestWaitLabel;
@property (nonatomic, strong) UILabel *changePeriodLabel;
@property (nonatomic, strong) UILabel *borrowEndTimeLabel;

@end

@implementation BCMyTransferRecoveryTopTableViewCell

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
    
    self.topLineView.backgroundColor = [UIColor clearColor];
    [self drawDashLineWithLineView:self.topLineView width:SCREEN_WIDTH - 20 lineLength:1 lineSpacing:1 lineColor:BackViewColor];
}

- (void)setupView {
    self.backgroundColor = BackViewColor;
    self.contentView.backgroundColor = BackViewColor;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.topView];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(10);
        make.right.equalTo(-10);
        make.height.equalTo(130);
    }];
    
    self.topLineView = [[UIView alloc] init];
    self.topLineView.backgroundColor = BackViewColor;
    [self.topView addSubview:self.topLineView];
    
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(1);
        make.top.equalTo(50);
        make.left.right.equalTo(0);
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = Color666666;
    self.nameLabel.font = [UIFont systemFontOfSize:16.0f];
    self.nameLabel.numberOfLines = 2;
    [self.topView addSubview:self.nameLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.bottom.equalTo(self.topLineView.mas_top);
    }];
    
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectNull collectionViewLayout:collectionViewFlowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.bounces = YES;
    self.collectionView.scrollEnabled = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.userInteractionEnabled = NO;
    [self.topView addSubview:self.collectionView];
    
    [self.collectionView registerClass:[BCMyTenderCapitalCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([BCMyTenderCapitalCollectionViewCell class])];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(59);
        make.left.equalTo(0);
        make.right.equalTo(0);
        make.top.equalTo(self.topLineView.mas_bottom);
    }];
    
    [self setupBottomView];
}

- (void)setupBottomView {
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.bottomView];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).mas_offset(10);
        make.left.equalTo(10);
        make.right.equalTo(-10);
        make.bottom.equalTo(0);
    }];
    
    UILabel *benjinLabel = [[UILabel alloc] init];
    benjinLabel.text = @"购入时待收本金：";
    benjinLabel.textColor = Color666666;
    benjinLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.bottomView addSubview:benjinLabel];
    
    [benjinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(5);
    }];
    
    self.changeCapitalWaitLabel = [[UILabel alloc] init];
    self.changeCapitalWaitLabel.textColor = Color999999;
    self.changeCapitalWaitLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.bottomView addSubview:self.changeCapitalWaitLabel];
    
    [self.changeCapitalWaitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(benjinLabel.mas_right);
        make.top.equalTo(5);
    }];
    
    UILabel *lixiLabel = [[UILabel alloc] init];
    lixiLabel.text = @"购入时待收利息：";
    lixiLabel.textColor = Color666666;
    lixiLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.bottomView addSubview:lixiLabel];
    
    [lixiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(benjinLabel.mas_bottom);
        make.height.equalTo(benjinLabel);
    }];
    
    self.changeInterestWaitLabel = [[UILabel alloc] init];
    self.changeInterestWaitLabel.textColor = Color999999;
    self.changeInterestWaitLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.bottomView addSubview:self.changeInterestWaitLabel];
    
    [self.changeInterestWaitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lixiLabel.mas_right);
        make.top.equalTo(self.changeCapitalWaitLabel.mas_bottom);
        make.height.equalTo(self.changeCapitalWaitLabel);
    }];
    
    UILabel *qishuLabel = [[UILabel alloc] init];
    qishuLabel.text = @"购入时剩余期数：";
    qishuLabel.textColor = Color666666;
    qishuLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.bottomView addSubview:qishuLabel];
    
    [qishuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(lixiLabel.mas_bottom);
        make.height.equalTo(benjinLabel);
    }];
    
    self.changePeriodLabel = [[UILabel alloc] init];
    self.changePeriodLabel.textColor = Color999999;
    self.changePeriodLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.bottomView addSubview:self.changePeriodLabel];
    
    [self.changePeriodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(qishuLabel.mas_right);
        make.top.equalTo(self.changeInterestWaitLabel.mas_bottom);
        make.height.equalTo(self.changeCapitalWaitLabel);
    }];
    
    UILabel *daoqiLabel = [[UILabel alloc] init];
    daoqiLabel.text = @"到期时间：";
    daoqiLabel.textColor = Color666666;
    daoqiLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.bottomView addSubview:daoqiLabel];
    
    [daoqiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(10);
        make.top.equalTo(qishuLabel.mas_bottom);
        make.bottom.equalTo(-5);
        make.height.equalTo(benjinLabel);
    }];
    
    self.borrowEndTimeLabel = [[UILabel alloc] init];
    self.borrowEndTimeLabel.textColor = Color999999;
    self.borrowEndTimeLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.bottomView addSubview:self.borrowEndTimeLabel];
    
    [self.borrowEndTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(daoqiLabel.mas_right);
        make.top.equalTo(self.changePeriodLabel.mas_bottom);
        make.height.equalTo(self.changeCapitalWaitLabel);
        make.bottom.equalTo(-5);
    }];
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
    BCMyTenderCapitalCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BCMyTenderCapitalCollectionViewCell class]) forIndexPath:indexPath];
    
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
