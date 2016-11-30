//
//  UIInvestmentViewController.m
//  BaoCai
//
//  Created by 刘国龙 on 16/7/8.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
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
#import "BaseData.h"
#import <TTTAttributedLabel/TTTAttributedLabel.h>


@interface CouponsModel : BaseData
@property NSArray* bounsList;
@property NSArray* increaseList;
@property NSNumber* investCount;
@property BOOL isFirstTender;
@property BOOL isAllowIncrease;
@property BOOL isBonusticket;
@property NSNumber* bonusId;
@property NSNumber* increaseId;
@property NSNumber* investmentHorizon;
@end


@implementation CouponsModel
@end

@interface UIInvestmentViewController () <UITextFieldDelegate, TTTAttributedLabelDelegate,UIAlertViewDelegate>
{
    UIWebView* webView;
    BOOL isFirstTender;
    NSArray* bonusList;
    NSArray* increaseList;
    NSNumber* increaseId;
    NSNumber* bonusId;
    CouponsModel* couponsData;
}

@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@property (weak, nonatomic) IBOutlet UITextField *borrowAmountTextFiled;
@property (weak, nonatomic) IBOutlet UILabel *availableAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *availableBalanceLabel;

@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *protocolLabel;

@property (nonatomic, strong) NSString *availableBalance;
@property (weak, nonatomic) IBOutlet UILabel *lbcoupon;

@end

