//
//  UIInvestmentViewController.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/8.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "UIInvestmentViewController.h"
#import "UIViewController+WebView.h"
#import "UITraderPasswordViewController.h"
#import "UITenderSuccessViewController.h"
#import "UICheckIDCardViewController.h"
#import "UIRechargeViewController.h"
#import "UIFirstRechargeViewController.h"
#import "UIMyTenderListViewController.h"
#import "UIRealNameViewController.h"
#import "UISetTraderPasswordViewController.h"
#import "CustomIOSAlertView.h"
#import "TenderRequest.h"
#import "UserRequest.h"
#import "MyRequest.h"

#import "RechargeModel.h"
#import "NSArray+Category.h"
#import "NSDictionary+Category.h"
#import "UIWebViewController.h"
#import "SelectCouponInfo.h"

#import <TTTAttributedLabel/TTTAttributedLabel.h>

@interface UIInvestmentViewController () <UITextFieldDelegate, TTTAttributedLabelDelegate> {
    SelectCouponInfo *_couponInfo;
    UIWebView *_webView;
}

@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@property (weak, nonatomic) IBOutlet UITextField *borrowAmountTextFiled;
@property (weak, nonatomic) IBOutlet UILabel *availableAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *availableBalanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *lbcoupon;
@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *protocolLabel;

@property (nonatomic, strong) NSDictionary *dic;

@end

@implementation UIInvestmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _couponInfo = [[SelectCouponInfo alloc] init];
    _couponInfo.investmentHorizon = self.itemModel.investmentHorizon.integerValue;
    _couponInfo.annualRate = self.itemModel.annualRate;
    _couponInfo.increaseApr = self.itemModel.increaseApr;
    _couponInfo.typeNid = self.itemModel.typeNid;
    _couponInfo.isBonusticket = self.itemModel.isBonusticket;
    _couponInfo.isAllowIncrease = self.itemModel.isAllowIncrease;
    _couponInfo.isReward = self.itemModel.isReward;
    _couponInfo.rewardRatio = self.itemModel.rewardRatio;
    _couponInfo.isFeedback = self.itemModel.isFeedback;
    _couponInfo.userFeedBack = self.itemModel.userFeedBack;
    
    _webView = [[UIWebView alloc] init];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", self.webPath, @"tou.html"]]]];
    [self.view addSubview:_webView];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.borrowAmountTextFiled addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self setupForDismissKeyboard];
    
    self.doneBtn.layer.cornerRadius = 4;
    if (self.itemModel.isFull && self.itemModel.isFullThreshold) {
        [self.doneBtn setTitle:@"抢满标" forState:UIControlStateNormal];
    } else {
        [self.doneBtn setTitle:@"立即投资" forState:UIControlStateNormal];
    }
    
    SHOWPROGRESSHUD;
    [TenderRequest getTenderAvailableAmountAndBalanceWithTenderId:self.itemModel.tenderId success:^(NSDictionary *dic, BCError *error) {
        HIDDENPROGRESSHUD;
        if (error.code == 0) {
            self.availableAmountLabel.text = [NSString stringWithFormat:@"%@元", [dic objectForKey:@"availableAmount"]];
            self.availableBalanceLabel.text = [NSString stringWithFormat:@"%@元", [dic objectForKey:@"availableBalance"]];
            
            _couponInfo.isFirstTender = [dic boolForKey:@"isFirstTender"];
            [TenderRequest getIncreaseList:^(NSDictionary *dic, BCError *error) {
                if (error.code == 0) {
                    _couponInfo.increaseList = [dic mutableArrayValueForKey:@"list"];
                    [TenderRequest getBonusList:^(NSDictionary *dic, BCError *error) {
                        if (error.code == 0) {
                            _couponInfo.bounsList = [dic mutableArrayValueForKey:@"list"];
                            //初始化
                            NSString *cmd = [NSString stringWithFormat:@"App.investing.init(%@,%@,%@)", [_couponInfo.transToDict toString], [_couponInfo.bounsList toString], [_couponInfo.increaseList toString]];
                            [_webView stringByEvaluatingJavaScriptFromString:cmd];
                        }
                    } failure:^(NSError *error) {
                        
                    }];
                }
            } failure:^(NSError *error) {
                
            }];
            
            self.protocolLabel.delegate = self;
            self.protocolLabel.textColor = RGB_COLOR(153, 153, 153);
            self.protocolLabel.font = [UIFont systemFontOfSize:14.0f];
            self.protocolLabel.linkAttributes =[NSDictionary dictionaryWithObjectsAndKeys:RGB_COLOR(0, 122, 255), (__bridge NSString *)kCTForegroundColorAttributeName, nil];
            if ([dic mutableArrayValueForKey:@"protocolList"].count == 1) {
                NSDictionary *protocolDic = [[dic mutableArrayValueForKey:@"protocolList"] objectAtIndex:0];
                self.protocolLabel.text = [NSString stringWithFormat:@"我同意按《%@》的格式和条款生成借款合同", [protocolDic objectForKey:@"protocolName"]];
                NSRange range = [self.protocolLabel.text rangeOfString:[NSString stringWithFormat:@"《%@》", [protocolDic objectForKey:@"protocolName"]]];
                [self.protocolLabel addLinkToURL:[[protocolDic objectForKey:@"protocolUrl"] toURL] withRange:range];
            } else {
                NSDictionary *protocolDic1 = [[dic mutableArrayValueForKey:@"protocolList"] objectAtIndex:0];
                NSDictionary *protocolDic2 = [[dic mutableArrayValueForKey:@"protocolList"] objectAtIndex:1];
                self.protocolLabel.text = [NSString stringWithFormat:@"我同意按《%@》和《%@》的格式和条款生成借款合同", [protocolDic1 objectForKey:@"protocolName"], [protocolDic2 objectForKey:@"protocolName"]];
                NSRange range = [self.protocolLabel.text rangeOfString:[NSString stringWithFormat:@"《%@》", [protocolDic1 objectForKey:@"protocolName"]]];
                [self.protocolLabel addLinkToURL:[[protocolDic1 objectForKey:@"protocolUrl"] toURL] withRange:range];
                
                NSRange range1 = [self.protocolLabel.text rangeOfString:[NSString stringWithFormat:@"《%@》", [protocolDic2 objectForKey:@"protocolName"]]];
                [self.protocolLabel addLinkToURL:[[protocolDic2 objectForKey:@"protocolUrl"] toURL] withRange:range1];
            }
            [self.protocolLabel sizeToFit];
        }
    } failure:^(NSError *error) {
        HIDDENPROGRESSHUD;
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self getTenderAvailableAmountAndBalance];
}

