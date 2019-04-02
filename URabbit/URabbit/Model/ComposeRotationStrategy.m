//
//  ComposeRotationStrategy.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/14.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "ComposeRotationStrategy.h"
#import "AnimationForMedia.h"
#import "AnimationForText.h"
#import "SnapshotText.h"
#import "FrameAxios.h"
#import "UTVideoReader.h"
#import "Frame.h"

#import "URVideoManager.h"
#import "ComposeRotationOperation.h"
#import "ComposeNomalOperation.h"

@implementation ComposeRotationStrategy
-(void)initlizeData
{
    [super initlizeData];
    self.frames = [NSMutableArray array];
    for (int i = 0; i < self.resource.totalFrame; i++) {
        Frame *frame = [[Frame alloc] init];
        [self isFrameInAxios:i frame:frame];
        [self.frames addObject:frame];
    }
}

-(void)isFrameInAxios:(NSInteger)index frame:(Frame *)frame
{
    for (NSInteger i=0; i<self.snapshotList.count; i++) {
        Snapshot *snapshot = [self.snapshotList objectAtIndex:i];
        for (NSInteger j=0; j<snapshot.mediaList.count; j++) {
            SnapshotMedia *media = [snapshot.mediaList objectAtIndex:j];
            for (NSInteger k=0; k<media.animationForMediaList.count; k++) {
                AnimationForMedia *animation = [media.animationForMediaList objectAtIndex:k];
                if (index >= animation.range.location && index < (animation.range.length + animation.range.location)) {
                    FrameAxios *axios = [[FrameAxios alloc] init];
                    axios.snapshotMedia = media;
                    axios.animationForMedia = animation;
                    [frame.snapshotMedias addObject:axios];
                }
            }
        }
        
        for (NSInteger j=0; j<snapshot.textList.count; j++) {
            SnapshotText *text = [snapshot.textList objectAtIndex:j];
            if (text.animationForTextList.count > 0) {
                for (NSInteger k=0; k<text.animationForTextList.count; k++) {
                    AnimationForText *animation = [text.animationForTextList objectAtIndex:k];
                    if (index >= animation.range.location && index < (animation.range.length + animation.range.location)) {
                        FrameAxios *axios = [[FrameAxios alloc] init];
                        axios.snapshotText = text;
                        axios.animationForText = animation;
                        [frame.snapshotTexts addObject:axios];
                    }
                }
            }else{
                FrameAxios *axios = [[FrameAxios alloc] init];
                axios.snapshotText = text;
                [frame.snapshotTexts addObject:axios];
            }
        }
    }
}

-(void)readVideoFrames:(int)index
{
//    NSLog(@"read frame %d",index);
    CMSampleBufferRef templateSampleBufferRef = [self.fgVideoReader readVideoFrames:index];
    CMSampleBufferRef maskSampleBufferRef = [self.maskVideoReader readVideoFrames:index];
    if (index < self.frames.count) {
        CGSize pixelSize = self.resource.videoSize;
        Frame *frame = [self.frames objectAtIndex:index];
        if (frame.snapshotMedias.count > 0 || frame.snapshotTexts.count > 0) {
            ComposeRotationOperation *operation = [[ComposeRotationOperation alloc] initWithTemplateSampleBufferRef:templateSampleBufferRef maskSampleBufferRef:maskSampleBufferRef frame:index snapshotMedias:frame.snapshotMedias snapshotText:frame.snapshotTexts pixelSize:pixelSize fps:self.resource.fps];
            operation.delegate = self;
            [self.operationQueue addOperation:operation];
        }else{
            if (maskSampleBufferRef) {
                CFRelease(maskSampleBufferRef);
            }
            ComposeNomalOperation *normalOperation = [[ComposeNomalOperation alloc] initWithTemplateSampleBufferRef:templateSampleBufferRef frame:index];
            normalOperation.delegate = self;
            [self.operationQueue addOperation:normalOperation];
        }
    }
}
@end
