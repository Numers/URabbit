//
//  UTImageHanderManager.m
//  URabbit
//
//  Created by 鲍利成 on 2018/10/12.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTImageHanderManager.h"
#import <CoreMedia/CMSampleBuffer.h>
@interface UTImageHanderManager()
{
    CGColorSpaceRef colorSpace;
}
@end

@implementation UTImageHanderManager
+(instancetype)shareManager
{
    static UTImageHanderManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[UTImageHanderManager alloc] init];
    });
    return manager;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    return self;
}


-(void *)baseAddressFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    // 为媒体数据设置一个CMSampleBuffer的Core Video图像缓存对象
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // 锁定pixel buffer的基地址
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // 得到pixel buffer的基地址
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    // 解锁pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    return baseAddress;
}

-(CGColorSpaceRef)currentColorSpaceRef
{
    return colorSpace;
}

-(UIImage *) imageFromPixelBuffer:(void *) pixelBuffer size:(CGSize)size{
    size_t bytesPerRow = size.width * 4;
    
    // 用抽样缓存的数据创建一个位图格式的图形上下文（graphics context）对象
    CGContextRef context = CGBitmapContextCreate(pixelBuffer, size.width, size.height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // 根据这个位图context中的像素数据创建一个Quartz image对象
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    
    // 释放context和颜色空间
    CGContextRelease(context);
    
    // 用Quartz image创建一个UIImage对象image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    // 释放Quartz image对象
    CGImageRelease(quartzImage);
    
    return (image);
}

-(void)convertImagePixelReverse:(void *)pixelBuffer size:(CGSize)size
{
    uint32_t* pCurPtr = pixelBuffer;
    int pixelNum = size.width * size.height;
    for (int i = 0; i < pixelNum; i++, pCurPtr++)
    {
        uint8_t* ptr = (uint8_t*)pCurPtr;
        ptr[1] = 255 - ptr[1]; ////0~255
        ptr[2] = 255 - ptr[2];
        ptr[3] = 255 - ptr[3];
    }
}

-(void *)baseAddressWithCVPixelBuffer:(CVPixelBufferRef)pixelBufferRef
{
    // 锁定pixel buffer的基地址
    CVPixelBufferLockBaseAddress(pixelBufferRef, 0);
    // 得到pixel buffer的基地址
    void *baseAddress = CVPixelBufferGetBaseAddress(pixelBufferRef);
    CVPixelBufferUnlockBaseAddress(pixelBufferRef,0);
    return baseAddress;
}

- (CVPixelBufferRef)pixelBufferFromImage:(UIImage *)image size:(CGSize)size {
    CVPixelBufferRef pxbuffer = NULL;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, size.width,
                                          size.height, kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef) options,
                                          &pxbuffer);
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGContextRef context = CGBitmapContextCreate(pxdata, size.width,
                                                 size.height, 8, 4*size.width, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    NSParameterAssert(context);
    CGImageRef imageRef = image.CGImage;
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(imageRef),
                                           CGImageGetHeight(imageRef)), imageRef);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    CGContextRelease(context);
//    CGImageRelease(imageRef);
//        CFRelease(imageRef);
    //    imageRef = nil;
    return pxbuffer;
}





















-(UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer {
    // 为媒体数据设置一个CMSampleBuffer的Core Video图像缓存对象
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // 锁定pixel buffer的基地址
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // 得到pixel buffer的基地址
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // 创建一个依赖于设备的RGB颜色空间
    //    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // 用抽样缓存的数据创建一个位图格式的图形上下文（graphics context）对象
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace,   kCGBitmapByteOrder32Big |kCGImageAlphaPremultipliedFirst);
    // 根据这个位图context中的像素数据创建一个Quartz image对象
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    UIImage *resultImage = [UIImage imageWithCGImage:quartzImage];
    CGImageRelease(quartzImage);
    // 解锁pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    CGContextRelease(context);
    //    CGColorSpaceRelease(colorSpace);
    return resultImage;
}

-(void *) imagePixelBufferFromSampleBuffer:(CMSampleBufferRef) sampleBuffer {
    // 为媒体数据设置一个CMSampleBuffer的Core Video图像缓存对象
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // 锁定pixel buffer的基地址
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // 得到pixel buffer的基地址
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // 创建一个依赖于设备的RGB颜色空间
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // 用抽样缓存的数据创建一个位图格式的图形上下文（graphics context）对象
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little |kCGImageAlphaPremultipliedFirst);
    // 根据这个位图context中的像素数据创建一个Quartz image对象
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    void *resultImageBuffer = [self imageBuffer:quartzImage width:width height:height];
    // 释放context和颜色空间
    CGImageRelease(quartzImage);
    // 解锁pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    CGContextRelease(context);
