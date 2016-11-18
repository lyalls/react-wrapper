//
//  UIGesturePwdViewControllerm
//  BaoCai
//
//  Created by 刘国龙 on 16/7/8.
//  Copyright © 2016年 Beijing KuaiYiJianKang Management Co., Ltd. All rights reserved.
//

#import "UIGesturePwdViewController.h"
#import "CustomIOSAlertView.h"

#define LOCK_POINT_TAG      1000

@interface UIGesturePwdViewController () {
    BOOL _isShow;
    NSMutableArray *_setlist;
    NSMutableArray *_showlist;
}

@property (nonatomic, assign) BOOL isSetPassword;

@property (nonatomic, strong) UIImageView *imageBg;
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) NSMutableArray *selectedButtons;
@property (nonatomic, assign) CGPoint lineStartPoint;
@property (nonatomic, assign) CGPoint lineEndPoint;
@property (nonatomic, assign) BOOL drawFlag;

@property (nonatomic, strong) UILabel *phoneNum;
@property (nonatomic, strong) UILabel *promptLab;
@property (nonatomic, strong) UIButton *reInputBtn;

@property (nonatomic, strong) NSString *inputPassword;
@property (nonatomic, assign) BOOL isRePassword;

@property (nonatomic, assign) int errorCount;
@property (nonatomic, strong) NSString *currentPassword;

@end

@implementation UIGesturePwdViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _isShow = false;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    self.imageBg = [[UIImageView alloc] initWithFrame:CGRectMakeCustom(0, 163 - ((Screen_height > 480) ? 0 : 30), 320, 320)];
    [self.view addSubview:self.imageBg];
    
    self.buttonArray = [NSMutableArray arrayWithCapacity:9];
    
    self.phoneNum = [[UILabel alloc] initWithFrame:CGRectMakeCustom(0, 70 - ((Screen_height > 480) ? 0 : 20), 320, 30)];
    self.phoneNum.font = [UIFont boldSystemFontOfSize:24];
    self.phoneNum.textColor = OrangeColor;
    self.phoneNum.backgroundColor = [UIColor clearColor];
    self.phoneNum.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.phoneNum];
    
    self.promptLab = [[UILabel alloc] initWithFrame:CGRectMakeCustom(0, 100 - (Screen_height > 480 ? 0 : 20), 320, 30)];
    self.promptLab.font = [UIFont systemFontOfSize:18];
    self.promptLab.textColor = RGB_COLOR(153, 153, 153);
    self.promptLab.backgroundColor = [UIColor clearColor];
    self.promptLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.promptLab];
    
    self.reInputBtn = [[UIButton alloc] initWithFrame:CGRectMakeCustom(0, 500 - ((Screen_height > 480) ? 0 : 60), 320, 40)];
    [self.reInputBtn setTitleColor:RGB_COLOR(103, 103, 103) forState:UIControlStateNormal];
    self.reInputBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.reInputBtn setTitle:@"重新设置手势密码" forState:UIControlStateNormal];
    [self.reInputBtn addTarget:self action:@selector(reInputPassword) forControlEvents:UIControlEventTouchUpInside];
    self.reInputBtn.hidden = YES;
    [self.view addSubview:self.reInputBtn];
    
    _setlist = [[NSMutableArray alloc] init];
    _showlist = [[NSMutableArray alloc] init];
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectNull];
    [_setlist addObject:closeBtn];
    if (IOS7)
        closeBtn.frame = CGRectMakeCustom(280, 39, 30.5, 30.5);
    else
        closeBtn.frame = CGRectMakeCustom(280, 19, 30.5, 30.5);
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"gesture_pwd_close.png"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    
    UIButton *forgotPassBtn = [[UIButton alloc] initWithFrame:CGRectMakeCustom(0, 500 - ((Screen_height > 480) ? 0 : 60), 160, 40)];
    [_showlist addObject:forgotPassBtn];
    [forgotPassBtn setTitleColor:RGB_COLOR(153, 153, 153) forState:UIControlStateNormal];
    forgotPassBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [forgotPassBtn setTitle:@"忘记手势密码" forState:UIControlStateNormal];
    forgotPassBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [forgotPassBtn addTarget:self action:@selector(toLoginView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgotPassBtn];
    
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMakeCustom(160, 500 - ((Screen_height > 480) ? 0 : 60), 160, 40)];
    [_showlist addObject:loginBtn];
    [loginBtn setTitleColor:RGB_COLOR(153, 153, 153) forState:UIControlStateNormal];
    loginBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [loginBtn setTitle:@"账户密码登录" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [loginBtn addTarget:self action:@selector(toLoginView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    for (NSUInteger i = 0; i < 9; i++) {
        NSUInteger column = i % 3;
        NSUInteger row = i / 3;
        
        CGFloat xOffsetBig = column * 65 + (column + 1) * 31.25;
        CGFloat yOffsetBig = row * 65 + (row + 1) * 31.25;
        
        UIButton *bigBtn = [[UIButton alloc] initWithFrame:CGRectMakeCustom(xOffsetBig, yOffsetBig, 65, 65)];
        [bigBtn setImage:[UIImage imageNamed:@"gesture_pwd_big_default.png"] forState:UIControlStateNormal];
        [bigBtn setImage:[UIImage imageNamed:@"gesture_pwd_big_selected.png"] forState:UIControlStateSelected];
        bigBtn.userInteractionEnabled = NO;
        bigBtn.tag = 1000 + row * 3 + column;
        [self.imageBg addSubview:bigBtn];
        [self.buttonArray addObject:bigBtn];
    }
    
    NSString *phoneStr;
    if (self.userInfo) {
        phoneStr = [self.userInfo objectForKey:@"phone"];
    } else {
        phoneStr = [UserInfoModel sharedModel].phone;
    }
    phoneStr = [phoneStr stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    self.phoneNum.text = phoneStr;
    if (self.isSetPassword) {
        self.promptLab.text = @"绘制手势解锁图案";
        self.inputPassword = @"";
        self.isRePassword = NO;
    }
    else {
        self.promptLab.text = @"请输入手势密码";
        self.errorCount = 5;
        self.currentPassword = [UserDefaultsHelper sharedManager].gesturePwd;
    }
    for (UIView* view in _setlist) {
        [view setHidden:!self.isSetPassword];
    }
    for (UIView* view in _showlist) {
        [view setHidden:self.isSetPassword];
    }
}

- (void)show:(BOOL)isSet {
    if (!_isShow) {
        self.isSetPassword = isSet;
        self.promptLab.textColor = RGB_COLOR(153, 153, 153);
        
        NSString *phoneStr;
        if (self.userInfo) {
            phoneStr = [self.userInfo objectForKey:@"phone"];
        } else {
            phoneStr = [UserInfoModel sharedModel].phone;
        }
        phoneStr = [phoneStr stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        self.phoneNum.text = phoneStr;
        if (self.isSetPassword) {
            self.promptLab.text = @"绘制手势解锁图案";
            self.inputPassword = @"";
            self.isRePassword = NO;
        }
        else {
            self.promptLab.text = @"请输入手势密码";
            self.errorCount = 5;
            self.currentPassword = [UserDefaultsHelper sharedManager].gesturePwd;
        }
        for (UIView* view in _setlist) {
            [view setHidden:!self.isSetPassword];
        }
        for (UIView* view in _showlist) {
            [view setHidden:self.isSetPassword];
        }
        
        _isShow = YES;
        [[UIApplication sharedApplication].keyWindow addSubview:self.view];
    }
}
- (void)hide {
    if (_isShow) {
        _isShow = NO;
        [self.view removeFromSuperview];
    }
}

- (void)setIsSet:(BOOL)isSet {
    self.isSetPassword = isSet;
}

- (void)closeBtnClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(setPasswordFaile)]) {
        [self.delegate performSelector:@selector(setPasswordFaile) withObject:nil];
    }
}

- (void)toLoginView {
    CustomIOSAlertView *alertView  = [[CustomIOSAlertView alloc] init];
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        [alertView close];
        if(buttonIndex == 1)
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(showLoginView)]) {
                [self.delegate performSelector:@selector(showLoginView) withObject:nil];
            }
        }
    }];
    [alertView setUseMotionEffects:true];
    [alertView show:@"温馨提示" message:@"忘记手势密码，需重新登录！" buttonTitles:@[@"取消",@"重新登录"]];
}

