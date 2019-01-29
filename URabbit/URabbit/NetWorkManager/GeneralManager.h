//
//  GFGeneralManager.h
//  GLPFinance
//
//  Created by 鲍利成 on 16/10/28.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetWorkManager.h"
@interface GeneralManager : NSObject
{
    NSString *downloadHtml;
    NSInteger submissionStatus;
    NSString *submissionVersion;
    NSDictionary *shareConfig;
}
+(id)defaultManager;

-(void)getGlovalVarWithVersion;
-(void)getNewAppVersion:(void(^)(BOOL hasNew))callback;
-(NSString *)returnDownloadHtml;
-(BOOL)isAuditSucess;
-(void)jumpToDownloadHtml;
-(void)sendRegID;
-(void)shareConfig:(void (^)(NSDictionary *))callback;
@end
