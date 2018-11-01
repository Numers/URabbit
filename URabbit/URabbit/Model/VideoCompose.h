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
-(CMSampleBufferRef)readNextPixelBuffer:(int)frame;
-(void)didWriteToMovie:(int)frame;
-(void)videoWriteDidFinished:(BOOL)success;
@end
@interface VideoCompose : NSObject
{
    NSString *videoUrl;
    CGSize videoSize;
    int32_t currentFps;
    AVAssetWriter *videoWriter;
    AVAssetWriterInput *videoWriterInput;
    AVAssetWriterInputPixelBufferAdaptor *adaptor;
}
@property(nonatomic, assign) id<VideoComposeProtocol> delegate;
-(instancetype)initWithVideoUrl:(NSString *)url videoSize:(CGSize)size fps:(int32_t)fps;
-(void)stopWrite;
@end
