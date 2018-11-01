//
//  BlendViewEngine.m
//  URabbit
//
//  Created by 鲍利成 on 2018/10/12.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "BlendViewEngine.h"

@implementation BlendViewEngine
-(instancetype)initWithView:(UIView *)inputView
{
    self = [super initWithView:inputView];
    if (self) {
        filter = [[GPUImageFilter alloc] init];
        [filter forceProcessingAtSize:inputView.frame.size];
        [filter useNextFrameForImageCapture];
        [self addTarget:filter];
    }
    return self;
}

-(CGImageRef)imageFromCurrentFramebuffer
{
    [self updateUsingCurrentTime];
    CGImageRef imageRef =  [filter newCGImageFromCurrentlyProcessedOutput];
    return imageRef;
    
}
@end
