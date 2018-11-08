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

#import "UTImageHanderManager.h"

#import "UIImage+FixImage.h"

#import "GPUImage.h"

@interface ComposeStrategy()
{
    GPUImageTwoInputFilter *filter;
    int halfVideoFps;
}
@end

@implementation ComposeStrategy
-(instancetype)initWithMaterial:(Material *)m axiosInfos:(NSMutableArray *)axiosInfoList fps:(float)fps
{
    self = [super init];
    if (self) {
        _material = m;
        halfVideoFps = (int)(fps / 2);
        _axiosInfos = [NSMutableArray arrayWithArray:axiosInfoList];
        [self initlizeData];
    }
    return self;
}

-(void)initlizeData
{
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

-(CMSampleBufferRef)readVideoFrames:(int)index
{
    CMSampleBufferRef templateSampleBufferRef = [_templateVideoReader readVideoFrames:index];
    CMSampleBufferRef maskSampleBufferRef = nil;
    if (_maskVideoReaders && _maskVideoReaders.count == 1) {
        maskSampleBufferRef = [[_maskVideoReaders objectAtIndex:0] readVideoFrames:index];
    }
    
    if (index < _frames.count) {
        CGSize pixelSize = [[UTImageHanderManager shareManager] sizeForSampleBuffer:templateSampleBufferRef];
        if (pixelSize.width == 0 && pixelSize.height == 0) {
            NSLog(@"图片size为0");
            return nil;
        }
        
        @autoreleasepool {
            void *templatePixelBuffer = [[UTImageHanderManager shareManager] baseAddressFromSampleBuffer:templateSampleBufferRef];
            UIImage *templateImage = [[UTImageHanderManager shareManager] imageFromPixelBuffer:templatePixelBuffer size:pixelSize];
            void *maskPixelBuffer = [[UTImageHanderManager shareManager] baseAddressFromSampleBuffer:maskSampleBufferRef];
            [[UTImageHanderManager shareManager] convertImagePixelReverse:maskPixelBuffer size:pixelSize];
            UIImage *maskImage = [[UTImageHanderManager shareManager] imageFromPixelBuffer:maskPixelBuffer size:pixelSize];
//            UIImage *currentMaskImage = [invertFilter imageByFilteringImage:maskImage];
            
            Frame *frame = [_frames objectAtIndex:index];
            AxiosInfo *axiosInfo = [_axiosInfos objectAtIndex:frame.axiosIndex];
            
            if (true) {
                UIImage *tempResultImage = [self imageWithMask:maskImage axiosInfo:axiosInfo];
                GPUImagePicture *tempPic1 = [[GPUImagePicture alloc] initWithImage:templateImage];
                [tempPic1 addTarget:filter];
                [tempPic1 processImage];
//                [filter useNextFrameForImageCapture];
//                GPUImagePicture *tempPic2 = [[GPUImagePicture alloc] initWithImage:tempResultImage];
//                [tempPic2 addTarget:filter];
//                [tempPic2 processImage];
                
                UIImage *resultImage = [filter imageByFilteringImage:tempResultImage];
                if (index % halfVideoFps == 0) {
                    if ([self.delegate respondsToSelector:@selector(composeImage:)]) {
                        [self.delegate composeImage:resultImage];
                    }
                }
                CVPixelBufferRef resultPixelBuffer = [[UTImageHanderManager shareManager] pixelBufferFromImage:resultImage size:pixelSize];
                void *resultBaseAddress = [[UTImageHanderManager shareManager] baseAddressWithCVPixelBuffer:resultPixelBuffer];
//                CVPixelBufferRef resultPixelBuffer = [[filter framebufferForOutput] pixelBuffer];
//                void *resultBaseAddress = [[UTImageHanderManager shareManager] baseAddressWithCVPixelBuffer:resultPixelBuffer];
                memcpy(templatePixelBuffer, resultBaseAddress, 4*pixelSize.width*pixelSize.height);
                [tempPic1 removeTarget:filter];
                CVPixelBufferRelease(resultPixelBuffer);
                CFRelease(maskSampleBufferRef);
            }
        }
    }
     
    return templateSampleBufferRef;
}

-(UIImage *)imageWithMask:(UIImage *)maskImage axiosInfo:(AxiosInfo *)info
{
    CGColorSpaceRef colorSpace = [[UTImageHanderManager shareManager] currentColorSpaceRef];
    CGContextRef mainViewContentContext = CGBitmapContextCreate(NULL, maskImage.size.width, maskImage.size.height,8,0, colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    
    CGImageRef maskRef = maskImage.CGImage;
    CGContextClipToMask(mainViewContentContext, CGRectMake(0, 0, maskImage.size.width, maskImage.size.height), maskRef);
    CGContextSaveGState(mainViewContentContext);
    CGContextTranslateCTM(mainViewContentContext, info.centerX, info.centerY);
    CGContextRotateCTM(mainViewContentContext, -info.rotateAngle);
    CGContextDrawImage(mainViewContentContext, CGRectMake(info.offsetX - info.imageWith / 2, info.offsetY - info.imageHeight / 2, info.imageWith, info.imageHeight), info.image.CGImage);
    CGContextRestoreGState(mainViewContentContext);
    CGImageRef newImageRef = CGBitmapContextCreateImage(mainViewContentContext);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease(newImageRef);
    CGContextRelease(mainViewContentContext);
    return newImage;
}

-(void)cleanMemory
{

}

-(void)removeVideoReader
{
    if (_templateVideoReader) {
        if (_templateVideoReader) {
            [_templateVideoReader removeVideoReader];
        }
        _templateVideoReader = nil;
    }
    
    if (_maskVideoReaders.count > 0) {
        for (UTVideoReader *reader in _maskVideoReaders) {
            [reader removeVideoReader];
        }
    }
}
@end
