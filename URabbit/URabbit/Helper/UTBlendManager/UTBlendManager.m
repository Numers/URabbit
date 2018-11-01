//
//  UTBlendManager.m
//  URabbit
//
//  Created by 鲍利成 on 2018/10/12.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTBlendManager.h"
#import "BlendViewEngine.h"

@implementation UTBlendManager
+(instancetype)shareManager
{
    static UTBlendManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[UTBlendManager alloc] init];
    });
    return manager;
}

-(UIImage *)imageRefWithView:(UIView *)view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    CGContextRef currnetContext = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:currnetContext];
    // 从当前context中创建一个改变大小后的图片
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    return image;
}
@end