- (void)getTenderAvailableAmountAndBalance {
    [TenderRequest getTenderAvailableAmountAndBalanceWithTenderId:self.itemModel.tenderId success:^(NSDictionary *dic, BCError *error) {
        if (error.code == 0) {
            self.availableAmountLabel.text = [NSString stringWithFormat:@"%@元", [dic objectForKey:@"availableAmount"]];
            self.availableBalanceLabel.text = [NSString stringWithFormat:@"%@元", [dic objectForKey:@"availableBalance"]];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Method

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneBtnClick:(id)sender {
    [self.borrowAmountTextFiled resignFirstResponder];
    NSString *borrowAmount = self.borrowAmountTextFiled.text;
    
    if (borrowAmount.length == 0) {
        SHOWTOAST(@"请输入投资金额");
        return;
    }
    if (borrowAmount.intValue == 0) {
        SHOWTOAST(@"投资金额不能为零");
        return;
    }
    if (borrowAmount.intValue % (int)100 != 0.0f) {
        SHOWTOAST(@"输入金额必须是100的倍数");
        return;
    }
    if (self.itemModel.tenderMax.integerValue) {
        if (borrowAmount.integerValue > self.itemModel.tenderMax.integerValue) {
            NSString *string = [NSString stringWithFormat:@"此标的最大投资金额不能超过%@元", self.itemModel.tenderMax];
            SHOWTOAST(string);
            return;
        }
    }
    if (borrowAmount.integerValue > self.availableAmountLabel.text.integerValue) {
        SHOWTOAST(@"投资金额不能大于剩余可投");
        return;
    }
    if (!self.checkBtn.selected) {
        SHOWTOAST(@"请同意借款合同");
        return;
    }
    
    [MobClick event:@"investment_genre1_ui_invest" label:@"散标投资页_投资按钮"];
    SHOWPROGRESSHUD;
    [TenderRequest getTenderUserStatusWithSuccess:^(NSDictionary *dic, BCError *error) {
        HIDDENPROGRESSHUD;
        if (error.code == 0) {
            if (self.availableBalanceLabel.text.floatValue < borrowAmount.floatValue) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"你的可用金额不足，是否立即充值？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"前往", nil];
                [alertView show];
                [alertView clickedButtonEvent:^(NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        [self toRechargeBtnClick:nil];
                    }
                }];
            } else {
                UITraderPasswordViewController *view = [self getControllerByMainStoryWithIdentifier:@"UITraderPasswordViewController"];
                view.itemModel = self.itemModel;
                view.borrowAmount = self.borrowAmountTextFiled.text;
                view.activityCode = self.activityCode;
                view.increaseId = [NSNumber numberWithInteger:_couponInfo.increaseId];
                view.bonusId = [NSNumber numberWithInteger:_couponInfo.bonusId];
                view.paySuccess = ^(NSDictionary *dic) {
                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    
                    UINavigationController *nav = [mainStoryboard instantiateViewControllerWithIdentifier:@"TenderSuccessNav"];
                    UITenderSuccessViewController *view = (UITenderSuccessViewController *)nav.topViewController;
                    view.successMessage = [[dic objectForKey:@"error"] objectForKey:@"message"];
                    view.sharebtnIsShow = [dic boolForKey:@"show_share"];
                    view.sharebtnImageUrl = [dic objectForKey:@"show_share_img"];
                    view.shareTitle = [dic objectForKey:@"title"];
                    view.shareDesc = [dic objectForKey:@"msg"];
                    view.shareUrl = [dic objectForKey:@"url"];
                    view.shareImageUrl = [dic objectForKey:@"icon"];
                    view.callback = ^(int type) {
                        if (type) {
                            UIMyTenderListViewController *viewController = [self getControllerByMainStoryWithIdentifier:@"UIMyTenderListViewController"];
                            viewController.showPageIndex = 1;
                            viewController.isPopToRootViewController = YES;
                            [self.navigationController pushViewController:viewController animated:YES];
                        } else {
                            [self.tabBarController setSelectedIndex:1];
                            [self.navigationController popToRootViewControllerAnimated:NO];
                        }
                    };
                    [self presentViewController:nav animated:YES completion:nil];
                };
                view.cancelRecharge = ^() {
                    [self getTenderAvailableAmountAndBalance];
                };
                view.toRecharge = ^() {
                    [self toRechargeBtnClick:nil];
                };
                view.backTenderList = ^() {
                    [self.tabBarController setSelectedIndex:1];
                    [self.navigationController popToRootViewControllerAnimated:NO];
                    [[NSNotificationCenter defaultCenter] postNotificationName:RefreshTenderNotification object:nil];
                };
                view.backTenderDetail = ^() {
                    [self.navigationController popViewControllerAnimated:YES];
                };
                view.forgetPasswordBlock = ^() {
                    UICheckIDCardViewController *viewController = [self getControllerByMainStoryWithIdentifier:@"UICheckIDCardViewController"];
                    [self.navigationController pushViewController:viewController animated:YES];
                };
                [self presentTranslucentViewController:view animated:YES];
            }
        } else if (error.code == 2001) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"未进行实名认证" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"立即认证", nil];
            [alertView show];
            [alertView clickedButtonEvent:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    UIRealNameViewController *view = [self getControllerByMainStoryWithIdentifier:@"UIRealNameViewController"];
                    [self.navigationController pushViewController:view animated:YES];
                }
            }];
        } else if (error.code == 2002) {
            SHOWTOAST(@"实名认证审核中");
        } else if (error.code == 2003) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请先设置交易密码" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"立即设置", nil];
            [alertView show];
            [alertView clickedButtonEvent:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    UISetTraderPasswordViewController *view = [self getControllerByMainStoryWithIdentifier:@"UISetTraderPasswordViewController"];
                    [self.navigationController pushViewController:view animated:YES];
                }
            }];
        } else {
            SHOWTOAST(error.message);
        }
    } failure:^(NSError *error) {
        HIDDENPROGRESSHUD;
        SHOWTOAST(@"立即投资失败，请稍后再试");
    }];
}