//    CGColorSpaceRelease(colorSpace);
    return baseAddress;
}

-(CVImageBufferRef) imagePixelBufferAlphaOnlyFromSampleBuffer:(CMSampleBufferRef) sampleBuffer {
    // 为媒体数据设置一个CMSampleBuffer的Core Video图像缓存对象
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    return imageBuffer;
}


-(void *)imageBuffer:(CGImageRef)image width:(float)width height:(float)height
{
    const int imageWidth = width;
    
    const int imageHeight = height;
    
    size_t bytesPerRow = imageWidth * 4;
    
    void* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
    // 创建context
    
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image);
    
    CGContextRelease(context);
    
//    CGColorSpaceRelease(colorSpace);
    return rgbImageBuf;
}

-(CGSize)sizeForSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    return CGSizeMake(width, height);
}


void ProviderReleaseData (void *info, const void *data, size_t size)
{
//    free((void*)data);
}

-(UIImage *)generateImageFromPixelBuffer:(void *)pixelBuffer size:(CGSize)size
{
    // 创建一个依赖于设备的RGB颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    size_t bytesPerRow = size.width * 4;
    // 用抽样缓存的数据创建一个位图格式的图形上下文（graphics context）对象
    CGContextRef context = CGBitmapContextCreate(pixelBuffer, size.width, size.height, 8,
                                                 bytesPerRow, colorSpace,  kCGBitmapByteOrder32Little |kCGImageAlphaPremultipliedFirst);
    // 根据这个位图context中的像素数据创建一个Quartz image对象
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    
    // 释放context和颜色空间
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // 用Quartz image创建一个UIImage对象image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    // 释放Quartz image对象
    CGImageRelease(quartzImage);
    
    return (image);
}

-(UIImage *)generalImageWithBuffer:(void *)buffer size:(CGSize)size
{
    size_t width = size.width;
    size_t height = size.height;
    size_t bytesPerRow = width * 4;
    //    size_t bytesPerRow = size.width * 4;
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, buffer, bytesPerRow * height, ProviderReleaseData);
    
    CGImageRef imageRef = CGImageCreate(width, height,8, 32, bytesPerRow, colorSpace,
                                        
                                        kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedFirst, dataProvider,
                                        
                                        NULL, true,kCGRenderingIntentDefault);
    
    CGDataProviderRelease(dataProvider);
    UIImage *resultImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return resultImage;
}

-(void)attachPixelBuffer:(CVImageBufferRef)fromPixelBuffer toPixelBuffer:(CVImageBufferRef)toPixelBuffer size:(CGSize)size
{
    CVPixelBufferLockBaseAddress(fromPixelBuffer, 0);
    CVPixelBufferLockBaseAddress(toPixelBuffer, 0);
    void *fromData = CVPixelBufferGetBaseAddress(fromPixelBuffer);
    void *toData = CVPixelBufferGetBaseAddress(toPixelBuffer);
    memcpy(toData, fromData, size.width * size.height * 4);
    CVPixelBufferUnlockBaseAddress(fromPixelBuffer, 0);
    CVPixelBufferUnlockBaseAddress(toPixelBuffer, 0);
}

-(UIImage *)blendImage:(UIImage *)image1 withOtherImage:(void *)templateImageBuffer
{
    void *image1Buffer = [self baseAddressWithCVPixelBuffer:[self pixelBufferFromImage:image1 size:image1.size]];
    
    unsigned long pixelNum = image1.size.width * image1.size.height;
    uint32_t* pCurPtr = image1Buffer;
    uint32_t* bCurPtr = templateImageBuffer;
    for (unsigned long i = 0; i < pixelNum; i++, pCurPtr++,bCurPtr++)
    {
        uint8_t* btr = (uint8_t*)bCurPtr;
        uint8_t* ptr = (uint8_t*)pCurPtr;
        if (ptr[0] > 0) {
            btr[1] = btr[1] | ptr[1];
            btr[2] = btr[2] | ptr[2];
            btr[3] = btr[3] | ptr[3];
        }
    }
    UIImage *resultImage = [self generalImageWithBuffer:templateImageBuffer size:image1.size];
    return resultImage;
}

