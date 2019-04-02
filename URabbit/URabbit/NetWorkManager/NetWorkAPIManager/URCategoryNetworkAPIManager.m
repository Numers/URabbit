//
//  URCategoryNetworkAPIManager.m
//  URabbit
//
//  Created by 鲍利成 on 2019/1/5.
//  Copyright © 2019年 鲍利成. All rights reserved.
//

#import "URCategoryNetworkAPIManager.h"

@implementation URCategoryNetworkAPIManager
+(instancetype)shareManager
{
    static URCategoryNetworkAPIManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[URCategoryNetworkAPIManager alloc] init];
    });
    return manager;
}

-(void)getCategoryTemplateWithCategoryId:(long)categoryId Page:(NSInteger)page size:(NSInteger)size callback:(APIRequstCallBack)callback
{
    NSString *uri = [UT_CategoryTemplateList_API stringByReplacingOccurrencesOfString:@"{id}" withString:[NSString stringWithFormat:@"%ld",categoryId]];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@(page),@"page",@(size),@"size", nil];
    [[NetWorkRequestManager shareManager] get:uri parameters:parameters callback:callback isNotify:NO];
}
@end