- (IBAction)tenderCalculatorBtnClick:(id)sender {
    [self.borrowAmountTextFiled resignFirstResponder];
    NSString *borrowAmount = self.borrowAmountTextFiled.text;
    
    if (borrowAmount.length == 0) {
        SHOWTOAST(@"请输入投资金额");
        return;
    }
    if (borrowAmount.intValue == 0) {
        SHOWTOAST(@"投资金额不能为零");
        return;
    }
    
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    [alertView show:@"收益计算" message:[[self.dic mutableArrayValueForKey:@"gainCalcDesc"] componentsJoinedByString:@"\n"]];
}

- (IBAction)checkBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)toRechargeBtnClick:(id)sender {
    SHOWPROGRESSHUD;
    [UserRequest userCheckAuthenticationStatus:^(NSDictionary *dic, BCError *error) {
        if (error.code == 0 || error.code == 2003) {
            [MyRequest getRechargeStatusWithSuccess:^(NSDictionary *dic, BCError *error) {
                HIDDENPROGRESSHUD;
                if (error.code == 0) {
                    RechargeModel *model = [[RechargeModel alloc] initWithDic:dic];
                    if (model.isNotFirstRecharge) {
                        UIRechargeViewController *view = [self getControllerByMainStoryWithIdentifier:@"UIRechargeViewController"];
                        view.model = model;
                        [self.navigationController pushViewController:view animated:YES];
                    } else {
                        UIFirstRechargeViewController *view = [self getControllerByMainStoryWithIdentifier:@"UIFirstRechargeViewController"];
                        view.model = model;
                        [self.navigationController pushViewController:view animated:YES];
                    }
                } else {
                    SHOWTOAST(error.message);
                }
            } failure:^(NSError *error) {
                HIDDENPROGRESSHUD;
            }];
        } else if (error.code == 2001) {
            HIDDENPROGRESSHUD;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"未进行实名认证" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"立即认证", nil];
            [alertView show];
            [alertView clickedButtonEvent:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    UIRealNameViewController *view = [self getControllerByMainStoryWithIdentifier:@"UIRealNameViewController"];
                    [self.navigationController pushViewController:view animated:YES];
                }
            }];
        } else if (error.code == 2002) {
            HIDDENPROGRESSHUD;
            SHOWTOAST(@"实名认证审核中");
        } else {
            HIDDENPROGRESSHUD;
        }
    } failure:^(NSError *error) {
        HIDDENPROGRESSHUD;
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.borrowAmountTextFiled) {
        [self doneBtnClick:nil];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.borrowAmountTextFiled) {
        if ([textField.text length]) {
            textField.text = [NSString stringWithFormat:@"%d", [textField.text intValue]];
        }
    }
}