- (CVPixelBufferRef)pixelBufferFrom32BGRAData:(void *)framedata size:(CGSize)size
{
    NSDictionary *pixelAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                                     [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                                     nil];
    CVPixelBufferRef pixelBuffer = NULL;
    
    int width = size.width;
    int height = size.height;
    
    CVReturn result = CVPixelBufferCreate(kCFAllocatorDefault,
                                          width,
                                          height,
                                          kCVPixelFormatType_32ARGB,
                                          (__bridge CFDictionaryRef)pixelAttributes,
                                          &pixelBuffer);
    
    if (result != kCVReturnSuccess){
        NSLog(@"Unable to create cvpixelbuffer %d", result);
        return nil;
    }
    
    CVPixelBufferLockBaseAddress(pixelBuffer,0);
    unsigned char *yDestPlane = (unsigned char *)CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
    if (yDestPlane == NULL)
    {
        NSLog(@"create yDestPlane failed. value is NULL");
        return nil;
    }
    
    //这里是重点，为什么copy 的数据长度是  width * height*4 呢？
    memcpy(yDestPlane, framedata, width * height*4);
    
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    
    return pixelBuffer;
}

- (UIImage *)addImage:(UIImage *)image1 rect:(CGRect)rect1 toImage:(UIImage *)image2 rect:(CGRect)rect2 size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
//    // Draw image1
//    [image1 drawInRect:rect1 blendMode:kCGBlendModeCopy alpha:1];
//    // Draw image2
//    [image2 drawInRect:rect2 blendMode:kCGBlendModeMultiply alpha:1];
    CGContextScaleCTM(contextRef, 1, -1);
    CGContextTranslateCTM(contextRef, 0, -size.height);
    CGContextSetAlpha(contextRef, 1);
    CGContextDrawImage(contextRef, rect1, image1.CGImage);
    CGContextDrawImage(contextRef, rect2, image2.CGImage);
    CGContextSetBlendMode(contextRef, kCGBlendModePlusLighter);
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

-(void)mixPixelBufferByAdd:(void *)templateImageBuffer maskImageBuffer:(void *)maskImageBuffer size:(CGSize)size
{
    unsigned long pixelNum = size.width * size.height;
    uint32_t* pCurPtr = maskImageBuffer;
    uint32_t* bCurPtr = templateImageBuffer;
    for (unsigned long i = 0; i < pixelNum; i++, pCurPtr++,bCurPtr++)
    {
        uint8_t* btr = (uint8_t*)bCurPtr;
        uint8_t* ptr = (uint8_t*)pCurPtr;
        
        int r;
        if (btr[1] * ptr[0] + ptr[1] * btr[0] >= btr[0] * ptr[0]) {
            r = btr[0] * ptr[0] + btr[1] * (255.0 - ptr[0]) + ptr[1] * (255.0 - btr[0]);
        } else {
            r = btr[1] + ptr[1];
        }
        btr[1] = r;
        
        int g;
        if (btr[2] * ptr[0] + ptr[2] * btr[0] >= btr[0] * ptr[0]) {
            g = btr[0] * ptr[0] + btr[2] * (255.0 - ptr[0]) + ptr[2] * (255.0 - btr[0]);
        } else {
            g = btr[2] + ptr[2];
        }
        
        btr[2] = g;
        
        int b;
        if (btr[3] * ptr[0] + ptr[3] * btr[0] >= btr[0] * ptr[0]) {
            b = btr[0] * ptr[0] + btr[3] * (255.0 - ptr[0]) + ptr[3] * (255.0 - btr[0]);
        } else {
            b = btr[3] + ptr[3];
        }
        
        btr[3] = b;
        
        int a = btr[0] + ptr[0] - btr[0] * ptr[0];
        btr[0] = a;
        
//        NSLog(@"btr after add %d, %d,%d,%d",btr[0],btr[1],btr[2],btr[3]);
    }
}

