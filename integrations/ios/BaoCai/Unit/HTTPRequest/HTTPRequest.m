//
//  HTTPRequest.m
//  KuaiYi_Doctor
//
//  Created by 刘国龙 on 16/3/12.
//  Copyright © 2016年 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import "HTTPRequest.h"
#import "SSZipArchive.h"
#import "UserInfoModel.h"
#import "AppDelegate.h"

@implementation BCError

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.code = [dic integerForKey:@"code"];
        self.message = [dic stringForKey:@"message"];
    }
    return self;
}

@end

@implementation HTTPRequest

+ (void)send:(NSString *)url args:(NSDictionary *)args success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    
    DLog(@"path:%@",url);
    DLog(@"args:\r\n%@",args);
    
    NSMutableDictionary *params = [args mutableCopy];
    [params setObject:VERSION forKey:@"version"];
    
    NSMutableString *sign = [NSMutableString stringWithCapacity:0];
    if (params) {
        NSArray *allKeys = [params allKeys];
        allKeys = [allKeys sortedArrayUsingSelector:@selector(compare:)];
        for (NSString *key in allKeys) {
            [sign appendFormat:@"%@%@", key, [params objectForKey:key]];
        }
    }
    
    [sign appendString:[url sha1Encrypt]];
    
    if ([UserInfoModel sharedModel].token && [UserInfoModel sharedModel].token.length != 0) {
        [sign insertString:[UserInfoModel sharedModel].token atIndex:3];
    }
    
    if (sign.length != 0) {
        [params setObject:[sign sha1Encrypt] forKey:@"sign"];
    }
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[url toURL]];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy.validatesDomainName = NO;
    manager.requestSerializer.timeoutInterval = 15;
    manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    [manager.requestSerializer setValue:@"3" forHTTPHeaderField:@"X-Authorization-From"];
    [manager.requestSerializer setValue:SHORTVERSION forHTTPHeaderField:@"X-Authorization-Version"];
    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
    if ([UserDefaultsHelper sharedManager].userInfo)
        [manager.requestSerializer setValue:[UserInfoModel sharedModel].token forHTTPHeaderField:@"X-Authorization"];
    else if ([UserDefaultsHelper sharedManager].temporaryToken.length != 0)
        [manager.requestSerializer setValue:[UserDefaultsHelper sharedManager].temporaryToken forHTTPHeaderField:@"X-Authorization"];
    
    void (^AFSuccess)() = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        DLog(@"%@\r\n%@", responseObject, task.response.URL.absoluteString);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if (success) {
                NSString *jsonStr = [responseObject JSONString];
                jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\":null" withString:@"\":\"\""];
                NSDictionary *dic = [jsonStr objectFromJSONString];
                if ([dic integerForKey:@"code"] == 200 || [task.response.URL.absoluteString hasSuffix:@"payment/lianlianpay/sync"]) {
                    success([dic objectForKey:@"data"], [[BCError alloc] initWithDic:[[dic objectForKey:@"data"] objectForKey:@"error"]]);
                } else {
                    if (failure) {
                        failure(nil);
                    }
                }
            }
        } else {
            if (failure) {
                failure(nil);
            }
        }
    };
    
    void (^AFFailure)() = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
        NSInteger responseStatusCode = [httpResponse statusCode];
        if (responseStatusCode == 401 && ![task.response.URL.absoluteString hasSuffix:@"auth/refresh/token"] && ![task.response.URL.absoluteString hasSuffix:@"users/messages/unread/num"]) {
            HIDDENPROGRESSHUD;
            if ([UserDefaultsHelper sharedManager].isShow401Alert) {
                [UserDefaultsHelper sharedManager].isShow401Alert = NO;
                [UserDefaultsHelper sharedManager].userInfo = nil;
                [UserDefaultsHelper sharedManager].gesturePwd = nil;
                [[NSNotificationCenter defaultCenter] postNotificationName:LogoutNotification object:nil];
                AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                UINavigationController *controller = (UINavigationController *)[appDelegate.tabbarController.viewControllers objectAtIndex:appDelegate.tabbarController.selectedIndex];
                [controller.visibleViewController.navigationController popToRootViewControllerAnimated:NO];
                [appDelegate.tabbarController setSelectedIndex:0];
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的授权已失效，请重新登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
            return;
        }
        if (responseStatusCode == 409) {
            SHOWTOAST(@"验签失败，请重试");
        }
        if (failure) {
            failure(error);
        }
        //        NSData *data = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
        //        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //        DLog(@"%@", str);
        DLog(@"%@\r\n%@", error, task.response.URL.absoluteString);
    };
    
    if (params && params.allKeys.count != 0) {
        [manager POST:url parameters:params progress:nil success:AFSuccess failure:AFFailure];
    } else {
        [manager GET:url parameters:nil progress:nil success:AFSuccess failure:AFFailure];
    }
}

+ (void)updateWebSite:(NSString *)path version:(NSString *)version success:(HTTPRequestCompletionBlock)success failure:(HTTPRequestErrorBlock)failure {
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:nil];
    NSURL *url;
    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?version=%@",kServerAddress, path,version]];
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(location && error == nil) {
            NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
            if(res.statusCode == 200) {
                [SSZipArchive unzipFileAtPath:location.path toDestination:kDocumentsPath];
            }
        }
    }];
    [task resume]; 
}

@end
