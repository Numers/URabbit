//
//  VideoCompose.h
//  URabbit
//
//  Created by 鲍利成 on 2018/10/12.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@protocol VideoComposeProtocol <NSObject>
-(void)readNextPixelBuffer:(int)frame;
-(void)didWriteToMovie:(NSInteger)frame;
-(void)videoWriteDidFinished:(BOOL)success;
@end
@interface VideoCompose : NSObject
{
    NSString *videoUrl;
    CGSize videoSize;
    int32_t currentFps;
    NSInteger totalFrames;
    NSInteger writeFrames;
    AVAssetWriter *videoWriter;
    AVAssetWriterInput *videoWriterInput;
    AVAssetWriterInputPixelBufferAdaptor *adaptor;
    dispatch_queue_t videoWriterQueue;
    dispatch_queue_t videoReaderQueue;
}
@property(nonatomic, assign) id<VideoComposeProtocol> delegate;
-(instancetype)initWithVideoUrl:(NSString *)url videoSize:(CGSize)size fps:(int32_t)fps totalFrames:(NSInteger)frames;
-(void)readFrames;
-(void)stopWrite;
-(void)cleanMemory;
-(void)writeSampleBufferRef:(CMSampleBufferRef)sampleBufferRef frame:(NSInteger)frame;
-(void)writeCVPixelBuffer:(CVPixelBufferRef)pixelBuffer frame:(NSInteger)frame;
@end
