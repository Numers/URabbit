//
//  UTCategoryNetworkAPIManager.h
//  URabbit
//
//  Created by 鲍利成 on 2019/1/5.
//  Copyright © 2019年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetWorkRequestManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface UTCategoryNetworkAPIManager : NSObject
+(instancetype)shareManager;
-(void)getCategoryTemplateWithCategoryId:(long)categoryId Page:(NSInteger)page size:(NSInteger)size callback:(APIRequstCallBack)callback;
@end

NS_ASSUME_NONNULL_END