- (void)textFieldDidChange:(UITextField *)textField {
    _couponInfo.investCount = [textField.text integerValue];
    //选择优惠券
    NSString *cmd = [NSString stringWithFormat:@"App.investing.showBonus(%ld)", _couponInfo.investCount];
    NSDictionary *res = [[_webView stringByEvaluatingJavaScriptFromString:cmd] cdv_JSONObject];
    
    NSMutableString *string = [NSMutableString string];
    if (![res objectForKey:@"increaseId"] || [res objectForKey:@"increaseId"] == [NSNull null]) {
        _couponInfo.increaseId = 0;
    } else {
        _couponInfo.increaseId = [res integerForKey:@"increaseId"];
        for (NSDictionary *dic in _couponInfo.increaseList) {
            if ([dic integerForKey:@"id"] == _couponInfo.increaseId) {
                [string appendFormat:@"加息%@%% ", [dic stringForKey:@"apr"]];
                break;
            }
        }
    }
    if (![res objectForKey:@"bonusId"] || [res objectForKey:@"bonusId"] == [NSNull null]) {
        _couponInfo.bonusId = 0;
    } else {
        _couponInfo.bonusId = [res integerForKey:@"bonusId"];
        for (NSDictionary *dic in _couponInfo.bounsList) {
            if ([dic integerForKey:@"id"] == _couponInfo.bonusId) {
                [string appendFormat:@"%@元红包", [dic stringForKey:@"money"]];
                break;
            }
        }
    }
    self.lbcoupon.text = string;
    //收益计算
    NSString *incomeCmd = [NSString stringWithFormat:@"App.investing.showIncome(%ld,%ld,%ld)", _couponInfo.investCount, _couponInfo.bonusId, _couponInfo.increaseId];
    NSDictionary *incomeRes = [[_webView stringByEvaluatingJavaScriptFromString:incomeCmd] cdv_JSONObject];
    
    self.incomeLabel.text = [incomeRes stringForKey:@"income"];
    self.dic = incomeRes;
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    if (url) {
        [self openWebBrowserWithUrl:url.absoluteString];
    }
}

