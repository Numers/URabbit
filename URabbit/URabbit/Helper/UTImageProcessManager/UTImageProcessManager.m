//
//  UTImageProcessManager.m
//  URabbit
//
//  Created by 鲍利成 on 2018/10/16.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTImageProcessManager.h"


@implementation UTImageProcessManager
+(instancetype)shareManager
{
    static UTImageProcessManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[UTImageProcessManager alloc] init];
    });
    return manager;
}

-(void)blendImage:(UIImage *)image1 withOtherImage:(UIImage *)image2
{
    
}
@end
