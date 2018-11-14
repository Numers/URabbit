//
//  ComposeRotationOperation.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/9.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "ComposeRotationOperation.h"
#import "GPUImage.h"
#import "AxiosInfo.h"
#import "UTImageHanderManager.h"
@interface ComposeRotationOperation()
{
    GPUImageTwoInputFilter *filter;
}
@end
@implementation ComposeRotationOperation
-(instancetype)initWithTemplateSampleBufferRef:(CMSampleBufferRef)templateSampleBufferRef maskSampleBufferRef:(CMSampleBufferRef)maskSampleBufferRef frame:(NSInteger)frame axiosInfo:(AxiosInfo *)axiosInfo pixelSize:(CGSize)pixelSize fps:(CGFloat)fps
{
    self = [super init];
    if (self) {
        currentTemplateSampleBufferRef = templateSampleBufferRef;
        currentMaskSampleBufferRef = maskSampleBufferRef;
        currentFrame = frame;
        currentAxiosInfo = axiosInfo;
        currentPixelSize = pixelSize;
        halfVideoFps = (int)(fps / 2);
        filter = [[GPUImageAddBlendFilter alloc] init];
    }
    return self;
}

-(void)main
{
    @autoreleasepool {
        if (currentTemplateSampleBufferRef) {
            void *templatePixelBuffer = [[UTImageHanderManager shareManager] baseAddressFromSampleBuffer:currentTemplateSampleBufferRef];
            UIImage *templateImage = [[UTImageHanderManager shareManager] imageFromPixelBuffer:templatePixelBuffer size:currentPixelSize];
            void *maskPixelBuffer = [[UTImageHanderManager shareManager] baseAddressFromSampleBuffer:currentMaskSampleBufferRef];
            [[UTImageHanderManager shareManager] convertImagePixelReverse:maskPixelBuffer size:currentPixelSize];
            
            UIImage *maskImage = [[UTImageHanderManager shareManager] imageFromPixelBuffer:maskPixelBuffer size:currentPixelSize];
            UIImage *tempResultImage = [self imageWithMask:maskImage axiosInfo:currentAxiosInfo frameIndex:currentFrame - currentAxiosInfo.range.location];
            GPUImagePicture *tempPic1 = [[GPUImagePicture alloc] initWithImage:templateImage];
            [tempPic1 addTarget:filter];
            [tempPic1 processImage];
            
            UIImage *resultImage = [filter imageByFilteringImage:tempResultImage];
            if (currentFrame % halfVideoFps == 0) {
                if ([self.delegate respondsToSelector:@selector(sendImage:frame:)]) {
                    [self.delegate sendImage:resultImage frame:currentFrame];
                }
            }
            CVPixelBufferRef resultPixelBuffer = [[UTImageHanderManager shareManager] pixelBufferFromImage:resultImage size:currentPixelSize];
            void *resultBaseAddress = [[UTImageHanderManager shareManager] baseAddressWithCVPixelBuffer:resultPixelBuffer];
            memcpy(templatePixelBuffer, resultBaseAddress, 4*currentPixelSize.width*currentPixelSize.height);
            [tempPic1 removeTarget:filter];
            [filter removeOutputFramebuffer];
            CFRelease(currentMaskSampleBufferRef);
            
            if ([self.delegate respondsToSelector:@selector(sendSampleBufferRef:frame:)]) {
                [self.delegate sendSampleBufferRef:currentTemplateSampleBufferRef frame:currentFrame];
            }
            
//            if ([self.delegate respondsToSelector:@selector(sendPixelBufferRef:frame:)]) {
//                [self.delegate sendPixelBufferRef:resultPixelBuffer frame:currentFrame];
//            }
        }else{
            if ([self.delegate respondsToSelector:@selector(sendSampleBufferRef:frame:)]) {
                [self.delegate sendSampleBufferRef:currentTemplateSampleBufferRef frame:currentFrame];
            }
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
@end
