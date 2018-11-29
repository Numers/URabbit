//
//  ComposeCoverOperation.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/22.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "ComposeCoverOperation.h"
#import "Snapshot.h"
#import "GPUImage.h"
#import "UTImageHanderManager.h"
@interface ComposeCoverOperation()
{

}
@end
@implementation ComposeCoverOperation
-(instancetype)initWithTemplateSampleBufferRef:(CMSampleBufferRef)templateSampleBufferRef maskImage:(UIImage *)maskImage Frame:(NSInteger)frame snapshot:(Snapshot *)snapshot pixelSize:(CGSize)pixelSize
{
    self = [super init];
    if (self) {
        currentSnapshot = snapshot;
        currentTemplateSampleBufferRef = templateSampleBufferRef;
        currentFrame = frame;
        currentPixelSize = pixelSize;
        currentMaskImage = maskImage;
    }
    return self;
}

-(void)main
{
    @autoreleasepool {
        if (currentTemplateSampleBufferRef) {
            void *templatePixelBuffer = [[UTImageHanderManager shareManager] baseAddressFromSampleBuffer:currentTemplateSampleBufferRef];
            UIImage *templateImage = [[UTImageHanderManager shareManager] bgImageFromPixelBuffer:templatePixelBuffer size:currentPixelSize];

            UIImage *resultImage = [self coverImageWithBackgroundImage:templateImage maskImage:currentMaskImage snapImage:currentSnapshot.snapshotImage size:currentPixelSize];

            CVPixelBufferRef resultPixelBuffer = [[UTImageHanderManager shareManager] pixelBufferFromImage:resultImage size:currentPixelSize];
            void *resultBaseAddress = [[UTImageHanderManager shareManager] baseAddressWithCVPixelBuffer:resultPixelBuffer];
            memcpy(templatePixelBuffer, resultBaseAddress, 4*currentPixelSize.width*currentPixelSize.height);
            
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

-(UIImage *)coverImageWithBackgroundImage:(UIImage *)bgImage maskImage:(UIImage *)maskImage snapImage:(UIImage *)snapImage size:(CGSize)size
{
    CGColorSpaceRef colorSpace = [[UTImageHanderManager shareManager] currentColorSpaceRef];
    CGContextRef mainViewContentContext = CGBitmapContextCreate(NULL, size.width, size.height,8,0, colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    
    CGContextDrawImage(mainViewContentContext, CGRectMake(0, 0, size.width, size.height), bgImage.CGImage);
    CGContextDrawImage(mainViewContentContext, CGRectMake(0, 0, size.width, size.height), snapImage.CGImage);
    CGContextDrawImage(mainViewContentContext, CGRectMake(0, 0, size.width, size.height), maskImage.CGImage);
    
    CGImageRef newImageRef = CGBitmapContextCreateImage(mainViewContentContext);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease(newImageRef);
    CGContextRelease(mainViewContentContext);
    return newImage;
}
@end
