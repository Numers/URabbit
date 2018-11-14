//
//  ComposeRotationStrategy.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/14.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "ComposeRotationStrategy.h"
#import "Material.h"
#import "UTVideoReader.h"
#import "AxiosInfo.h"
#import "Frame.h"

#import "ComposeRotationOperation.h"

#import "UTImageHanderManager.h"

#import "GPUImage.h"

@implementation ComposeRotationStrategy

-(void)readVideoFrames:(int)index
{
//    NSLog(@"read frame %d",index);
    CMSampleBufferRef templateSampleBufferRef = [self.templateVideoReader readVideoFrames:index];
    CMSampleBufferRef maskSampleBufferRef = nil;
    if (self.maskVideoReaders && self.maskVideoReaders.count == 1) {
        maskSampleBufferRef = [[self.maskVideoReaders objectAtIndex:0] readVideoFrames:index];
    }
    if (index < self.frames.count) {
        CGSize pixelSize = [[UTImageHanderManager shareManager] sizeForSampleBuffer:templateSampleBufferRef];
        Frame *frame = [self.frames objectAtIndex:index];
        if (frame.axiosIndex != -1) {
            AxiosInfo *axiosInfo = [self.axiosInfos objectAtIndex:frame.axiosIndex];
            
            ComposeRotationOperation *operation = [[ComposeRotationOperation alloc] initWithTemplateSampleBufferRef:templateSampleBufferRef maskSampleBufferRef:maskSampleBufferRef frame:index axiosInfo:axiosInfo pixelSize:pixelSize fps:self.currentFps];
            operation.delegate = self;
            [self.operationQueue addOperation:operation];
        }
    }
}
@end
