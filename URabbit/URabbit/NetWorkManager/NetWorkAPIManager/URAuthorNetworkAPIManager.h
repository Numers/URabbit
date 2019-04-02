//
//  URAuthorNetworkAPIManager.h
//  URabbit
//
//  Created by 鲍利成 on 2018/12/10.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetWorkRequestManager.h"
@interface URAuthorNetworkAPIManager : NSObject
+(instancetype)shareManager;
-(void)requestAuthorDetailsWithAuthorId:(long)authorId callback:(APIRequstCallBack)callback;
-(void)requestAuthorCompositionsWithAuthorId:(long)authorId page:(NSInteger)page size:(NSInteger)size callback:(APIRequstCallBack)callback;
@end
