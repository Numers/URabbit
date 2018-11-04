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

#import "ComposeStrategyManager.h"
#import "BlendAlgorithmFrontView.h"
#import "UTBlendManager.h"
#import "UTImageHanderManager.h"

#import "UIImage+FixImage.h"

#import "GPUImage.h"

@interface ComposeStrategy()
{
    GPUImageTwoInputFilter *filter;
}
@end

@implementation ComposeStrategy
-(instancetype)initWithMaterial:(Material *)m
{
    self = [super init];
    if (self) {
        _material = m;
        [self initlizeData];
    }
    return self;
}

-(void)initlizeData
{
    filter = [[GPUImageAddBlendFilter alloc] init];
    _axiosInfos = [NSMutableArray array];
    AxiosInfo *info = [[AxiosInfo alloc] init];
    info.range = NSMakeRange(0, 412);
    info.centerX = 272.0f;
    info.centerY = 100.0f;
    info.offsetX = 0.0f;
    info.offsetY = 0.0f;
    info.image = [UIImage imageNamed:@"test"];
    info.imageWith = info.image.size.width;
    info.imageHeight = info.image.size.height;
    info.algorithmType = AlgorithmTemplateFront;
    info.maskAlgorithmType = MaskAlgorithmNone;
    [_axiosInfos addObject:info];
    
    _frames = [NSMutableArray array];
    for (int i = 0; i < 374; i++) {
        Frame *frame = [[Frame alloc] init];
        frame.axiosIndex = 0;
        [_frames addObject:frame];
    }
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
            
            if (axiosInfo.algorithmType == AlgorithmTemplateFront) {
                UIImage *tempResultImage = [axiosInfo.image imageWithMask:maskImage orginImagePoint:CGPointMake(0, 0) colorSpace:[[UTImageHanderManager shareManager] currentColorSpaceRef]];
                //            UIImage *tempResultImage = [axiosInfo.image imageWithMask:maskImage orginImagePoint:CGPointMake(0, 0)];
                GPUImagePicture *tempPic1 = [[GPUImagePicture alloc] initWithImage:templateImage];
                [tempPic1 addTarget:filter];
                [tempPic1 processImage];
//                [filter useNextFrameForImageCapture];
//                GPUImagePicture *tempPic2 = [[GPUImagePicture alloc] initWithImage:tempResultImage];
//                [tempPic2 addTarget:filter];
//                [tempPic2 processImage];
                
                UIImage *resultImage = [filter imageByFilteringImage:tempResultImage];
                
                CVPixelBufferRef resultPixelBuffer = [[filter framebufferForOutput] pixelBuffer];
                void *resultBaseAddress = [[UTImageHanderManager shareManager] baseAddressWithCVPixelBuffer:resultPixelBuffer];
                memcpy(templatePixelBuffer, resultBaseAddress, 4*pixelSize.width*pixelSize.height);
                [tempPic1 removeTarget:filter];
//                UIImage *resultImage = [filter imageFromCurrentFramebuffer];
//                UIImage *resultImage = [filter imageByFilteringImage:tempResultImage];
//                CVPixelBufferRef resultPixelBuffer = [[filter framebufferForOutput] pixelBuffer];
                
//                [tempPic2 removeTarget:filter];
                
//                CVPixelBufferRef resultPixelBuffer = [[UTImageHanderManager shareManager] pixelBufferFromImage:resultImage size:pixelSize];
//                void *resultBaseAddress = [[UTImageHanderManager shareManager] baseAddressWithCVPixelBuffer:resultPixelBuffer];
//                memcpy(templatePixelBuffer, resultBaseAddress, 4*pixelSize.width*pixelSize.height);
//
                CFRelease(maskSampleBufferRef);
                
//                CVPixelBufferRelease(resultPixelBuffer);
            }
        }
    }
     
    return templateSampleBufferRef;
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
}
@end
