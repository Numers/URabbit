//
//  URUserSaveNetworkAPIManager.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/25.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetWorkRequestManager.h"
@interface URUserSaveNetworkAPIManager : NSObject
+(instancetype)shareManager;
-(void)requestUserSavedTemplateWithPage:(NSInteger)page size:(NSInteger)size callback:(APIRequstCallBack)callback;
-(void)saveTemplateWithTemplateId:(long)templateId callback:(APIRequstCallBack)callback;
-(void)deleteTemplateWithTemplateId:(long)templateId callback:(APIRequstCallBack)callback;
@end
