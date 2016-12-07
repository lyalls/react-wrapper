//
//  UIWebViewController+Actions.m
//  BaoCai
//
//  Created by Lin Sun on 07/12/2016.
//  Copyright © 2016 Beijing Baocai Information Service Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIWebViewController+Actions.h"
#import "UITenderDetailViewController.h"


@implementation UIWebViewController (Actions)


// MARK: Native 页面跳转
// 打开投资详情页
-(void) getInvestDetail:(id)params callId:(id)callId{
    NSString *tenderId = [params objectForKey:@"borrowId"];
    if(tenderId != nil){
        UITenderDetailViewController *viewController = [[UITenderDetailViewController alloc] init];
        viewController.tenderId = tenderId;
        [self.navigationController pushViewController:viewController animated:YES];
    }else{
        NSLog(@"ERROR: [%@] can't getKey 'borrowId' from params {%@}, when invoked by H5 in native method [getInvestDetail:callId]", [self class], params);
    }
}

// 跳转到指定页面
-(void) gotoPage:(id)params callId:(id)callId{
    NSString *pageName = [params objectForKey:@"pageName"];
    NSString *url = [params objectForKey:@"url"];
    if(url != nil){
        [self openWebBrowserWithUrl: url];
    }else if(pageName != nil){
        NSLog(@"ERROR: [%@] doesn't support pageName [%@] in params {%@}, when invoked by H5 in native method [gotoPage:callId]", [self class], pageName, params);
    }else{
        NSLog(@"ERROR: [%@] can't getKey 'pageName' or 'url' from params {%@}, when invoked by H5 in native method [gotoPage:callId]", [self class], params);
    }
}

// 打开散标详情页
-(void) getTenderInfoDetail:(id) params callId:(id)callId{
    NSString *tenderId = [params objectForKey:@"borrowId"];
    if(tenderId != nil){
        UITenderDetailViewController *viewController = [[UITenderDetailViewController alloc] init];
        viewController.tenderId = tenderId;
        [self.navigationController pushViewController:viewController animated:YES];
    }else{
        NSLog(@"ERROR: [%@] can't getKey 'borrowId' from params {%@}, when invoked by H5 in native method [getTenderInfoDetail:callId]", [self class], params);
    }
}
@end