-(UIImage *)zipScaleWithImage:(UIImage *)sourceImage{
    //进行图像尺寸的压缩
    CGSize imageSize = sourceImage.size;//取出要压缩的image尺寸
    CGFloat width = imageSize.width;    //图片宽度
    CGFloat height = imageSize.height;  //图片高度
    //1.宽高大于1280(宽高比不按照2来算，按照1来算)
    if (width>SCREEN_WIDTH||height>SCREEN_HEIGHT) {
        if (width>height) {
            CGFloat scale = height/width;
            width = SCREEN_WIDTH;
            height = width*scale;
        }else{
            CGFloat scale = width/height;
            height = SCREEN_HEIGHT;
            width = height*scale;
        }
        //2.宽大于1280高小于1280
    }else if(width>SCREEN_WIDTH||height<SCREEN_HEIGHT){
        CGFloat scale = height/width;
        width = SCREEN_WIDTH;
        height = width*scale;
        //3.宽小于1280高大于1280
    }else if(width<SCREEN_WIDTH||height>SCREEN_HEIGHT){
        CGFloat scale = width/height;
        height = SCREEN_HEIGHT;
        width = height*scale;
        //4.宽高都小于1280
    }else{
    }
    //进行尺寸重绘
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [sourceImage drawInRect:CGRectMake(0,0,width,height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *newImageData = UIImageJPEGRepresentation(newImage, 0.5);
    UIImage *returnImage = [UIImage imageWithData:newImageData];
    return returnImage;
}

-(CMSampleBufferRef) GPUImageCreateResizedSampleBuffer:(CVPixelBufferRef)cameraFrame size: (CGSize) finalSize frame:(int)frame fps:(int32_t)fps
{
    // CVPixelBufferCreateWithPlanarBytes for YUV input
    
    CGSize originalSize = CGSizeMake(CVPixelBufferGetWidth(cameraFrame), CVPixelBufferGetHeight(cameraFrame));
    
    CVPixelBufferLockBaseAddress(cameraFrame, 0);
    GLubyte *sourceImageBytes =  CVPixelBufferGetBaseAddress(cameraFrame);
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, sourceImageBytes, CVPixelBufferGetBytesPerRow(cameraFrame) * originalSize.height, NULL);
    CGColorSpaceRef genericRGBColorspace = CGColorSpaceCreateDeviceRGB();
    CGImageRef cgImageFromBytes = CGImageCreate((int)originalSize.width, (int)originalSize.height, 8, 32, CVPixelBufferGetBytesPerRow(cameraFrame), genericRGBColorspace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst, dataProvider, NULL, NO, kCGRenderingIntentDefault);
    
    GLubyte *imageData = (GLubyte *) calloc(1, (int)finalSize.width * (int)finalSize.height * 4);
    
    CGContextRef imageContext = CGBitmapContextCreate(imageData, (int)finalSize.width, (int)finalSize.height, 8, (int)finalSize.width * 4, genericRGBColorspace,  kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(imageContext, CGRectMake(0.0, 0.0, finalSize.width, finalSize.height), cgImageFromBytes);
    CGImageRelease(cgImageFromBytes);
    CGContextRelease(imageContext);
    CGColorSpaceRelease(genericRGBColorspace);
    CGDataProviderRelease(dataProvider);
    
    CVPixelBufferRef pixel_buffer = NULL;
    CVPixelBufferCreateWithBytes(kCFAllocatorDefault, finalSize.width, finalSize.height, kCVPixelFormatType_32BGRA, imageData, finalSize.width * 4, nil, NULL, NULL, &pixel_buffer);
    CMVideoFormatDescriptionRef videoInfo = NULL;
    
    
//    OSStatus status;
//    // CVPixelAspectRatio
//    NSDictionary *par = @{
//                          @"HorizontalSpacing" : @1,
//                          @"VerticalSpacing" : @1};
//    // SampleDescriptionExtensionAtoms
//    NSDictionary *newExtensions = @{
//                                    @"CVBytesPerRow":@(finalSize.width * 4),
//                                    @"Version":@(2),
//                                    @"CVImageBufferChromaLocationBottomField" : @"left",
//                                    @"CVImageBufferChromaLocationTopField" : @"left",
//                                    @"CVFieldCount" : @1,
//                                    @"CVPixelAspectRatio" : par};
//
//    status = CMVideoFormatDescriptionCreate(NULL, kCVPixelFormatType_32ARGB, finalSize.width, finalSize.height, (__bridge CFDictionaryRef)newExtensions, &videoInfo);

    CMVideoFormatDescriptionCreateForImageBuffer(NULL, pixel_buffer, &videoInfo);
    
    CMTime frameTime = CMTimeMake(frame, fps);
    CMSampleTimingInfo timing = {kCMTimeInvalid, frameTime, kCMTimeInvalid};
    
    CMSampleBufferRef sampleBuffer;
    CMSampleBufferCreateForImageBuffer(kCFAllocatorDefault, pixel_buffer, YES, NULL, NULL, videoInfo, &timing, &sampleBuffer);
    CFRelease(videoInfo);
    CVPixelBufferRelease(pixel_buffer);
    return sampleBuffer;
}
@end
