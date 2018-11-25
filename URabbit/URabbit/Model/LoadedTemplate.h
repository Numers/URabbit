//
//  LoadedTemplate.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/25.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGFMDB.h"
@interface LoadedTemplate : NSObject
@property(nonatomic, copy) NSString *memberId;
@property(nonatomic) long templateId;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *coverUrl;
@property(nonatomic) double duration;
@property(nonatomic,copy) NSString *summary;
@property(nonatomic) CGFloat videoWidth;
@property(nonatomic) CGFloat videoHeight;
@property(nonatomic, copy) NSString *moviePath;
@end