#pragma mark - Table view data source

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 || indexPath.row == 3) {
        return 10;
    } else if (indexPath.row == 5) {
        return (self.itemModel.isAllowIncrease || self.itemModel.isBonusticket) ? 10 : 0;
    } else if (indexPath.row == 6) {
        return (self.itemModel.isAllowIncrease || self.itemModel.isBonusticket) ? 50 : 0;
    } else if (indexPath.row == 7) {
        return 246;
    }
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 6) {
        UIWebViewController *view = [[UIWebViewController alloc] init];
        view.title = [NSString stringWithFormat:@"投资%ld元", _couponInfo.investCount];
        view.staticTitle = YES;
        view.req = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@", self.webPath, @"index.html"]]];
        __weak UIWebViewController *weakview = view;
        [view addEventHandler:@"page_Load" WebEventHandller:^(id param, NSString *callbackId) {
            [weakview JSCallback:callbackId param:_couponInfo.transToDict];
        }];
        [view addEventHandler:@"coupons_Done" WebEventHandller:^(id param, NSString *callbackId) {
            [self.navigationController popViewControllerAnimated:YES];
            
            NSMutableString *string = [NSMutableString string];
            BOOL isNotUserIncrease = NO;
            BOOL isNotCanIncrease = NO;
            BOOL isNotUserBonus = NO;
            BOOL isNotCanBonus = NO;
            if ([param objectForKey:@"increase"]) {
                NSDictionary *dic = [param objectForKey:@"increase"];
                _couponInfo.increaseId = [dic integerForKey:@"id"];
                if (_couponInfo.increaseId) {
                    [string appendFormat:@"加息%@%% ", [dic stringForKey:@"apr"]];
                } else {
                    isNotUserIncrease = YES;
                }
            } else {
                isNotCanIncrease = YES;
            }
            if ([param objectForKey:@"bouns"]) {
                NSDictionary *dic = [param objectForKey:@"bouns"];
                _couponInfo.bonusId = [dic integerForKey:@"id"];
                if (_couponInfo.bonusId) {
                    [string appendFormat:@"%@元红包", [dic stringForKey:@"money"]];
                } else {
                    isNotUserBonus = YES;
                }
            } else {
                isNotCanBonus = YES;
            }
            if ((isNotUserIncrease && isNotUserBonus) || (isNotUserIncrease && isNotCanBonus) || (isNotUserBonus && isNotCanIncrease)) {
                self.lbcoupon.text = @"不使用";
            } else {
                self.lbcoupon.text = string;
            }
            //收益计算
            NSString *incomeCmd = [NSString stringWithFormat:@"App.investing.showIncome(%ld,%ld,%ld)", _couponInfo.investCount, _couponInfo.bonusId, _couponInfo.increaseId];
            NSDictionary *incomeRes = [[_webView stringByEvaluatingJavaScriptFromString:incomeCmd] cdv_JSONObject];
            
            self.incomeLabel.text = [incomeRes stringForKey:@"income"];
            self.dic = incomeRes;
        }];
        [self.navigationController pushViewController:view animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if (indexPath.row == 7) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 999999, 0, 0)];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 999999, 0, 0)];
        }
    }
}

@end
