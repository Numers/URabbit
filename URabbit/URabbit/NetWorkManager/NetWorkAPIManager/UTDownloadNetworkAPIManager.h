//
//  UTDownloadNetworkAPIManager.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/20.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetWorkRequestManager.h"
@interface UTDownloadNetworkAPIManager : NSObject
+(instancetype)shareManager;
-(void)requestTemplateDetailsWithTemplateId:(long)templateId callback:(APIRequstCallBack)callback;
@end
