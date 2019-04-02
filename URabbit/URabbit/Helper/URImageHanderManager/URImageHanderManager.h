//
//  URImageHanderManager.h
//  URabbit
//
//  Created by 鲍利成 on 2018/10/12.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "GPUImage.h"

@interface URImageHanderManager : NSObject
+(instancetype)shareManager;
-(size_t)bytesPerRowFromSampleBuffer:(CMSampleBufferRef)sampleBuffer;
-(CGImageRef)cgImageFromSampleBufferRef:(CMSampleBufferRef)sampleBufferRef;
-(UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer;
-(void *)baseAddressFromSampleBuffer:(CMSampleBufferRef) sampleBuffer;
-(UIImage *) bgImageFromPixelBuffer:(void *) pixelBuffer size:(CGSize)size bytesPerRow:(size_t)bytesPerRow;
-(UIImage *) imageFromPixelBuffer:(void *) pixelBuffer size:(CGSize)size bytesPerRow:(size_t)bytesPerRow;
-(void)convertImagePixelReverse:(void *)pixelBuffer size:(CGSize)size;
-(void *)baseAddressWithCVPixelBuffer:(CVPixelBufferRef)pixelBufferRef;
- (CVPixelBufferRef)pixelBufferFromImage:(UIImage *)image size:(CGSize)size bytesPerRow:(size_t)bytesPerRow;
- (CVPixelBufferRef)pixelBufferAdaptFromImage:(UIImage *)image size:(CGSize)size bytesPerRow:(size_t)bytesPerRow;
-(CGColorSpaceRef)currentColorSpaceRef;
-(void)setCurrentImageSize:(CGSize)size;
-(UIImage *)filterImage:(UIImage *)image filterName:(NSString *)filterName size:(CGSize)size;
-(GPUImageOutput<GPUImageInput> *)filterWithFilterType:(FilterType)type;




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
@end
