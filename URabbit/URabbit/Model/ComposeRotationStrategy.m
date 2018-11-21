//
//  ComposeRotationStrategy.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/14.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "ComposeRotationStrategy.h"
#import "AnimationForMedia.h"
#import "UTVideoReader.h"
#import "Frame.h"

#import "ComposeRotationOperation.h"
#import "ComposeNomalOperation.h"

@implementation ComposeRotationStrategy
-(void)initlizeData
{
    [super initlizeData];
    self.frames = [NSMutableArray array];
    for (int i = 0; i < self.resource.totalFrame; i++) {
        NSMutableArray *axiosArray = [self isFrameInAxios:i];
        Frame *frame = [[Frame alloc] init];
        if (axiosArray.count > 0) {
            NSDictionary *dic = [axiosArray objectAtIndex:0];
            frame.snapshotIndex = [[dic objectForKey:@"snapshotIndex"] integerValue];
            frame.snapshotMediaIndex = [[dic objectForKey:@"snapshotMediaIndex"] integerValue];
            frame.animationIndex = [[dic objectForKey:@"animationIndex"] integerValue];
        }else{
            frame.snapshotIndex = -1;
            frame.snapshotMediaIndex = -1;
            frame.animationIndex = -1;
        }
        [self.frames addObject:frame];
    }
}

-(NSMutableArray *)isFrameInAxios:(NSInteger)index
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i=0; i<self.snapshotList.count; i++) {
        Snapshot *snapshot = [self.snapshotList objectAtIndex:i];
        for (NSInteger j=0; j<snapshot.mediaList.count; j++) {
            SnapshotMedia *media = [snapshot.mediaList objectAtIndex:j];
            for (NSInteger k=0; k<media.animationForMediaList.count; k++) {
                AnimationForMedia *animation = [media.animationForMediaList objectAtIndex:k];
                if (index >= animation.range.location && index < (animation.range.length + animation.range.location)) {
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@(i),@"snapshotIndex",@(j),@"snapshotMediaIndex",@(k),@"animationIndex", nil];
                    [array addObject:dic];
                }
            }
        }
    }
    return array;
}

-(void)readVideoFrames:(int)index
{
//    NSLog(@"read frame %d",index);
    CMSampleBufferRef templateSampleBufferRef = [self.fgVideoReader readVideoFrames:index];
    CMSampleBufferRef maskSampleBufferRef = [self.maskVideoReader readVideoFrames:index];
    if (index < self.frames.count) {
        CGSize pixelSize = [[UTImageHanderManager shareManager] sizeForSampleBuffer:templateSampleBufferRef];
        Frame *frame = [self.frames objectAtIndex:index];
        if (frame.snapshotIndex != -1) {
            Snapshot *snapshot = [self.snapshotList objectAtIndex:frame.snapshotIndex];
            SnapshotMedia *media = [snapshot.mediaList objectAtIndex:frame.snapshotMediaIndex];
            AnimationForMedia *animation = [media.animationForMediaList objectAtIndex:frame.animationIndex];
            ComposeRotationOperation *operation = [[ComposeRotationOperation alloc] initWithTemplateSampleBufferRef:templateSampleBufferRef maskSampleBufferRef:maskSampleBufferRef frame:index snapshotMedia:media animation:animation pixelSize:pixelSize fps:self.resource.fps];
            operation.delegate = self;
            operation.queuePriority = index;
            [self.operationQueue addOperation:operation];
        }else{
            ComposeNomalOperation *normalOperation = [[ComposeNomalOperation alloc] initWithTemplateSampleBufferRef:templateSampleBufferRef frame:index];
            normalOperation.delegate = self;
            [self.operationQueue addOperation:normalOperation];
        }
    }
}
@end
