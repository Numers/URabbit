//
//  VideoComposeTest.m
//  URabbit
//
//  Created by 鲍利成 on 2018/10/14.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "VideoComposeTest.h"
#import "UTImageHanderManager.h"

@implementation VideoComposeTest
-(instancetype)initWithVideoUrl:(NSString *)url videoSize:(CGSize)size fps:(int32_t)fps
{
    self = [super init];
    if (self) {
        videoUrl = url;
        videoSize = size;
        currentFps = fps;
        hasNextFrame = YES;
        currentFrame = 0;
        [self createVideoWriter];
    }
    return self;
}

-(void)createVideoWriter
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:videoUrl]) {
        [[NSFileManager defaultManager] removeItemAtPath:videoUrl error:nil];
    }
    
    
    
    videoWriterQueue = dispatch_queue_create("videoWriter", DISPATCH_QUEUE_CONCURRENT);
    
}

-(void)createWriter
{
    NSError *error = nil;
    videoWriter = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:videoUrl]
                                            fileType:AVFileTypeQuickTimeMovie
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
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:AVVideoCodecTypeH264, AVVideoCodecKey,
                                   [NSNumber numberWithInt:videoSize.width], AVVideoWidthKey,
                                   [NSNumber numberWithInt:videoSize.height], AVVideoHeightKey, nil];
    videoWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
    
    NSDictionary *sourcePixelBufferAttributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA], kCVPixelBufferPixelFormatTypeKey, nil];
    
    adaptor = [AVAssetWriterInputPixelBufferAdaptor
               assetWriterInputPixelBufferAdaptorWithAssetWriterInput:videoWriterInput sourcePixelBufferAttributes:sourcePixelBufferAttributesDictionary];
    NSParameterAssert(videoWriterInput);
    NSParameterAssert([videoWriter canAddInput:videoWriterInput]);
    
    [videoWriter addInput:videoWriterInput];
    [videoWriter startWriting];
    NSLog(@"videoWriter status1 %d",videoWriter.status);
}

-(void)readNextFrame
{
    [self createWriter];
    
    group = dispatch_group_create();
    dispatch_group_enter(group);
    typeof(self) __weak weakSelf = self;
    [videoWriterInput requestMediaDataWhenReadyOnQueue:videoWriterQueue usingBlock:^{
        NSLog(@"did Write");
        if ([[weakSelf returnVideoWriteInput] isReadyForMoreMediaData]) {
            UIImage * image = [weakSelf.delegate readNextPixelBuffer:self->currentFrame];
            if (image) {
                BOOL success = [weakSelf writeToMovie:image frame:self->currentFrame];
                if (success) {
                    NSLog(@"写入 %d video 成功",self->currentFrame);
                    [weakSelf addCurrentFrame];
                    [[weakSelf returnVideoWriteInput] markAsFinished];
                }
            }else{
                [weakSelf setHasNextFram:NO];
            }
            [NSThread sleepForTimeInterval:0.1];
        }
        dispatch_group_leave([weakSelf returnDispatch_Group_T]);
        NSLog(@"video group out");
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"OKKK");
        [self stopWrite];
    });
    
}

-(void)addCurrentFrame
{
    currentFrame ++;
}

-(void)setHasNextFram:(BOOL)has
{
    hasNextFrame = has;
}

-(BOOL)returnHasNextFrame
{
    return hasNextFrame;
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

-(dispatch_group_t)returnDispatch_Group_T
{
    return group;
}

-(BOOL)writeToMovie:(UIImage *)image frame:(int32_t)frame
{
    //合成多张图片为一个视频文件
    CVPixelBufferRef buffer = (CVPixelBufferRef)[[UTImageHanderManager shareManager] pixelBufferFromImage:image size:[self returnVideoSize]];
    NSLog(@"videoWriter status2 %d",videoWriter.status);
    [videoWriter startSessionAtSourceTime:CMTimeMake(frame, currentFps)];
    if(![adaptor appendPixelBuffer:buffer withPresentationTime:CMTimeMake(frame, currentFps)]) {
        return NO;
    }else {
        CFRelease(buffer);
        buffer = NULL;
    }
    return YES;
}

-(void)stopWrite
{
    typeof (self) __weak weakSelf = self;
    NSLog(@"videoWriter status3 %d",videoWriter.status);
    if (videoWriter.status == AVAssetWriterStatusWriting) {
        [videoWriter finishWritingWithCompletionHandler:^{
            NSLog(@"finished write");
            NSLog(@"videoWriter status4 %d",videoWriter.status);
            if ([weakSelf returnVideoWrite].status != AVAssetWriterStatusFailed) {
                [[weakSelf returnVideoWrite] cancelWriting];
                self->videoWriter = nil;
                if ([weakSelf.delegate respondsToSelector:@selector(videoWriteDidFinished:hasNextFrame:)]) {
                    [weakSelf.delegate videoWriteDidFinished:YES hasNextFrame:[weakSelf returnHasNextFrame]];
                }
            }else{
                NSLog(@"%@",[weakSelf returnVideoWrite].error);
                if ([weakSelf.delegate respondsToSelector:@selector(videoWriteDidFinished:hasNextFrame:)]) {
                    [weakSelf.delegate videoWriteDidFinished:NO hasNextFrame:[weakSelf returnHasNextFrame]];
                }
            }
        }];
    }
}
@end
