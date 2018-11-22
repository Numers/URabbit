//
//  ComposeCoverStrategy.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/22.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "ComposeCoverStrategy.h"
#import "ComposeCoverOperation.h"

@implementation ComposeCoverStrategy
-(void)initlizeData
{
    [super initlizeData];
    self.frames = [NSMutableArray array];
    for (int i = 0; i < self.resource.totalFrame; i++) {
        Frame *frame = [[Frame alloc] init];
        [self.frames addObject:frame];
    }
    maskImage = [UIImage imageWithContentsOfFile:self.resource.maskBaseImage];
}

-(void)readVideoFrames:(int)index
{
    NSLog(@"read frame %d",index);
    CMSampleBufferRef templateSampleBufferRef = [self.bgVideoReader readVideoFrames:index];
    Snapshot *snapshot = [self.snapshotList objectAtIndex:0];
    if (index < self.frames.count)
    {
        ComposeCoverOperation *operation = [[ComposeCoverOperation alloc] initWithTemplateSampleBufferRef:templateSampleBufferRef maskImage:maskImage Frame:index snapshot:snapshot pixelSize:self.resource.videoSize];
        operation.delegate = self;
        [self.operationQueue addOperation:operation];
    }
}
@end
