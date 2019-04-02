//
//  URVideoComposeNetworkAPIManager.h
//  URabbit
//
//  Created by 鲍利成 on 2018/12/7.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetWorkRequestManager.h"

@interface URVideoComposeNetworkAPIManager : NSObject
+(instancetype)shareManager;
-(void)requestRecommendMusicWithTemplateId:(long)templateId Callback:(APIRequstCallBack)callback;
@end
