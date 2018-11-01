//
//  AppLaunchManager.h
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/5/9.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppLaunchManager : NSObject
+(instancetype)shareManager;
-(void)loginSync:(NSString *)loginName withPassword:(NSString *)password withSource:(NSString *)source callback:(void(^)(id data))callback;
@end
