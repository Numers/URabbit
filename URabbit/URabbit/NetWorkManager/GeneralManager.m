//
//  GFGeneralManager.m
//  GLPFinance
//
//  Created by 鲍利成 on 16/10/28.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import "GeneralManager.h"
#import "NetWorkRequestManager.h"
#import "AppDelegate.h"
#import "AppStartManager.h"
static GeneralManager *generalManager;
@implementation GeneralManager
+(id)defaultManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (generalManager == nil) {
            generalManager = [[GeneralManager alloc] init];
        }
    });
    
    return generalManager;
}

-(void)jumpToDownloadHtml
{
    if (downloadHtml) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downloadHtml] options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES} completionHandler:nil];
        });
    }
}

-(void)getNewAppVersion
{
    [[NetWorkRequestManager shareManager] get:UT_UpdateVersion_API parameters:nil callback:^(NSNumber *statusCode, NSNumber *code, id data, id errorMsg) {
        if (data) {
            NSString *newVersion = [data objectForKey:@"version"];
            NSString *currentVersion = [AppUtils appVersion];
            if ([AppUtils compareVersion:currentVersion greatThan:newVersion] < 0) {
                downloadHtml = [data objectForKey:@"url"];
//                NSString *downloadHtml = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@",[AppUtils URLEncodedString:link]];
//                NSString *downloadHtml = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id1329918420?mt=8"];
                NSString *log = [data objectForKey:@"description"];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:log preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *comfirmAction = [UIAlertAction actionWithTitle:@"去更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downloadHtml] options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES} completionHandler:nil];
                    });
                }];
                [alert addAction:comfirmAction];
                NSInteger isIgnore = [[data objectForKey:@"isIgnore"] integerValue];
                if (isIgnore == 1) {
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [(AppDelegate *)[UIApplication sharedApplication].delegate setNeedShowUpdateAlert:NO];
                    }];
                    [cancelAction setValue:[UIColor colorFromHexString:@"#999999"] forKey:@"titleTextColor"];
                    [alert addAction:cancelAction];
                }
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:^{
                    
                }];
            }
        }
    } isNotify:NO];
}

-(void)sendRegID
{
    return;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (delegate.regId && [AppUtils token]) {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:delegate.regId,@"regId", nil];
        [[NetWorkRequestManager shareManager] post:UP_SendRegId_API parameters:params callback:^(NSNumber *statusCode, NSNumber *code, id data, id errorMsg) {
            
        } isNotify:NO];
    }
}

-(void)getGlovalVarWithVersion
{
    if (ISTEST) {
        [AppUtils setUrlWithState:NO];
    }else{
        [AppUtils setUrlWithState:YES];
    }
}
@end
