//
//  ComposeNomalOperation.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/21.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "ComposeNomalOperation.h"

@implementation ComposeNomalOperation
-(instancetype)initWithTemplateSampleBufferRef:(CMSampleBufferRef)templateSampleBufferRef frame:(NSInteger)frame
{
    self = [super init];
    if (self) {
        currentTemplateSampleBufferRef = templateSampleBufferRef;
        currentFrame = frame;
    }
    return self;
}

-(void)main
{
    @autoreleasepool {
        if ([self.delegate respondsToSelector:@selector(sendSampleBufferRef:frame:)]) {
            [self.delegate sendSampleBufferRef:currentTemplateSampleBufferRef frame:currentFrame];
        }
    }
}

@end
