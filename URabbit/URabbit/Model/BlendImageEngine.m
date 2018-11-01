//
//  BlendImageEngine.m
//  URabbit
//
//  Created by 鲍利成 on 2018/10/13.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "BlendImageEngine.h"

@implementation BlendImageEngine
-(instancetype)initWithImage:(UIImage *)newImageSource
{
    self = [super initWithImage:newImageSource];
    if (self) {
        filter = [[GPUImageFilter alloc] init];
        [filter forceProcessingAtSize:newImageSource.size];
        [filter useNextFrameForImageCapture];
        [self addTarget:filter];
    }
    return self;
}

-(CGImageRef)imageFromCurrentFramebuffer
{
    [self processImage];
    CGImageRef imageRef =  [filter newCGImageFromCurrentlyProcessedOutput];
    return imageRef;
}
@end