@implementation UIInvestmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    couponsData = [[CouponsModel alloc] init];
    couponsData.isBonusticket = self.itemModel.isBonusticket;
    couponsData.isAllowIncrease = self.itemModel.isAllowIncrease;
    couponsData.investCount = [NSNumber numberWithInteger:0];
    couponsData.bonusId = [NSNumber numberWithInteger:0];
    couponsData.increaseId = [NSNumber numberWithInteger:0];
    couponsData.investmentHorizon = [NSNumber numberWithInteger:[self.itemModel.investmentHorizon integerValue]];
    //加载js
    webView = [[UIWebView alloc] init];
    [self.view addSubview:webView];
    
    
    NSURL* url = [[NSURL alloc] initFileURLWithPath:[NSString stringWithFormat:@"%@%@",[self webPath],@"tou.html"]];
    //url = [NSURL URLWithString:@"http://192.168.5.217:3000/tou.html"];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [_borrowAmountTextFiled addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
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
            self.availableBalance = [dic objectForKey:@"availableBalance"];
            self.availableAmountLabel.text = [NSString stringWithFormat:@"%@元", [dic objectForKey:@"availableAmount"]];
            self.availableBalanceLabel.text = [NSString stringWithFormat:@"%@元", [dic objectForKey:@"availableBalance"]];
            
            isFirstTender = [[dic objectForKey:@"isFirstTender"] boolValue];
            couponsData.isFirstTender = isFirstTender;
            //获取红包卷、加息卷
            [TenderRequest getIncreaseList:^(NSDictionary *dic, BCError *error) {
                NSLog(@"increase list:%@",dic);
                increaseList = [dic objectForKey:@"list"];
                couponsData.increaseList = increaseList;
                //获取红包卷、加息卷
                [TenderRequest getBonusList:^(NSDictionary *dic, BCError *error) {
                    NSLog(@"bonus list:%@",dic);
                    bonusList = [dic objectForKey:@"list"];
                    couponsData.bounsList = bonusList;
                    //初始化
                    NSDictionary* dict = @{@"isAllowIncrease":[NSNumber numberWithBool:self.itemModel.isAllowIncrease],
                                           @"isBonusticket":[NSNumber numberWithBool:self.itemModel.isBonusticket],
                                           @"isFirstTender":[NSNumber numberWithBool:isFirstTender],
                                           @"investmentHorizon":couponsData.investmentHorizon};
                    NSString* commStr = [NSString stringWithFormat:@"App.investing.init(%@,%@,%@)",
                                         [dict toString],[bonusList JSONString],[increaseList JSONString]];
                    NSLog(@"comm:%@",commStr);
                    [webView stringByEvaluatingJavaScriptFromString:commStr];
                } failure:^(NSError *error) {
                    bonusList = [[NSArray alloc] init];
                }];
            } failure:^(NSError *error) {
                increaseList = [[NSArray alloc] init];
            }];
            
            self.protocolLabel.delegate = self;
            self.protocolLabel.textColor = Color999999;
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
            self.availableBalance = [dic objectForKey:@"availableBalance"];
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
    if (borrowAmount.intValue % (int)100 != 0.0f) {
        SHOWTOAST(@"输入金额必须是100的倍数");
        return;
    }
    if (borrowAmount.intValue < 100) {
        SHOWTOAST(@"输入金额不能小于100");
        return;
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
            if (self.availableBalance.floatValue < borrowAmount.floatValue) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"你的可用金额不足，是否立即充值？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"前往", nil];
                [alertView show];
                [alertView clickedButtonEvent:^(NSInteger buttonIndex) {
                    if (buttonIndex == 1) {
                        [self toRechargeBtnClick:nil];
                    }
                }];
            } else {
                UITraderPasswordViewController *view = [self getControllerByStoryBoardType:StoryBoardTypeTender identifier:@"UITraderPasswordViewController"];
                view.itemModel = self.itemModel;
                view.borrowAmount = self.borrowAmountTextFiled.text;
                view.activityCode = self.activityCode;
                view.increaseId = increaseId;
                view.bonusId = bonusId;
                view.paySuccess = ^(NSDictionary *dic) {
                    UINavigationController *nav = [self getControllerByStoryBoardType:StoryBoardTypeTender identifier:@"TenderSuccessNav"];
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
                            UIMyTenderListViewController *viewController = [[UIMyTenderListViewController alloc] init];
                            viewController.hidesBottomBarWhenPushed = YES;
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
                    UICheckIDCardViewController *viewController = [self getControllerByStoryBoardType:StoryBoardTypeTender identifier:@"UICheckIDCardViewController"];
                    [self.navigationController pushViewController:viewController animated:YES];
                };
                [self presentTranslucentViewController:view animated:YES];
            }
        } else if (error.code == 2001) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"未进行实名认证" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"立即认证", nil];
            [alertView show];
            [alertView clickedButtonEvent:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    UIRealNameViewController *view = [self getControllerByStoryBoardType:StoryBoardTypeAccountSecurity identifier:@"UIRealNameViewController"];
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
                    UISetTraderPasswordViewController *view = [self getControllerByStoryBoardType:StoryBoardTypeAccountSecurity identifier:@"UISetTraderPasswordViewController"];
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
    if (borrowAmount.intValue % (int)100 != 0.0f) {
        SHOWTOAST(@"输入金额必须是100的倍数");
        return;
    }
    if (borrowAmount.intValue < 100) {
        SHOWTOAST(@"输入金额不能小于100");
        return;
    }
    
    [MobClick event:@"investment_genre1_ui_reckon" label:@"散标投资页_收益预估按钮"];
    SHOWPROGRESSHUD;
    if(bonusId == nil)
    {
        bonusId = [NSNumber numberWithInt:0];
    }
    if(increaseId == nil)
    {
        increaseId = [NSNumber numberWithInt:0];
    }
    //收益计算添加
    [TenderRequest getTenderCalculatorWithTenderId:self.itemModel.tenderId borrowAmount:self.borrowAmountTextFiled.text bonusId:bonusId increaseId:increaseId success:^(NSDictionary *dic, BCError *error) {
        HIDDENPROGRESSHUD;
        if (error.code == 0) {
            CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
            [alertView show:@"收益计算" message:[[dic mutableArrayValueForKey:@"gainCalcDesc"] componentsJoinedByString:@"\n"]];
        } else {
            SHOWTOAST(error.message);
        }
    } failure:^(NSError *error) {
        HIDDENPROGRESSHUD;
        SHOWTOAST(@"投资计算失败，请稍后再试");
    }];
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
                        UIRechargeViewController *view = [self getControllerByStoryBoardType:StoryBoardTypeRecharge identifier:@"UIRechargeViewController"];
                        view.model = model;
                        [self.navigationController pushViewController:view animated:YES];
                    } else {
                        UIFirstRechargeViewController *view = [self getControllerByStoryBoardType:StoryBoardTypeRecharge identifier:@"UIFirstRechargeViewController"];
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
                    UIRealNameViewController *view = [self getControllerByStoryBoardType:StoryBoardTypeAccountSecurity identifier:@"UIRealNameViewController"];
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

- (void) textFieldDidChange:(UITextField*) textField {
    if([textField.text length])
    {
       NSString* count = [NSString stringWithFormat:@"%d", [textField.text intValue]];
       couponsData.investCount = [NSNumber numberWithInt:[count intValue]];
       NSString* cmd = [NSString stringWithFormat:@"App.investing.showBonus(%@)",count];
       NSDictionary* res = [[webView stringByEvaluatingJavaScriptFromString:cmd] toJSONObject];
        int num = 0;
        NSLog(@"res:%@",res);
        
        if(![res valueForKey:@"bonusId"] || [res valueForKey:@"bonusId"] == [NSNull null])
        {
            bonusId = [NSNumber numberWithInt:0];


        }
        else
        {
            num++;
            bonusId = [res valueForKey:@"bonusId"];
            couponsData.bonusId = bonusId;
        }
        
        
        if(![res valueForKey:@"increaseId"] || [res valueForKey:@"increaseId"] == [NSNull null])
        {
            increaseId = [NSNumber numberWithInt:0];
  
        }
        else
        {
            increaseId = [res valueForKey:@"increaseId"];
            couponsData.increaseId = increaseId;
            num++;
        }
        
        if(num>0)
        {
            _lbcoupon.text = [NSString stringWithFormat:@"使用%d张",num];
        }
        else
        {
            _lbcoupon.text = @"";
        }
        
       NSLog(@"res:%@",res);
    }
    else
    {
        couponsData.investCount = [NSNumber numberWithInt:0];
        bonusId = [NSNumber numberWithInt:0];
        increaseId = [NSNumber numberWithInt:0];
        _lbcoupon.text = @"";
    }
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    if (url) {
        [self openWebBrowserWithUrl:url.absoluteString];
    }
}

#pragma mark - Table view data source

#pragma mark - Table view delegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        case 3:
            return 10;
            break;
        case 1:
        case 2:
        case 4:
            return 50;
        case 7:
            return 151;
            case 5:
            if(!self.itemModel.isAllowIncrease && !self.itemModel.isBonusticket)
            {
                return 0;
            }
            else{
                return 10;
            }
        case 6:
            if(!self.itemModel.isAllowIncrease && !self.itemModel.isBonusticket)
            {
                return 0;
            }
            else{
                return 50;
            }
            break;
    }
    
    return tableView.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 6)
    {
        UIWebViewController* view = [[UIWebViewController alloc] init];
        view.title = [NSString stringWithFormat:@"投资%@元",couponsData.investCount];
        view.staticTitle = YES;
        NSString* path = [NSString stringWithFormat:@"%@%@",self.webPath,@"index.html"];
        view.req = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
        //view.req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.5.217:3000/#/"]];
        __weak UIWebViewController* weakview = view;
        [view addEventHandler:@"page_Load" WebEventHandller:^(id param, NSString *callbackId) {
            [weakview JSCallback:callbackId param:[couponsData transToDict]];
        }];
        [view addEventHandler:@"coupons_Done" WebEventHandller:^(id param, NSString *callbackId) {
            [self.navigationController popViewControllerAnimated:YES];
            int num = 0;
            if(param[@"increase"])
            {
                increaseId = param[@"increase"][@"id"];
                couponsData.increaseId = increaseId;
                if(increaseId.integerValue != 0)
                {
                    num++;
                }
            }
            if(param[@"bouns"])
            {
                bonusId = param[@"bouns"][@"id"];
                couponsData.bonusId = bonusId;
                if(bonusId.integerValue != 0)
                {
                    num++;
                }
            }
            if(num>0)
            {
                _lbcoupon.text = [NSString stringWithFormat:@"使用%d张",num];
            }
            else
            {
                _lbcoupon.text = @"不使用";
            }
            
        }];
        
        [self.navigationController pushViewController:view animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
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