- (void)refreshPromptText {
    if (self.isRePassword) {
        self.promptLab.text = @"再次确认手势解锁图案";
    } else {
        self.promptLab.text = @"绘制手势解锁图案";
    }
    self.promptLab.textColor = RGB_COLOR(153, 153, 153);
}

- (void)outputSelectedButtons:(BOOL)isTouchInside {
    self.imageBg.image = nil;
    
    NSString *inputPsw = nil;
    
    for (UIButton *btn in self.selectedButtons) {
        btn.selected = NO;
        
        if (!inputPsw) {
            inputPsw = [NSString stringWithFormat:@"%i", (int)btn.tag];
        }
        else {
            inputPsw = [inputPsw stringByAppendingFormat:@",%i", (int)btn.tag];
        }
    }
    
    if (self.isSetPassword) {
        if (self.selectedButtons.count < 3) {
            [self.selectedButtons removeAllObjects];
            self.promptLab.text = @"最少连接三个点，请重新输入";
            self.promptLab.textColor = [UIColor redColor];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.isRePassword) {
                    self.promptLab.text = @"再次确认手势解锁图案";
                } else {
                    self.promptLab.text = @"绘制手势解锁图案";
                }
                self.promptLab.textColor = RGB_COLOR(153, 153, 153);
            });
            
            return;
        }
        
        if (self.isRePassword) {
            if ([self.inputPassword isEqualToString:inputPsw]) {
                [UserDefaultsHelper sharedManager].gesturePwd = self.inputPassword;
                self.currentPassword = self.inputPassword;
                SHOWTOAST(@"您已成功设置手势密码！");
                if (self.delegate && [self.delegate respondsToSelector:@selector(setPasswordSuccess)]) {
                    [self.delegate performSelector:@selector(setPasswordSuccess) withObject:nil];
                }
                if(self.pwdCallback)
                {
                    self.pwdCallback();
                    self.pwdCallback = nil;
                }
            } else {
                self.promptLab.text = @"与上次绘制不一致，请再次绘制";
                self.promptLab.textColor = [UIColor redColor];
                self.reInputBtn.hidden = NO;
            }
            return;
        }
        
        self.inputPassword = inputPsw;
        self.isRePassword = YES;
        self.promptLab.text = @"再次确认手势解锁图案";
        self.promptLab.textColor = RGB_COLOR(153, 153, 153);
        
        for (UIButton *btn in self.selectedButtons) {
            UIButton *smallBtn = (UIButton *)[self.view viewWithTag:btn.tag + 1000];
            smallBtn.selected = YES;
        }
    } else {
        if ([self.currentPassword isEqualToString:inputPsw]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(unlockSuccess)]) {
                [self.delegate performSelector:@selector(unlockSuccess) withObject:nil];
            }
        } else {
            self.errorCount--;
            if (self.errorCount <= 0) {
                CustomIOSAlertView *alertView  = [[CustomIOSAlertView alloc] init];
                [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
                    [alertView close];
                    if (self.delegate && [self.delegate respondsToSelector:@selector(showLoginView)]) {
                        [self.delegate performSelector:@selector(showLoginView) withObject:nil];
                    }
                }];
                [alertView setUseMotionEffects:true];
                [alertView show:@"忘记手势密码，需重新登录！" message:@"" buttonTitles:@[@"重新登录"]];
                
                self.promptLab.text = @"请输入手势密码";
                self.promptLab.textColor = RGB_COLOR(153, 153, 153);
            } else {
                self.promptLab.text = [NSString stringWithFormat:@"密码错误，还可以输入%i次", self.errorCount];
                self.promptLab.textColor = [UIColor redColor];
            }
        }
    }
}

