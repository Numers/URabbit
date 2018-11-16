//
//  UTImageHanderManager.h
//  URabbit
//
//  Created by 鲍利成 on 2018/10/12.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface UTImageHanderManager : NSObject
+(instancetype)shareManager;
-(void *)baseAddressFromSampleBuffer:(CMSampleBufferRef) sampleBuffer;
-(UIImage *) imageFromPixelBuffer:(void *) pixelBuffer size:(CGSize)size;
-(void)convertImagePixelReverse:(void *)pixelBuffer size:(CGSize)size;
-(void *)baseAddressWithCVPixelBuffer:(CVPixelBufferRef)pixelBufferRef;
- (CVPixelBufferRef)pixelBufferFromImage:(UIImage *)image size:(CGSize)size;
- (CVPixelBufferRef)pixelBufferAdaptFromImage:(UIImage *)image size:(CGSize)size;
-(CGColorSpaceRef)currentColorSpaceRef;
-(void)setCurrentImageSize:(CGSize)size;




- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer;
-(void *) imagePixelBufferFromSampleBuffer:(CMSampleBufferRef) sampleBuffer;
-(CVImageBufferRef) imagePixelBufferAlphaOnlyFromSampleBuffer:(CMSampleBufferRef) sampleBuffer;

-(void)mixPixelBufferByAdd:(void *)templateImageBuffer maskImageBuffer:(void *)maskImageBuffer size:(CGSize)size;
-(UIImage *)generateImageFromPixelBuffer:(void *)pixelBuffer size:(CGSize)size;
-(CGSize)sizeForSampleBuffer:(CMSampleBufferRef) sampleBuffer;
-(UIImage *)generalImageWithBuffer:(void *)buffer size:(CGSize)size;
-(void)attachPixelBuffer:(CVImageBufferRef)fromPixelBuffer toPixelBuffer:(CVImageBufferRef)toPixelBuffer size:(CGSize)size;
- (CVPixelBufferRef)pixelBufferFrom32BGRAData:(void *)framedata size:(CGSize)size;
- (UIImage *)addImage:(UIImage *)image1 rect:(CGRect)rect1 toImage:(UIImage *)image2 rect:(CGRect)rect2 size:(CGSize)size;
-(NSData *)zipScaleWithImage:(UIImage *)sourceImage;
-(CMSampleBufferRef) GPUImageCreateResizedSampleBuffer:(CVPixelBufferRef)cameraFrame size: (CGSize) finalSize frame:(int)frame fps:(int32_t)fps;

-(UIImage *)blendImage:(UIImage *)image1 withOtherImage:(void *)templateImageBuffer;
@end
