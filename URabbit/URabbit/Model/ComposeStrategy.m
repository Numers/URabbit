//
//  ComposeStrategy.m
//  URabbit
//
//  Created by 鲍利成 on 2018/10/11.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "ComposeStrategy.h"

@interface ComposeStrategy()
{
    int halfVideoFps;
}
@end

@implementation ComposeStrategy
-(instancetype)initWithResource:(Resource *)m snapshot:(NSMutableArray *)snapshots fps:(float)fps
{
    self = [super init];
    if (self) {
        _resource = m;
        _snapshotList = snapshots;
        halfVideoFps = (int)(fps / 2);
        _currentFps = fps;
    }
    return self;
}

-(void)initlizeData
{
    _operationQueue = [[NSOperationQueue alloc] init];
    _operationQueue.maxConcurrentOperationCount = 1;
}

-(void)createVideoReader
{
    if (_fgVideoReader == nil) {
        if (_resource.fgVideo) {
            _fgVideoReader = [[UTVideoReader alloc] initWithUrl:_resource.fgVideo pixelFormatType:kCVPixelFormatType_32BGRA];
        }
    }
    
    if (_maskVideoReader == nil) {
        if (_resource.maskVideo) {
            _maskVideoReader = [[UTVideoReader alloc] initWithUrl:_resource.maskVideo pixelFormatType:kCVPixelFormatType_32ARGB];
        }
    }
    
    if (_bgVideoReader == nil) {
        if (_resource.bgVideo) {
            _bgVideoReader = [[UTVideoReader alloc] initWithUrl:_resource.bgVideo pixelFormatType:kCVPixelFormatType_32BGRA];
        }
    }
}

-(void)readVideoFrames:(int)index
{
    
}

//-(CMSampleBufferRef)readVideoFrames:(int)index
//{
//    CMSampleBufferRef templateSampleBufferRef = [_templateVideoReader readVideoFrames:index];
//    CMSampleBufferRef maskSampleBufferRef = nil;
//    if (_maskVideoReaders && _maskVideoReaders.count == 1) {
//        maskSampleBufferRef = [[_maskVideoReaders objectAtIndex:0] readVideoFrames:index];
//    }
//    if (index < _frames.count) {
//        CGSize pixelSize = [[UTImageHanderManager shareManager] sizeForSampleBuffer:templateSampleBufferRef];
//        if (pixelSize.width == 0 && pixelSize.height == 0) {
//            NSLog(@"图片size为0");
//            return nil;
//        }
//        Frame *frame = [_frames objectAtIndex:index];
//        if (frame.axiosIndex != -1) {
//            AxiosInfo *axiosInfo = [_axiosInfos objectAtIndex:frame.axiosIndex];
//            @autoreleasepool {
//                void *templatePixelBuffer = [[UTImageHanderManager shareManager] baseAddressFromSampleBuffer:templateSampleBufferRef];
//                UIImage *templateImage = [[UTImageHanderManager shareManager] imageFromPixelBuffer:templatePixelBuffer size:pixelSize];
//                void *maskPixelBuffer = [[UTImageHanderManager shareManager] baseAddressFromSampleBuffer:maskSampleBufferRef];
//                [[UTImageHanderManager shareManager] convertImagePixelReverse:maskPixelBuffer size:pixelSize];
//                UIImage *maskImage = [[UTImageHanderManager shareManager] imageFromPixelBuffer:maskPixelBuffer size:pixelSize];
//                //            UIImage *currentMaskImage = [invertFilter imageByFilteringImage:maskImage];
//
//                if (true) {
//                    UIImage *tempResultImage = [self imageWithMask:maskImage axiosInfo:axiosInfo frameIndex:index - axiosInfo.range.location];
//                    GPUImagePicture *tempPic1 = [[GPUImagePicture alloc] initWithImage:templateImage];
//                    [tempPic1 addTarget:filter];
//                    [tempPic1 processImage];
//                    //                [filter useNextFrameForImageCapture];
//                    //                GPUImagePicture *tempPic2 = [[GPUImagePicture alloc] initWithImage:tempResultImage];
//                    //                [tempPic2 addTarget:filter];
//                    //                [tempPic2 processImage];
//
//                    UIImage *resultImage = [filter imageByFilteringImage:tempResultImage];
//                    if (index % halfVideoFps == 0) {
//                        if ([self.delegate respondsToSelector:@selector(composeImage:)]) {
//                            [self.delegate composeImage:resultImage];
//                        }
//                    }
//                    CVPixelBufferRef resultPixelBuffer = [[UTImageHanderManager shareManager] pixelBufferFromImage:resultImage size:pixelSize];
//                    void *resultBaseAddress = [[UTImageHanderManager shareManager] baseAddressWithCVPixelBuffer:resultPixelBuffer];
//                    //                CVPixelBufferRef resultPixelBuffer = [[filter framebufferForOutput] pixelBuffer];
//                    //                void *resultBaseAddress = [[UTImageHanderManager shareManager] baseAddressWithCVPixelBuffer:resultPixelBuffer];
//                    memcpy(templatePixelBuffer, resultBaseAddress, 4*pixelSize.width*pixelSize.height);
//                    [tempPic1 removeTarget:filter];
//                    CVPixelBufferRelease(resultPixelBuffer);
//                }
//            }
//        }else{
//            @autoreleasepool {
//                void *templatePixelBuffer = [[UTImageHanderManager shareManager] baseAddressFromSampleBuffer:templateSampleBufferRef];
//                UIImage *templateImage = [[UTImageHanderManager shareManager] imageFromPixelBuffer:templatePixelBuffer size:pixelSize];
//                if (index % halfVideoFps == 0) {
//                    if ([self.delegate respondsToSelector:@selector(composeImage:)]) {
//                        [self.delegate composeImage:templateImage];
//                    }
//                }
//            }
//        }
//    }
//    if (maskSampleBufferRef) {
//        CFRelease(maskSampleBufferRef);
//    }
//
//    return templateSampleBufferRef;
//}



-(void)cleanMemory
{
    if (_frames.count > 0) {
        [_frames removeAllObjects];
        _frames = nil;
    }
    
    if (_fgVideoReader) {
        [_fgVideoReader removeVideoReader];
        _fgVideoReader = nil;
    }
    
    if (_maskVideoReader) {
        [_maskVideoReader removeVideoReader];
        _maskVideoReader = nil;
    }

    
    if (_bgVideoReader) {
        [_bgVideoReader removeVideoReader];
        _bgVideoReader = nil;
    }
    
    _operationQueue = nil;
}

-(void)sendSampleBufferRef:(CMSampleBufferRef)sampleBufferRef frame:(NSInteger)frame
{
    if ([self.delegate respondsToSelector:@selector(sendSampleBufferRef:frame:)]) {
        [self.delegate sendSampleBufferRef:sampleBufferRef frame:frame];
    }
}

-(void)sendPixelBufferRef:(CVPixelBufferRef)pixelBuffer frame:(NSInteger)frame
{
    if ([self.delegate respondsToSelector:@selector(sendPixelBufferRef:frame:)]) {
        [self.delegate sendPixelBufferRef:pixelBuffer frame:frame];
    }
}

-(void)sendImage:(UIImage *)image frame:(NSInteger)frame
{
    if (frame % halfVideoFps == 0) {
        if ([self.delegate respondsToSelector:@selector(sendResultImage:frame:)]) {
            [self.delegate sendResultImage:image frame:frame];
        }
    }
}
@end
