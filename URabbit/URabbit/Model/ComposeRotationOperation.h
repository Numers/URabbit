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
#import "FrameAxios.h"
@interface ComposeRotationOperation : NSOperation
{
    CMSampleBufferRef currentTemplateSampleBufferRef;
    CMSampleBufferRef currentMaskSampleBufferRef;
    NSInteger currentFrame;
    NSMutableArray *currentSnapshotMedias;
    NSMutableArray *currentSnapshotTexts;
    CGSize currentPixelSize;
    int halfVideoFps;
}
@property(nonatomic,weak) id<ComposeOperationProtocol> delegate;
-(instancetype)initWithTemplateSampleBufferRef:(CMSampleBufferRef)templateSampleBufferRef maskSampleBufferRef:(CMSampleBufferRef)maskSampleBufferRef frame:(NSInteger)frame snapshotMedias:(NSMutableArray *)snapshotMedias snapshotText:(NSMutableArray *)snapshotTexts pixelSize:(CGSize)pixelSize fps:(CGFloat)fps;
@end
