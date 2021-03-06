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
#import "URImageHanderManager.h"
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
        bytesPerRow = [[URImageHanderManager shareManager] bytesPerRowFromSampleBuffer:currentTemplateSampleBufferRef];
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
            void *templatePixelBuffer = [[URImageHanderManager shareManager] baseAddressFromSampleBuffer:currentTemplateSampleBufferRef];
            UIImage *templateImage = [[URImageHanderManager shareManager] bgImageFromPixelBuffer:templatePixelBuffer size:currentPixelSize bytesPerRow:bytesPerRow];

            UIImage *resultImage = [self coverImageWithBackgroundImage:templateImage maskImage:currentMaskImage snapImage:currentSnapshot.snapshotImage size:currentPixelSize];

            CVPixelBufferRef resultPixelBuffer = [[URImageHanderManager shareManager] pixelBufferFromImage:resultImage size:currentPixelSize bytesPerRow:bytesPerRow];
            void *resultBaseAddress = [[URImageHanderManager shareManager] baseAddressWithCVPixelBuffer:resultPixelBuffer];
            memcpy(templatePixelBuffer, resultBaseAddress, bytesPerRow*currentPixelSize.height);
            
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
    CGColorSpaceRef colorSpace = [[URImageHanderManager shareManager] currentColorSpaceRef];
    CGContextRef mainViewContentContext = CGBitmapContextCreate(NULL, size.width, size.height,8,0, colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    
    if (bgImage) {
        CGContextDrawImage(mainViewContentContext, CGRectMake(0, 0, size.width, size.height), bgImage.CGImage);
    }
    
    if (snapImage) {
        CGContextDrawImage(mainViewContentContext, CGRectMake(0, 0, size.width, size.height), snapImage.CGImage);
    }
    
    if (maskImage) {
        CGContextDrawImage(mainViewContentContext, CGRectMake(0, 0, size.width, size.height), maskImage.CGImage);
    }
    
    CGImageRef newImageRef = CGBitmapContextCreateImage(mainViewContentContext);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease(newImageRef);
    CGContextRelease(mainViewContentContext);
    return newImage;
}
@end
