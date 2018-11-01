//
//  VideoCompose.m
//  URabbit
//
//  Created by 鲍利成 on 2018/10/12.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "VideoCompose.h"
#import "UTImageHanderManager.h"

@implementation VideoCompose
-(instancetype)initWithVideoUrl:(NSString *)url videoSize:(CGSize)size fps:(int32_t)fps
{
    self = [super init];
    if (self) {
        videoUrl = url;
        videoSize = size;
        currentFps = fps;
        [self createVideoWriter];
    }
    return self;
}

-(void)createVideoWriter
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:videoUrl]) {
        [[NSFileManager defaultManager] removeItemAtPath:videoUrl error:nil];
    }
    
    NSError *error = nil;
    videoWriter = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:videoUrl]
                                                           fileType:AVFileTypeMPEG4
                                                              error:&error];
    NSParameterAssert(videoWriter);
    if(error)
        NSLog(@"error = %@", [error localizedDescription]);
    
    //视频
//    //配置写数据，设置比特率，帧率等
//    NSDictionary *compressionProperties = @{ AVVideoAverageBitRateKey : @(1.38*1024*1024),
//                                             AVVideoExpectedSourceFrameRateKey: @(30),
//                                             AVVideoProfileLevelKey : AVVideoProfileLevelH264HighAutoLevel };
    //配置编码器宽高等
//    NSDictionary *videoSettings = @{
//                                              AVVideoCodecKey                   : AVVideoCodecTypeH264,
//                                              AVVideoWidthKey                   : @1080,
//                                              AVVideoHeightKey                  : @1080,
//                                              AVVideoCompressionPropertiesKey   : compressionProperties
//                                              };
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:AVVideoCodecH264, AVVideoCodecKey,
                                   [NSNumber numberWithInt:videoSize.width], AVVideoWidthKey,
                                   [NSNumber numberWithInt:videoSize.height], AVVideoHeightKey, nil];
    videoWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
    videoWriterInput.expectsMediaDataInRealTime = YES;
    
    NSDictionary *sourcePixelBufferAttributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kCVPixelFormatType_32ARGB], kCVPixelBufferPixelFormatTypeKey, nil];
    
    adaptor = [AVAssetWriterInputPixelBufferAdaptor
                                                     assetWriterInputPixelBufferAdaptorWithAssetWriterInput:videoWriterInput sourcePixelBufferAttributes:sourcePixelBufferAttributesDictionary];
    NSParameterAssert(videoWriterInput);
    NSParameterAssert([videoWriter canAddInput:videoWriterInput]);
    
    [videoWriter addInput:videoWriterInput];
    
    [videoWriter startWriting];
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t videoWriter = dispatch_queue_create("videoWriter", DISPATCH_QUEUE_CONCURRENT);
    __block BOOL isVideoComplete = NO;
    dispatch_group_enter(group);
    typeof(self) __weak weakSelf = self;
    __block int32_t currentFrame = 0;
    [videoWriterInput requestMediaDataWhenReadyOnQueue:videoWriter usingBlock:^{
        NSLog(@"did Write");
        while (!isVideoComplete && [[weakSelf returnVideoWriteInput] isReadyForMoreMediaData]) {
            CMSampleBufferRef sampleBufferRef = [weakSelf.delegate readNextPixelBuffer:currentFrame];
            if (sampleBufferRef) {
                BOOL success = [weakSelf writeToMovie:sampleBufferRef frame:currentFrame];
                if (success) {
//                    NSLog(@"写入 %d video 成功",currentFrame);
                    if ([weakSelf.delegate respondsToSelector:@selector(didWriteToMovie:)]) {
                        [weakSelf.delegate didWriteToMovie:currentFrame];
                    }
                    currentFrame ++;
                }
            }else{
                isVideoComplete = YES;
            }
//            [NSThread sleepForTimeInterval:0.001];
        }
        if (isVideoComplete) {
            [[weakSelf returnVideoWriteInput] markAsFinished];
        }
        dispatch_group_leave(group);
        NSLog(@"video group out");
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"OKKK");
        [self stopWrite];
    });
}

-(CGSize)returnVideoSize
{
    return videoSize;
}

-(AVAssetWriterInputPixelBufferAdaptor *)returnAdapt
{
    return adaptor;
}

-(AVAssetWriter *)returnVideoWrite
{
    return videoWriter;
}

-(AVAssetWriterInput *)returnVideoWriteInput
{
    return videoWriterInput;
}

-(BOOL)writeToMovie:(CMSampleBufferRef)sampleBufferRef frame:(int32_t)frame
{
    //合成多张图片为一个视频文件
    if(![videoWriterInput appendSampleBuffer:sampleBufferRef]) {
        return NO;
    }else {
        CFRelease(sampleBufferRef);
    }
    return YES;
}


-(void)stopWrite
{
    typeof (self) __weak weakSelf = self;
    if (videoWriter.status == AVAssetWriterStatusWriting) {
        [videoWriter finishWritingWithCompletionHandler:^{
            NSLog(@"finished write");
            if ([weakSelf returnVideoWrite].status != AVAssetWriterStatusFailed) {
                [[weakSelf returnVideoWrite] cancelWriting];
                if ([weakSelf.delegate respondsToSelector:@selector(videoWriteDidFinished:)]) {
                    [weakSelf.delegate videoWriteDidFinished:YES];
                }
            }else{
                NSLog(@"%@",[weakSelf returnVideoWrite].error);
                if ([weakSelf.delegate respondsToSelector:@selector(videoWriteDidFinished:)]) {
                    [weakSelf.delegate videoWriteDidFinished:NO];
                }
            }
        }];
    }
}
@end
