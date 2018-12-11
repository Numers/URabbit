//
//  ComposeAnimationStrategy.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/15.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "ComposeAnimationStrategy.h"
#import "Frame.h"
#import "ComposeAnimationOperation.h"

@implementation ComposeAnimationStrategy
-(void)initlizeData
{
    [super initlizeData];
    self.frames = [NSMutableArray array];
    for (int i = 0; i < self.resource.totalFrame; i++) {
        Frame *frame = [[Frame alloc] init];
        [self.frames addObject:frame];
    }
}

-(void)readVideoFrames:(int)index
{
     if (index < self.frames.count)
     {
         ComposeAnimationOperation *operation = [[ComposeAnimationOperation alloc] initWithFrame:index pixelSize:self.resource.videoSize];
         operation.delegate = self;
         [self.operationQueue addOperation:operation];
     }
}
@end
