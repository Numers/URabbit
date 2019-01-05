//
//  UTHomeNetworkAPIManager.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/19.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetWorkRequestManager.h"
@interface UTHomeNetworkAPIManager : NSObject
+(instancetype)shareManager;
-(void)getReccmmendTemplateCallback:(APIRequstCallBack)callback;
-(void)getNewTemplateWithPage:(NSInteger)page size:(NSInteger)size callback:(APIRequstCallBack)callback;
-(void)getChoiceRecommendTemplateWithPage:(NSInteger)page size:(NSInteger)size callback:(APIRequstCallBack)callback;
@end
