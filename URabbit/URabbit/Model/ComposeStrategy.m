//
//  ComposeStrategy.m
//  URabbit
//
//  Created by 鲍利成 on 2018/10/11.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "ComposeStrategy.h"
#import "Material.h"
#import "UTVideoReader.h"
#import "AxiosInfo.h"
#import "Frame.h"

#import "ComposeRotationOperation.h"

#import "UTImageHanderManager.h"

#import "UIImage+FixImage.h"

#import "GPUImage.h"

@interface ComposeStrategy()<ComposeOperationProtocol>
{
    GPUImageTwoInputFilter *filter;
    int halfVideoFps;
    CGFloat currentFps;
    NSOperationQueue *operationQueue;
}
@end

@implementation ComposeStrategy
-(instancetype)initWithMaterial:(Material *)m axiosInfos:(NSMutableArray *)axiosInfoList fps:(float)fps
{
    self = [super init];
    if (self) {
        _material = m;
        halfVideoFps = (int)(fps / 2);
        currentFps = fps;
        
        _axiosInfos = [NSMutableArray arrayWithArray:axiosInfoList];
        [self initlizeData];
    }
    return self;
}

-(void)initlizeData
{
    operationQueue = [[NSOperationQueue alloc] init];
    operationQueue.maxConcurrentOperationCount = 1;
    
    filter = [[GPUImageAddBlendFilter alloc] init];
    _frames = [NSMutableArray array];
    for (int i = 0; i < _material.totalFrames; i++) {
        Frame *frame = [[Frame alloc] init];
        frame.axiosIndex = [self isInAxios:i];
        [_frames addObject:frame];
    }
}

-(NSInteger)isInAxios:(NSInteger)index
{
    NSInteger location = -1;
    for (NSInteger i = 0; i < _axiosInfos.count; i++) {
        AxiosInfo *info = [_axiosInfos objectAtIndex:i];
        NSRange range = info.range;
        if (index >= range.location && index <= (range.location + range.length - 1)) {
            location = i;
            break;
        }
    }
    return location;
}

-(void)createVideoReader
{
    if (_templateVideoReader == nil) {
        _templateVideoReader = [[UTVideoReader alloc] initWithUrl:_material.templateVideo pixelFormatType:kCVPixelFormatType_32BGRA];
    }
    
    if (_maskVideoReaders == nil) {
        _maskVideoReaders = [NSMutableArray array];
        for (NSString *maskVideoUrl in _material.maskVideos) {
            UTVideoReader *maskReader = [[UTVideoReader alloc] initWithUrl:maskVideoUrl pixelFormatType:kCVPixelFormatType_32ARGB];
            [_maskVideoReaders addObject:maskReader];
        }
    }
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

-(void)readVideoFrames:(int)index
{
    NSLog(@"read frame %d",index);
    CMSampleBufferRef templateSampleBufferRef = [_templateVideoReader readVideoFrames:index];
    CMSampleBufferRef maskSampleBufferRef = nil;
    if (_maskVideoReaders && _maskVideoReaders.count == 1) {
        maskSampleBufferRef = [[_maskVideoReaders objectAtIndex:0] readVideoFrames:index];
    }
    if (index < _frames.count) {
        CGSize pixelSize = [[UTImageHanderManager shareManager] sizeForSampleBuffer:templateSampleBufferRef];
        Frame *frame = [_frames objectAtIndex:index];
        if (frame.axiosIndex != -1) {
            AxiosInfo *axiosInfo = [_axiosInfos objectAtIndex:frame.axiosIndex];
            
            ComposeRotationOperation *operation = [[ComposeRotationOperation alloc] initWithTemplateSampleBufferRef:templateSampleBufferRef maskSampleBufferRef:maskSampleBufferRef frame:index axiosInfo:axiosInfo pixelSize:pixelSize fps:currentFps];
            operation.delegate = self;
            [operationQueue addOperation:operation];
        }
    }
}


-(UIImage *)imageWithMask:(UIImage *)maskImage axiosInfo:(AxiosInfo *)info frameIndex:(NSInteger)index
{
    CGColorSpaceRef colorSpace = [[UTImageHanderManager shareManager] currentColorSpaceRef];
    CGContextRef mainViewContentContext = CGBitmapContextCreate(NULL, maskImage.size.width, maskImage.size.height,8,0, colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    
    CGImageRef maskRef = maskImage.CGImage;
    CGContextClipToMask(mainViewContentContext, CGRectMake(0, 0, maskImage.size.width, maskImage.size.height), maskRef);
    if (info.animationType == AnimationRotation) {
        CGContextSaveGState(mainViewContentContext);
        CGContextTranslateCTM(mainViewContentContext, info.centerX, info.centerY);
        CGContextRotateCTM(mainViewContentContext, -0.005*index);
        CGContextDrawImage(mainViewContentContext, CGRectMake(-info.centerX, -info.centerY, info.imageWith, info.imageHeight), info.image.CGImage);
        CGContextRestoreGState(mainViewContentContext);
    }else{
        CGContextDrawImage(mainViewContentContext, CGRectMake(0, 0, info.imageWith, info.imageHeight), info.image.CGImage);
    }
    CGImageRef newImageRef = CGBitmapContextCreateImage(mainViewContentContext);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease(newImageRef);
    CGContextRelease(mainViewContentContext);
    return newImage;
}

-(void)cleanMemory
{
    if (_frames.count > 0) {
        [_frames removeAllObjects];
        _frames = nil;
    }
    
    if (_axiosInfos.count > 0) {
        [_axiosInfos removeAllObjects];
        _axiosInfos = nil;
    }
    
    if (_templateVideoReader) {
        [_templateVideoReader removeVideoReader];
        _templateVideoReader = nil;
    }
    
    if (_maskVideoReaders.count > 0) {
        for (UTVideoReader *reader in _maskVideoReaders) {
            [reader removeVideoReader];
        }
        [_maskVideoReaders removeAllObjects];
    }
    
    filter = nil;
    operationQueue  = nil;
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
