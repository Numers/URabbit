//
//  PushMessageManager.h
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/5/7.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
#define MessageDidPushedNotification @"MessageDidPushedNotification"
typedef void(^NotifyCompletion)(BOOL completion, id message);
@protocol PushMessageManagerProtocol <NSObject>

-(void)sendPushMessages:(NSArray *)list completion:(NotifyCompletion)completion;

@end
typedef enum{
    PushMessage = 1,
    PlatformMessage,
    WebViewMessage
}MessageType;
@interface PushMessageManager : NSObject
{
    NSMutableArray *pushMessageList;
}
@property(nonatomic, assign) id<PushMessageManagerProtocol> delegate;
+(instancetype)shareManager;
-(void)bind:(id<PushMessageManagerProtocol>)obj;
-(void)unBind;
-(id)lastPushMessage;
-(void)addPushMessage:(id)message platformUrl:(NSString *)url withType:(MessageType)type;
-(void)sync;
-(BOOL)hasMessage;
@end
