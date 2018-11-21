//
//  ComposeRotationOperation.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/9.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "ComposeRotationOperation.h"
#import "GPUImage.h"
#import "SnapshotMedia.h"
#import "AnimationForMedia.h"
#import "UTImageHanderManager.h"
@interface ComposeRotationOperation()
{
    GPUImageTwoInputFilter *filter;
}
@end
@implementation ComposeRotationOperation
-(instancetype)initWithTemplateSampleBufferRef:(CMSampleBufferRef)templateSampleBufferRef maskSampleBufferRef:(CMSampleBufferRef)maskSampleBufferRef frame:(NSInteger)frame snapshotMedia:(SnapshotMedia *)snapshotMedia animation:(AnimationForMedia *)animation pixelSize:(CGSize)pixelSize fps:(CGFloat)fps
{
    self = [super init];
    if (self) {
        currentTemplateSampleBufferRef = templateSampleBufferRef;
        currentMaskSampleBufferRef = maskSampleBufferRef;
        currentFrame = frame;
        currentSnapshotMedia = snapshotMedia;
        currentAnimation = animation;
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
            UIImage *tempResultImage = [self imageWithMask:maskImage snapshotMedia:currentSnapshotMedia animation:currentAnimation frameIndex:currentFrame pixelSize:currentPixelSize];
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
            
        }else{
            if ([self.delegate respondsToSelector:@selector(sendSampleBufferRef:frame:)]) {
                [self.delegate sendSampleBufferRef:currentTemplateSampleBufferRef frame:currentFrame];
            }
        }
    }
}

-(UIImage *)imageWithMask:(UIImage *)maskImage snapshotMedia:(SnapshotMedia *)media animation:(AnimationForMedia *)animation frameIndex:(NSInteger)index pixelSize:(CGSize)pixelSize
{
    CGColorSpaceRef colorSpace = [[UTImageHanderManager shareManager] currentColorSpaceRef];
    CGContextRef mainViewContentContext = CGBitmapContextCreate(NULL, pixelSize.width, pixelSize.height,8,0, colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    
    CGImageRef maskRef = maskImage.CGImage;
    CGContextClipToMask(mainViewContentContext, CGRectMake(0, 0, maskImage.size.width, maskImage.size.height), maskRef);
    if (animation.type == AnimationRotation) {
        CGContextSaveGState(mainViewContentContext);
        CGFloat centerX = pixelSize.width * animation.centerXPercent;
        CGFloat centerY = pixelSize.height * (1-animation.centerYPercent);
        CGContextTranslateCTM(mainViewContentContext, centerX, centerY);
        CGFloat rotateAngle = -((animation.endAngle - animation.startAngle) * M_PI / 180) / (animation.range.length);
        CGContextRotateCTM(mainViewContentContext,rotateAngle*(index - animation.range.location));
        CGContextDrawImage(mainViewContentContext, CGRectMake(-centerX, -centerY, media.resultImage.size.width, media.resultImage.size.height), media.resultImage.CGImage);
        CGContextRestoreGState(mainViewContentContext);
    }else{
        CGContextDrawImage(mainViewContentContext, CGRectMake(0, 0, media.resultImage.size.width, media.resultImage.size.height), media.resultImage.CGImage);
    }
    
    CGImageRef newImageRef = CGBitmapContextCreateImage(mainViewContentContext);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease(newImageRef);
    CGContextRelease(mainViewContentContext);
    return newImage;
}
@end
