//
//  ComposeRotationOperation.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/9.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@class AxiosInfo;
@protocol ComposeOperationProtocol <NSObject>
-(void)sendSampleBufferRef:(CMSampleBufferRef)sampleBufferRef frame:(NSInteger)frame;
-(void)sendPixelBufferRef:(CVPixelBufferRef)pixelBuffer frame:(NSInteger)frame;
-(void)sendImage:(UIImage *)image frame:(NSInteger)frame;
@end
@interface ComposeRotationOperation : NSOperation
{
    CMSampleBufferRef currentTemplateSampleBufferRef;
    CMSampleBufferRef currentMaskSampleBufferRef;
    NSInteger currentFrame;
    AxiosInfo *currentAxiosInfo;
    CGSize currentPixelSize;
    int halfVideoFps;
}
@property(nonatomic,weak) id<ComposeOperationProtocol> delegate;
-(instancetype)initWithTemplateSampleBufferRef:(CMSampleBufferRef)templateSampleBufferRef maskSampleBufferRef:(CMSampleBufferRef)maskSampleBufferRef frame:(NSInteger)frame axiosInfo:(AxiosInfo *)axiosInfo pixelSize:(CGSize)pixelSize fps:(CGFloat)fps;
@end
