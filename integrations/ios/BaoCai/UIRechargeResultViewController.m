//
//  UIRechargeResultViewController.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/19.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "UIRechargeResultViewController.h"

#import "MyRequest.h"

#import <LLPaySDK/LLPaySdk.h>
#import <CommonCrypto/CommonDigest.h>

@interface UIRechargeResultViewController () <LLPaySdkDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@property (nonatomic, strong) LLPaySdk *llPaySdk;
@property (nonatomic, assign) LLPayResult payResultCode;

@end

@implementation UIRechargeResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self payMethod];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom method

- (IBAction)backBtnClick:(id)sender {
    switch (self.payResultCode) {
        case kLLPayResultSuccess:
        case kLLPayResultCancel: {
            NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
            UIViewController *view = [self.navigationController.viewControllers objectAtIndex:index - 2];
            [self.navigationController popToViewController:view animated:YES];
            break;
        }
        case kLLPayResultFail:
        case kLLPayResultInitError:
        case kLLPayResultInitParamError:
        case kLLPayResultUnknow: {
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
    }
}

- (IBAction)doneBtnClick:(id)sender {
    switch (self.payResultCode) {
        case kLLPayResultSuccess:
        case kLLPayResultCancel: {
            NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
            UIViewController *view = [self.navigationController.viewControllers objectAtIndex:index - 2];
            [self.navigationController popToViewController:view animated:YES];
            break;
        }
        case kLLPayResultFail:
        case kLLPayResultInitError:
        case kLLPayResultInitParamError:
        case kLLPayResultUnknow: {
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
    }
}

- (void)payMethod {
    NSDictionary *dic = [self getLianLianPayParamsWithOrderDic:self.orderDic withCardNum:self.cardNum];
    
    self.llPaySdk = [[LLPaySdk alloc] init]; // 创建
    self.llPaySdk.sdkDelegate = self;  // 设置回调
    [self.llPaySdk presentVerifyPaySdkInViewController:self withTraderInfo:[self partnerSignDicWithParam:dic]];
}

- (NSMutableDictionary *)getLianLianPayParamsWithOrderDic:(NSDictionary *)order withCardNum:(NSString *)cardNum  {
    NSMutableDictionary *orderDic=[NSMutableDictionary dictionary];
    [orderDic setObject:[order stringForKey:@"acctName"] forKey:@"acct_name"];
    [orderDic setObject:[order stringForKey:@"busiPartner"] forKey:@"busi_partner"];
    [orderDic setObject:[order stringForKey:@"idNo"] forKey:@"id_no"];
    [orderDic setObject:[order stringForKey:@"dtOrder"] forKey:@"dt_order"];
    [orderDic setObject:[order stringForKey:@"idType"] forKey:@"id_type"];
    [orderDic setObject:[order stringForKey:@"moneyOrder"] forKey:@"money_order"];
    [orderDic setObject:[order stringForKey:@"noAgree"] forKey:@"no_agree"];
    [orderDic setObject:[order stringForKey:@"noOrder"] forKey:@"no_order"];
    [orderDic setObject:[order stringForKey:@"notifyUrl"] forKey:@"notify_url"];
    [orderDic setObject:[order stringForKey:@"oidPartner"] forKey:@"oid_partner"];
    [orderDic setObject:[order stringForKey:@"signType"] forKey:@"sign_type"];
    [orderDic setObject:[order stringForKey:@"userId"] forKey:@"user_id"];
    
    NSMutableDictionary *riskDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [riskDic setObject:[[order objectForKey:@"riskItem"] stringForKey:@"frmsWareCategory"] forKey:@"frms_ware_category"];
    [riskDic setObject:[[order objectForKey:@"riskItem"] stringForKey:@"userInfoDtRegister"] forKey:@"user_info_dt_register"];
    [riskDic setObject:[[order objectForKey:@"riskItem"] stringForKey:@"userInfoMerchtUserno"] forKey:@"user_info_mercht_userno"];
    [riskDic setObject:[[order objectForKey:@"riskItem"] stringForKey:@"userInfoBindPhone"] forKey:@"user_info_bind_phone"];
    [riskDic setObject:[[order objectForKey:@"riskItem"] stringForKey:@"userInfoFullName"] forKey:@"user_info_full_name"];
    [riskDic setObject:[[order objectForKey:@"riskItem"] stringForKey:@"userInfoIdNo"] forKey:@"user_info_id_no"];
    [riskDic setObject:[[order objectForKey:@"riskItem"] stringForKey:@"userInfoIdentifyState"] forKey:@"user_info_identify_state"];
    [riskDic setObject:[[order objectForKey:@"riskItem"] stringForKey:@"userInfoIdentifyType"] forKey:@"user_info_identify_type"];
    
    NSData *riskData = [riskDic JSONData];
    [orderDic setObject:[[NSString alloc] initWithData:riskData encoding:NSUTF8StringEncoding] forKey:@"risk_item"];
    if (cardNum)
        [orderDic setObject:cardNum forKey:@"card_no"];
    [orderDic setObject:@"充值" forKey:@"name_goods"];
    
    return orderDic;
}

- (NSDictionary*)partnerSignDicWithParam:(NSDictionary *)paramDic {
    NSArray *keyArray = @[@"busi_partner", @"dt_order", @"info_order", @"money_order", @"name_goods", @"no_order", @"notify_url", @"oid_partner", @"risk_item", @"sign_type", @"valid_order"];
    
    NSMutableString *paramString = [NSMutableString stringWithString:@""];
    
    for (NSString *key in keyArray) {
        if ([paramDic[key] length] != 0) {
            [paramString appendFormat:@"&%@=%@", key, paramDic[key]];
        } else if ([key isEqualToString:@"sign_type"]) {
            [paramString appendFormat:@"&%@=%@", key, paramDic[@"partner_sign_type"]];
        }
    }
    
    if ([paramString length] > 1) {
        [paramString deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    
    BOOL bMd5Sign = [paramDic[@"sign_type"] isEqualToString:@"MD5"];
    
    if (bMd5Sign) {
        NSString *pay_md5_key = @"yintong1234567890";
        /*
         正式环境 认证支付测试商户号  201408071000001543
         MD5 key  201408071000001543test_20140812
         
         正式环境 快捷支付测试商户号  201408071000001546
         MD5 key  201408071000001546_test_20140815
         */
        
        //        if ([paramDic[@"oid_partner"] isEqualToString:@"201408071000001543"]) {
        //            pay_md5_key = @"201408071000001543test_20140812";
        //        }
        //        else if ([paramDic[@"oid_partner"] isEqualToString:@"201408071000001546"]) {
        //            pay_md5_key = @"201408071000001546_test_20140815";
        //        }
        if ([paramDic[@"oid_partner"] isEqualToString:@"201409261000043506"]) {
            pay_md5_key = @"Baocai1234qwer";
        }
        
        //        if (self.bTestServer) {
        //            pay_md5_key = @"201103171000000000";
        //            //pay_md5_key = @"md5key_201311062000003548_20131107";
        //        }
        [paramString appendFormat:@"&key=%@", pay_md5_key];
    }
    
    NSString *signedString = [self signString:paramString];
    
    NSMutableDictionary *signedParam = [NSMutableDictionary dictionaryWithDictionary:paramDic];
    signedParam[@"sign"] = signedString;
    // 请求签名	sign	是	String	MD5（除了sign的所有请求参数+MD5key）
    
    return signedParam;
}

- (NSString *)signString:(NSString*)origString {
    const char *original_str = [origString UTF8String];
    unsigned char result[32];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++){
        [hash appendFormat:@"%02x", result[i]];
    }
    
    return hash;
}

#pragma mark - LLPaySdkDelegate

- (void)paymentEnd:(LLPayResult)resultCode withResultDic:(NSDictionary *)dic {
    self.statusImageView.hidden = NO;
    self.titleLabel.hidden = NO;
    self.descLabel.hidden = NO;
    self.doneBtn.hidden = NO;
    switch (resultCode) {
        case kLLPayResultSuccess: {
            SHOWPROGRESSHUD;
            [MyRequest rechargeSyncWithLianLianDic:dic success:^(NSDictionary *dic, BCError *error) {
                HIDDENPROGRESSHUD;
                self.statusImageView.image = [UIImage imageNamed:@"rechargeSuccessed.png"];
                self.titleLabel.text = @"充值成功";
                self.descLabel.text = [NSString stringWithFormat:@"充值金额：%@元", self.rechargeAmount];
                [self.doneBtn setTitle:@"确定" forState:UIControlStateNormal];
            } failure:^(NSError *error) {
                HIDDENPROGRESSHUD;
                self.statusImageView.image = [UIImage imageNamed:@"rechargeSuccess.png"];
                self.titleLabel.text = @"充值成功";
                self.descLabel.text = [NSString stringWithFormat:@"充值金额：%@元", self.rechargeAmount];
            }];
            break;
        }
        case kLLPayResultCancel: {
            self.statusImageView.image = [UIImage imageNamed:@"rechargeFailure.png"];
            self.titleLabel.text = @"支付已取消";
            self.descLabel.text = @"";
            [self.doneBtn setTitle:@"知道了" forState:UIControlStateNormal];
            break;
        }
        case kLLPayResultFail:
        case kLLPayResultInitError:
        case kLLPayResultInitParamError:
        case kLLPayResultUnknow: {
            self.statusImageView.image = [UIImage imageNamed:@"rechargeFailure.png"];
            self.titleLabel.text = @"充值失败";
            self.descLabel.text = [dic objectForKey:@"ret_msg"];
            [self.doneBtn setTitle:@"重  试" forState:UIControlStateNormal];
            break;
        }
    }
    self.payResultCode = resultCode;
}

@end
