//
//  URAuthorNetworkAPIManager.m
//  URabbit
//
//  Created by 鲍利成 on 2018/12/10.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "URAuthorNetworkAPIManager.h"

@implementation URAuthorNetworkAPIManager
+(instancetype)shareManager
{
    static URAuthorNetworkAPIManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[URAuthorNetworkAPIManager alloc] init];
    });
    return manager;
}

-(void)requestAuthorDetailsWithAuthorId:(long)authorId callback:(APIRequstCallBack)callback
{
    NSString *uri = [UT_Author_API stringByReplacingOccurrencesOfString:@"{id}" withString:[NSString stringWithFormat:@"%ld",authorId]];
    [[NetWorkRequestManager shareManager] get:uri parameters:nil callback:callback isNotify:NO];
}

-(void)requestAuthorCompositionsWithAuthorId:(long)authorId page:(NSInteger)page size:(NSInteger)size callback:(APIRequstCallBack)callback
{
    NSString *uri = [UT_AuthorComposition_API stringByReplacingOccurrencesOfString:@"{id}" withString:[NSString stringWithFormat:@"%ld",authorId]];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@(page),@"page",@(size),@"size", nil];
    [[NetWorkRequestManager shareManager] get:uri parameters:parameters callback:callback isNotify:YES];
}
@end
