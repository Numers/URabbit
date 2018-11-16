//
//  ComposeAnimationStrategy.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/15.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "ComposeAnimationStrategy.h"
#import "AxiosInfo.h"
#import "Frame.h"
#import "Material.h"
#import "ComposeAnimationOperation.h"

@implementation ComposeAnimationStrategy
-(void)readVideoFrames:(int)index
{
    NSLog(@"read frame %d",index);
     if (index < self.frames.count)
     {
         Frame *frame = [self.frames objectAtIndex:index];
         if (frame.axiosIndex != -1) {
             AxiosInfo *axiosInfo = [self.axiosInfos objectAtIndex:frame.axiosIndex];
             ComposeAnimationOperation *operation = [[ComposeAnimationOperation alloc] initWithFrame:index axiosInfo:axiosInfo pixelSize:self.material.videoSize];
             operation.delegate = self;
             [self.operationQueue addOperation:operation];
         }
     }
}
@end
