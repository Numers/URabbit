//
//  PushMessageManager.m
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/5/7.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import "PushMessageManager.h"

@implementation PushMessageManager
+(instancetype)shareManager
{
    static PushMessageManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PushMessageManager alloc] init];
        manager.delegate = nil;
    });
    return manager;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        pushMessageList = [NSMutableArray array];
    }
    return self;
}

-(void)bind:(id<PushMessageManagerProtocol>)obj
{
    self.delegate = obj;
}

-(void)unBind
{
    self.delegate = nil;
}

-(BOOL)hasMessage
{
    return (pushMessageList.count > 0);
}

-(id)lastPushMessage
{
    if (pushMessageList.count > 0) {
        return [pushMessageList lastObject];
    }
    return nil;
}

-(void)addPushMessage:(id)message platformUrl:(NSString *)url withType:(MessageType)type
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:@(type) forKey:@"messageType"];
    if ([AppUtils isNetworkURL:url]) {
        [dic setObject:url forKey:@"url"];
    }
    
    if (message) {
        [dic setObject:message forKey:@"message"];
    }
    [pushMessageList addObject:dic];
    [[NSNotificationCenter defaultCenter] postNotificationName:MessageDidPushedNotification object:nil];
}

-(void)sync
{
    if ([self.delegate respondsToSelector:@selector(sendPushMessages:completion:)]) {
        [self.delegate sendPushMessages:pushMessageList completion:^(BOOL completion, id message) {
            if ([pushMessageList containsObject:message] && completion) {
                [pushMessageList removeObject:message];
            }
        }];
    }
}
@end
