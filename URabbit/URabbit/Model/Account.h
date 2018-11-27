//
//  Account.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/27.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject
@property(nonatomic) LoginPlatform platform;
@property(nonatomic, copy) NSString *nickName;
@property(nonatomic, copy) NSString *account;

-(instancetype)initWithDictionary:(NSDictionary *)dic;

/**
 将用户对象转义成字典
 
 @return 用户信息字典
 */
-(NSDictionary *)dictionaryInfo;
@end
