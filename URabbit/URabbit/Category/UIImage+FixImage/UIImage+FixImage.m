//
//  UIImage+FixImage.m
//  GLPFinance
//
//  Created by 鲍利成 on 2016/12/16.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#import "UIImage+FixImage.h"

@implementation UIImage (FixImage)
- (UIImage *)fixOrientationWithSize:(CGSize)size {
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    // No-op if the orientation is already correct
    if (self.imageOrientation != UIImageOrientationUp) {
        
        switch (self.imageOrientation) {
            case UIImageOrientationDown:
            case UIImageOrientationDownMirrored:
                transform = CGAffineTransformTranslate(transform, size.width, size.height);
                transform = CGAffineTransformRotate(transform, M_PI);
                break;
                
            case UIImageOrientationLeft:
            case UIImageOrientationLeftMirrored:
                transform = CGAffineTransformTranslate(transform, size.width, 0);
                transform = CGAffineTransformRotate(transform, M_PI_2);
                break;
                
            case UIImageOrientationRight:
            case UIImageOrientationRightMirrored:
                transform = CGAffineTransformTranslate(transform, 0, size.height);
                transform = CGAffineTransformRotate(transform, -M_PI_2);
                break;
            case UIImageOrientationUp:
            case UIImageOrientationUpMirrored:
                break;
        }
        
        switch (self.imageOrientation) {
            case UIImageOrientationUpMirrored:
            case UIImageOrientationDownMirrored:
                transform = CGAffineTransformTranslate(transform, size.width, 0);
                transform = CGAffineTransformScale(transform, -1, 1);
                break;
                
            case UIImageOrientationLeftMirrored:
            case UIImageOrientationRightMirrored:
                transform = CGAffineTransformTranslate(transform, size.height, 0);
                transform = CGAffineTransformScale(transform, -1, 1);
                break;
            case UIImageOrientationUp:
            case UIImageOrientationDown:
            case UIImageOrientationLeft:
            case UIImageOrientationRight:
                break;
        }
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, size.width, size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,size.height,size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,size.width,size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

//图片等比例缩放
-(UIImage *)scaledToFillSize:(CGSize)size
{
    CGFloat scale = MAX(size.width/self.size.width, size.height/self.size.height);
    CGFloat width = self.size.width * scale;
    CGFloat height = self.size.height * scale;
    CGRect imageRect = CGRectMake((size.width - width)/2.0f,
                                  (size.height - height)/2.0f,
                                  width,
                                  height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [self drawInRect:imageRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(UIImage *)scaledToAspectSize:(CGSize)size
{
    CGFloat scale = MIN(size.width/self.size.width, size.height/self.size.height);
    CGFloat width = self.size.width * scale;
    CGFloat height = self.size.height * scale;
    CGRect imageRect = CGRectMake((size.width - width)/2.0f,
                                  (size.height - height)/2.0f,
                                  width,
                                  height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [self drawInRect:imageRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(UIImage *)compressWithMaxLength:(NSUInteger)maxLength{
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(self, compression);
    //NSLog(@"Before compressing quality, image size = %ld KB",data.length/1024);
    if (data.length < maxLength) return self;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(self, compression);
        //NSLog(@"Compression = %.1f", compression);
        //NSLog(@"In compressing quality loop, image size = %ld KB", data.length / 1024);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    //NSLog(@"After compressing quality, image size = %ld KB", data.length / 1024);
    if (data.length < maxLength) return [UIImage imageWithData:data];
    UIImage *resultImage = [UIImage imageWithData:data];
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        //NSLog(@"Ratio = %.1f", ratio);
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
        //NSLog(@"In compressing size loop, image size = %ld KB", data.length / 1024);
    }
    //NSLog(@"After compressing size loop, image size = %ld KB", data.length / 1024);
    return [UIImage imageWithData:data];
}

- (UIImage *)imageWithMask:(UIImage*)imageMask orginImagePoint:(CGPoint)point colorSpace:(CGColorSpaceRef)colorSpace
{
    CGContextRef mainViewContentContext = CGBitmapContextCreate(NULL, imageMask.size.width, imageMask.size.height,8,0, colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);

    CGImageRef maskRef = imageMask.CGImage;

    CGContextClipToMask(mainViewContentContext, CGRectMake(0, 0, imageMask.size.width, imageMask.size.height), maskRef);

    CGContextDrawImage(mainViewContentContext, CGRectMake(point.x, point.y, self.size.width, self.size.height), self.CGImage);
    CGImageRef imageRef = CGBitmapContextCreateImage(mainViewContentContext);
    UIImage *reSizeImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGContextRelease(mainViewContentContext);
    return reSizeImage;
}

- (UIImage *)imageWithMask:(UIImage*)imageMask orginImagePoint:(CGPoint)point
{
    CGSize size = imageMask.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    UIGraphicsGetCurrentContext();
    [self drawInRect:CGRectMake(0,0, size.width, size.height)];
    [imageMask drawInRect:CGRectMake(0, 0, size.width, size.width)
blendMode:kCGBlendModeDestinationIn alpha:1];
    UIImage* retImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return retImage;
}

- (UIImage *)mergeImage:(UIImage *)image withMask:(UIImage*)imageMask orginImagePoint:(CGPoint)point
{
    const CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    const CGContextRef mainViewContentContext = CGBitmapContextCreate(NULL, imageMask.size.width, imageMask.size.height,8,0, colorSpace,kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(mainViewContentContext, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
    CGImageRef maskRef = imageMask.CGImage;
    
    CGContextClipToMask(mainViewContentContext, CGRectMake(0, 0, imageMask.size.width, imageMask.size.height), maskRef);
    CGContextDrawImage(mainViewContentContext, CGRectMake(point.x, point.y, self.size.width, self.size.height), image.CGImage);
    CGContextSetBlendMode(mainViewContentContext, kCGBlendModeSourceIn);
    CGContextSetAlpha(mainViewContentContext, 0.5);
    CGImageRef imageRef = CGBitmapContextCreateImage(mainViewContentContext);
    UIImage *reSizeImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGContextRelease(mainViewContentContext);
    CGColorSpaceRelease(colorSpace);
    return reSizeImage;
}

-(UIImage *)fixOrientation{
    
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp)
        return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

//这里写了一个方法传入需要的透明度和图片
- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, self.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}
@end
