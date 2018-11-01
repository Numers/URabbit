//
//  VideoComposeTest.h
//  URabbit
//
//  Created by 鲍利成 on 2018/10/14.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@protocol VideoComposeTestProtocol <NSObject>
-(UIImage *)readNextPixelBuffer:(int)frame;
-(void)videoWriteDidFinished:(BOOL)success hasNextFrame:(BOOL)hasNextFrame;
@end
@interface VideoComposeTest : NSObject
{
    NSString *videoUrl;
    CGSize videoSize;
    int32_t currentFps;
    AVAssetWriter *videoWriter;
    AVAssetWriterInput *videoWriterInput;
    AVAssetWriterInputPixelBufferAdaptor *adaptor;
    
    dispatch_group_t group;
    dispatch_queue_t videoWriterQueue;
    BOOL hasNextFrame;
    CGImageRef currentImageRef;
    int32_t currentFrame;
}
@property(nonatomic, assign) id<VideoComposeTestProtocol> delegate;
-(instancetype)initWithVideoUrl:(NSString *)url videoSize:(CGSize)size fps:(int32_t)fps;
-(void)readNextFrame;
-(void)stopWrite;
@end
