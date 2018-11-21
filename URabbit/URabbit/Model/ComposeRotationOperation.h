//
//  ComposeRotationOperation.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/9.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "Protocol.h"
@class SnapshotMedia,AnimationForMedia;
@interface ComposeRotationOperation : NSOperation
{
    CMSampleBufferRef currentTemplateSampleBufferRef;
    CMSampleBufferRef currentMaskSampleBufferRef;
    NSInteger currentFrame;
    SnapshotMedia *currentSnapshotMedia;
    AnimationForMedia *currentAnimation;
    CGSize currentPixelSize;
    int halfVideoFps;
}
@property(nonatomic,weak) id<ComposeOperationProtocol> delegate;
-(instancetype)initWithTemplateSampleBufferRef:(CMSampleBufferRef)templateSampleBufferRef maskSampleBufferRef:(CMSampleBufferRef)maskSampleBufferRef frame:(NSInteger)frame snapshotMedia:(SnapshotMedia *)snapshotMedia animation:(AnimationForMedia *)animation pixelSize:(CGSize)pixelSize fps:(CGFloat)fps;
@end