- (void)reInputPassword {
    self.reInputBtn.hidden = YES;
    [self.selectedButtons removeAllObjects];
    self.isRePassword = NO;
    self.inputPassword = @"";
    for (NSUInteger i = 2000; i < 2009; i++) {
        UIButton *smallBtn = (UIButton *)[self.view viewWithTag:i];
        smallBtn.selected = NO;
    }
    [self refreshPromptText];
}

#pragma mark - Trace Touch Point

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (touch) {
        for (UIButton *btn in self.buttonArray) {
            CGPoint touchPoint = [touch locationInView:btn];
            if ([btn pointInside:touchPoint withEvent:nil]) {
                self.lineStartPoint = btn.center;
                self.drawFlag = YES;
                
                if (!self.selectedButtons) {
                    self.selectedButtons = [NSMutableArray arrayWithCapacity:9];
                }
                
                [self.selectedButtons addObject:btn];
                btn.selected = YES;
            }
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch && self.drawFlag) {
        self.lineEndPoint = [touch locationInView:self.imageBg];
        
        for (UIButton *btn in self.buttonArray) {
            CGPoint touchPoint = [touch locationInView:btn];
            
            if ([btn pointInside:touchPoint withEvent:nil]) {
                BOOL btnContained = NO;
                
                for (UIButton *selectedBtn in self.selectedButtons) {
                    if (btn == selectedBtn) {
                        btnContained = YES;
                        break;
                    }
                }
                
                if (!btnContained) {
                    [self.selectedButtons addObject:btn];
                    btn.selected = YES;
                }
            }
        }
        self.imageBg.image = [self drawUnlockLine];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    BOOL isTouchInside = NO;
    if (self.selectedButtons && self.selectedButtons.count > 0) {
        isTouchInside = YES;
    }else if (touch) {
        for (UIButton *btn in self.buttonArray) {
            CGPoint touchPoint = [touch locationInView:btn];
            if ([btn pointInside:touchPoint withEvent:nil]) {
                isTouchInside = YES;
            }
        }
    }
    if (self.drawFlag) {
        [self outputSelectedButtons:isTouchInside];
    }
    self.drawFlag = NO;
    self.selectedButtons = nil;
}

#pragma mark - Draw Line
- (UIImage *)drawUnlockLine
{
    UIImage *image = nil;
    
    UIColor *color = RGB_COLOR(253, 166, 108);// [UIColor yellowColor];
    CGFloat width = 5.0f;
    CGSize imageContextSize = self.imageBg.frame.size;
    
    UIGraphicsBeginImageContext(imageContextSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, width);
    CGContextSetStrokeColorWithColor(context, [color CGColor]);
    
    CGContextMoveToPoint(context, self.lineStartPoint.x, self.lineStartPoint.y);
    for (UIButton *selectedBtn in self.selectedButtons) {
        CGPoint btnCenter = selectedBtn.center;
        CGContextAddLineToPoint(context, btnCenter.x, btnCenter.y);
        CGContextMoveToPoint(context, btnCenter.x, btnCenter.y);
    }
    CGContextAddLineToPoint(context, self.lineEndPoint.x, self.lineEndPoint.y);
    
    CGContextStrokePath(context);
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end
