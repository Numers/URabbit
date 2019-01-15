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
#import "SnapshotText.h"
#import "Text.h"
#import "AnimationForMedia.h"
#import "UTImageHanderManager.h"
#import "UIImage+FixImage.h"
#import "AnimationForMediaFrame.h"
@interface ComposeRotationOperation()
{
    GPUImageTwoInputFilter *filter;
}
@end
@implementation ComposeRotationOperation
-(instancetype)initWithTemplateSampleBufferRef:(CMSampleBufferRef)templateSampleBufferRef maskSampleBufferRef:(CMSampleBufferRef)maskSampleBufferRef frame:(NSInteger)frame snapshotMedias:(NSMutableArray *)snapshotMedias snapshotText:(NSMutableArray *)snapshotTexts pixelSize:(CGSize)pixelSize fps:(CGFloat)fps
{
    self = [super init];
    if (self) {
        currentTemplateSampleBufferRef = templateSampleBufferRef;
        bytesPerRow = [[UTImageHanderManager shareManager] bytesPerRowFromSampleBuffer:currentTemplateSampleBufferRef];
        currentMaskSampleBufferRef = maskSampleBufferRef;
        currentFrame = frame;
        currentSnapshotMedias = snapshotMedias;
        currentSnapshotTexts = snapshotTexts;
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
            UIImage *templateImage = [[UTImageHanderManager shareManager] imageFromPixelBuffer:templatePixelBuffer size:currentPixelSize bytesPerRow:bytesPerRow];
            UIImage *theResultImage = nil;
            if (currentSnapshotMedias.count > 0) {
                UIImage *maskImage = nil;
                if (currentMaskSampleBufferRef) {
                    void *maskPixelBuffer = [[UTImageHanderManager shareManager] baseAddressFromSampleBuffer:currentMaskSampleBufferRef];
                    
                    [[UTImageHanderManager shareManager] convertImagePixelReverse:maskPixelBuffer size:currentPixelSize];
                    
                    maskImage = [[UTImageHanderManager shareManager] imageFromPixelBuffer:maskPixelBuffer size:currentPixelSize bytesPerRow:bytesPerRow];
                }
                
                UIImage *tempResultImage = [self imageWithMask:maskImage frameAxios:currentSnapshotMedias frameIndex:currentFrame pixelSize:currentPixelSize];
                GPUImagePicture *tempPic1 = [[GPUImagePicture alloc] initWithImage:templateImage];
                [tempPic1 addTarget:filter];
                [tempPic1 processImage];
                
                theResultImage = [filter imageByFilteringImage:tempResultImage];
                [tempPic1 removeTarget:filter];
            }else{
                theResultImage = templateImage;
            }
            
            UIImage *resultImage = nil;
            if (currentSnapshotTexts.count > 0) {
                resultImage = [self addTextlayerWithSnapshotTexts:currentSnapshotTexts onImage:theResultImage pixelSize:currentPixelSize];
            }else{
                resultImage = theResultImage;
            }

            if (currentFrame % halfVideoFps == 0) {
                if ([self.delegate respondsToSelector:@selector(sendImage:frame:)]) {
                    [self.delegate sendImage:resultImage frame:currentFrame];
                }
            }
            
            CVPixelBufferRef resultPixelBuffer = [[UTImageHanderManager shareManager] pixelBufferFromImage:resultImage size:currentPixelSize bytesPerRow:bytesPerRow];
            void *resultBaseAddress = [[UTImageHanderManager shareManager] baseAddressWithCVPixelBuffer:resultPixelBuffer];
            memcpy(templatePixelBuffer, resultBaseAddress, bytesPerRow * currentPixelSize.height);
            [filter removeOutputFramebuffer];
            if (currentMaskSampleBufferRef) {
                CFRelease(currentMaskSampleBufferRef);
            }

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

-(UIImage *)imageWithMask:(UIImage *)maskImage frameAxios:(NSMutableArray *)frameAxiosList frameIndex:(NSInteger)index pixelSize:(CGSize)pixelSize
{
    FrameAxios *frameAxios = [frameAxiosList objectAtIndex:0];
    AnimationForMedia *animation = frameAxios.animationForMedia;
    CGColorSpaceRef colorSpace = [[UTImageHanderManager shareManager] currentColorSpaceRef];
    CGContextRef mainViewContentContext = CGBitmapContextCreate(NULL, pixelSize.width, pixelSize.height,8,0, colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    if (maskImage) {
        CGImageRef maskRef = maskImage.CGImage;
        CGContextClipToMask(mainViewContentContext, CGRectMake(0, 0, maskImage.size.width, maskImage.size.height), maskRef);
    }
    UIImage *snapshotImage = [self snapshotImageWithFrameAxios:frameAxiosList frameIndex:index pixelSize:pixelSize];
    CGImageRef snapshotImageRef = snapshotImage.CGImage;
    if (animation.parentMediaAnimation.type == AnimationRotation) {
        CGContextSaveGState(mainViewContentContext);
        CGFloat centerX = pixelSize.width * animation.parentMediaAnimation.centerXPercent;
        CGFloat centerY = pixelSize.height * (1-animation.parentMediaAnimation.centerYPercent);
        CGContextTranslateCTM(mainViewContentContext, centerX, centerY);
        CGFloat rotateAngle = -((animation.parentMediaAnimation.endAngle - animation.parentMediaAnimation.startAngle) * M_PI / 180) / (animation.range.length);
        CGContextRotateCTM(mainViewContentContext,-animation.parentMediaAnimation.startAngle * M_PI / 180 + rotateAngle*(index - animation.range.location));
        CGContextDrawImage(mainViewContentContext, CGRectMake(-centerX, -centerY, snapshotImage.size.width, snapshotImage.size.height), snapshotImageRef);
        CGContextRestoreGState(mainViewContentContext);
    }else if(animation.parentMediaAnimation.type == AnimationScale){
        CGContextSaveGState(mainViewContentContext);
        CGFloat centerX = pixelSize.width * animation.parentMediaAnimation.centerXPercent;
        CGFloat centerY = pixelSize.height * (1-animation.parentMediaAnimation.centerYPercent);
        CGContextTranslateCTM(mainViewContentContext, centerX, centerY);
        CGFloat scaleRatio = (animation.parentMediaAnimation.endRatio - animation.parentMediaAnimation.startRatio) / animation.range.length;
        CGContextScaleCTM(mainViewContentContext,animation.parentMediaAnimation.startRatio+scaleRatio*(index - animation.range.location),animation.parentMediaAnimation.startRatio+scaleRatio*(index - animation.range.location));
        CGContextDrawImage(mainViewContentContext, CGRectMake(-centerX, -centerY, snapshotImage.size.width, snapshotImage.size.height), snapshotImageRef);
        CGContextRestoreGState(mainViewContentContext);
    }else if (animation.parentMediaAnimation.type == AnimationTransform){
        CGContextSaveGState(mainViewContentContext);
        CGFloat pieceX = (animation.parentMediaAnimation.endCoordinate.x - animation.parentMediaAnimation.startCoordinate.x) / animation.range.length;
        CGFloat pieceY = -(animation.parentMediaAnimation.endCoordinate.y - animation.parentMediaAnimation.startCoordinate.y) / animation.range.length;
        CGFloat centerX = pixelSize.width * (animation.parentMediaAnimation.startCoordinate.x + (index - animation.range.location) * pieceX);
        CGFloat centerY = pixelSize.height * (animation.parentMediaAnimation.startCoordinate.y + (index - animation.range.location) * pieceY);
        CGContextTranslateCTM(mainViewContentContext, centerX,centerY);
        CGContextDrawImage(mainViewContentContext, CGRectMake(-centerX, -centerY, snapshotImage.size.width, snapshotImage.size.height), snapshotImageRef);
        CGContextRestoreGState(mainViewContentContext);
    }else if (animation.parentMediaAnimation.type == AnimationBlur){
        CGContextSaveGState(mainViewContentContext);
        CGFloat centerX = pixelSize.width * animation.parentMediaAnimation.centerXPercent;
        CGFloat centerY = pixelSize.height * (1-animation.parentMediaAnimation.centerYPercent);
        CGContextTranslateCTM(mainViewContentContext, centerX, centerY);
        CGFloat blurPiece = (animation.parentMediaAnimation.endBlur - animation.parentMediaAnimation.startBlur) / animation.range.length;
        CGFloat blurNum = animation.parentMediaAnimation.startBlur + (index - animation.range.location) * blurPiece;
        
        UIImage *renderImage = [self GPUImageStyleWithImage:snapshotImage blur:blurNum];
        CGContextDrawImage(mainViewContentContext, CGRectMake(-centerX, -centerY, renderImage.size.width, renderImage.size.height), renderImage.CGImage);
        CGContextRestoreGState(mainViewContentContext);
    }else if (animation.parentMediaAnimation.type == AnimationAlpha){
        CGContextSaveGState(mainViewContentContext);
        CGFloat centerX = pixelSize.width * animation.parentMediaAnimation.centerXPercent;
        CGFloat centerY = pixelSize.height * (1-animation.parentMediaAnimation.centerYPercent);
        CGContextTranslateCTM(mainViewContentContext, centerX, centerY);
        CGFloat alphaPiece = (animation.parentMediaAnimation.endAlpha - animation.parentMediaAnimation.startAlpha) / animation.range.length;
        CGFloat alphaNum = animation.parentMediaAnimation.startAlpha + (index - animation.range.location) * alphaPiece;
        
        UIImage *renderImage = [snapshotImage imageByApplyingAlpha:alphaNum];
        CGContextDrawImage(mainViewContentContext, CGRectMake(-centerX, -centerY, renderImage.size.width, renderImage.size.height), renderImage.CGImage);
        CGContextRestoreGState(mainViewContentContext);
    }else if(animation.parentMediaAnimation.type == AnimationNone){
        CGContextSaveGState(mainViewContentContext);
        CGFloat centerX = pixelSize.width * animation.parentMediaAnimation.centerXPercent;
        CGFloat centerY = pixelSize.height * (1-animation.parentMediaAnimation.centerYPercent);
        CGContextTranslateCTM(mainViewContentContext, centerX, centerY);
        CGContextDrawImage(mainViewContentContext, CGRectMake(-centerX, -centerY, snapshotImage.size.width, snapshotImage.size.height), snapshotImageRef);
        CGContextRestoreGState(mainViewContentContext);
    }
    CGImageRef newImageRef = CGBitmapContextCreateImage(mainViewContentContext);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease(newImageRef);
    CGContextRelease(mainViewContentContext);
    return newImage;
}

-(UIImage *)snapshotImageWithFrameAxios:(NSMutableArray *)frameAxiosList frameIndex:(NSInteger)index pixelSize:(CGSize)pixelSize
{
    CGColorSpaceRef colorSpace = [[UTImageHanderManager shareManager] currentColorSpaceRef];
    CGContextRef mainViewContentContext = CGBitmapContextCreate(NULL, pixelSize.width, pixelSize.height,8,0, colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    
    for(FrameAxios *axios in frameAxiosList){
        AnimationForMedia *animation = axios.animationForMedia;
        UIImage *animationResultImage = nil;
        if (animation.mediaFrames.count > 0) {
            animationResultImage = [self frameImageWithFrameAxios:axios frameIndex:index pixelSize:pixelSize];
        }else{
            animationResultImage = [self animationImageWithFrameAxios:axios frameIndex:index pixelSize:pixelSize];
        }
        
        CGFloat width = pixelSize.width * animation.widthPercent;
        CGFloat height = pixelSize.height * animation.heightPercent;
        UIImage *resultImage = nil;
        if (animation.widthPercent == 1.0f && animation.heightPercent == 1.0f) {
            resultImage = animationResultImage;
        }else{
            resultImage = [animationResultImage scaledToFillSize:CGSizeMake(width, height)];
        }
        CGContextSaveGState(mainViewContentContext);
        CGFloat centerX = pixelSize.width * animation.locationCenterXPercent;
        CGFloat centerY = pixelSize.height * (1-animation.locationCenterYPercent);
        CGContextTranslateCTM(mainViewContentContext, centerX, centerY);
        CGContextDrawImage(mainViewContentContext, CGRectMake(-width / 2, -height/2, width, height), resultImage.CGImage);
        CGContextRestoreGState(mainViewContentContext);
        
    }
    CGImageRef newImageRef = CGBitmapContextCreateImage(mainViewContentContext);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease(newImageRef);
    CGContextRelease(mainViewContentContext);
    return newImage;
}

-(UIImage *)animationImageWithFrameAxios:(FrameAxios *)frameAxios frameIndex:(NSInteger)index pixelSize:(CGSize)pixelSize
{
    AnimationForMedia *animation = frameAxios.animationForMedia;
    SnapshotMedia *media = frameAxios.snapshotMedia;
    CGImageRef mediaResultImageRef = media.resultImage.CGImage;
    
    CGColorSpaceRef colorSpace = [[UTImageHanderManager shareManager] currentColorSpaceRef];
    CGContextRef mainViewContentContext = CGBitmapContextCreate(NULL, pixelSize.width, pixelSize.height,8,0, colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    
    if (animation.type == AnimationRotation) {
        CGContextSaveGState(mainViewContentContext);
        CGFloat centerX = pixelSize.width * animation.centerXPercent;
        CGFloat centerY = pixelSize.height * (1-animation.centerYPercent);
        CGContextTranslateCTM(mainViewContentContext, centerX, centerY);
        CGFloat rotateAngle = -((animation.endAngle - animation.startAngle) * M_PI / 180) / (animation.range.length);
        CGContextRotateCTM(mainViewContentContext,-animation.startAngle * M_PI / 180 + rotateAngle*(index - animation.range.location));
        CGContextDrawImage(mainViewContentContext, CGRectMake(-centerX, -centerY, media.resultImage.size.width, media.resultImage.size.height), mediaResultImageRef);
        CGContextRestoreGState(mainViewContentContext);
    }else if(animation.type == AnimationScale){
        CGContextSaveGState(mainViewContentContext);
        CGFloat centerX = pixelSize.width * animation.centerXPercent;
        CGFloat centerY = pixelSize.height * (1-animation.centerYPercent);
        CGContextTranslateCTM(mainViewContentContext, centerX, centerY);
        CGFloat scaleRatio = (animation.endRatio - animation.startRatio) / animation.range.length;
        CGContextScaleCTM(mainViewContentContext,animation.startRatio+scaleRatio*(index - animation.range.location),animation.startRatio+scaleRatio*(index - animation.range.location));
        CGContextDrawImage(mainViewContentContext, CGRectMake(-centerX, -centerY, media.resultImage.size.width, media.resultImage.size.height), mediaResultImageRef);
        CGContextRestoreGState(mainViewContentContext);
    }else if (animation.type == AnimationTransform){
        CGContextSaveGState(mainViewContentContext);
        CGFloat pieceX = (animation.endCoordinate.x - animation.startCoordinate.x) / animation.range.length;
        CGFloat pieceY = -(animation.endCoordinate.y - animation.startCoordinate.y) / animation.range.length;
        CGFloat centerX = pixelSize.width * (animation.startCoordinate.x + (index - animation.range.location) * pieceX);
        CGFloat centerY = pixelSize.height * (animation.startCoordinate.y + (index - animation.range.location) * pieceY);
        CGContextTranslateCTM(mainViewContentContext, centerX,centerY);
        CGContextDrawImage(mainViewContentContext, CGRectMake(-centerX, -centerY, media.resultImage.size.width, media.resultImage.size.height), mediaResultImageRef);
        CGContextRestoreGState(mainViewContentContext);
    }else if (animation.type == AnimationBlur){
        CGContextSaveGState(mainViewContentContext);
        CGFloat centerX = pixelSize.width * animation.centerXPercent;
        CGFloat centerY = pixelSize.height * (1-animation.centerYPercent);
        CGContextTranslateCTM(mainViewContentContext, centerX, centerY);
        CGFloat blurPiece = (animation.endBlur - animation.startBlur) / animation.range.length;
        CGFloat blurNum = animation.startBlur + (index - animation.range.location) * blurPiece;

        UIImage *renderImage = [self GPUImageStyleWithImage:media.resultImage blur:blurNum];
        CGContextDrawImage(mainViewContentContext, CGRectMake(-centerX, -centerY, renderImage.size.width, renderImage.size.height), renderImage.CGImage);
        CGContextRestoreGState(mainViewContentContext);
    }else if (animation.type == AnimationAlpha){
        CGContextSaveGState(mainViewContentContext);
        CGFloat centerX = pixelSize.width * animation.centerXPercent;
        CGFloat centerY = pixelSize.height * (1-animation.centerYPercent);
        CGContextTranslateCTM(mainViewContentContext, centerX, centerY);
        CGFloat alphaPiece = (animation.endAlpha - animation.startAlpha) / animation.range.length;
        CGFloat alphaNum = animation.startAlpha + (index - animation.range.location) * alphaPiece;
        
        UIImage *renderImage = [media.resultImage imageByApplyingAlpha:alphaNum];
        CGContextDrawImage(mainViewContentContext, CGRectMake(-centerX, -centerY, renderImage.size.width, renderImage.size.height), renderImage.CGImage);
        CGContextRestoreGState(mainViewContentContext);
    }else if(animation.type == AnimationNone){
        CGContextSaveGState(mainViewContentContext);
        CGFloat centerX = pixelSize.width * animation.centerXPercent;
        CGFloat centerY = pixelSize.height * (1-animation.centerYPercent);
        CGContextTranslateCTM(mainViewContentContext, centerX, centerY);
        CGContextDrawImage(mainViewContentContext, CGRectMake(-centerX, -centerY, media.resultImage.size.width, media.resultImage.size.height), mediaResultImageRef);
        CGContextRestoreGState(mainViewContentContext);
    }
    
    
    CGImageRef newImageRef = CGBitmapContextCreateImage(mainViewContentContext);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease(newImageRef);
    CGContextRelease(mainViewContentContext);
    return newImage;
}

-(UIImage *)frameImageWithFrameAxios:(FrameAxios *)frameAxios frameIndex:(NSInteger)index pixelSize:(CGSize)pixelSize
{
    AnimationForMedia *animation = frameAxios.animationForMedia;
    if ((index - animation.range.location) >= animation.mediaFrames.count) {
        return nil;
    }
    
    AnimationForMediaFrame *frameStatus = [animation.mediaFrames objectAtIndex:index - animation.range.location ];
    SnapshotMedia *media = frameAxios.snapshotMedia;

    UIImage *tempImage = media.resultImage;
    CGColorSpaceRef colorSpace = [[UTImageHanderManager shareManager] currentColorSpaceRef];
    CGContextRef mainViewContentContext = CGBitmapContextCreate(NULL, pixelSize.width, pixelSize.height,8,0, colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    
    if (frameStatus.alpha < 1.0f) {
        tempImage = [tempImage imageByApplyingAlpha:frameStatus.alpha];
    }
    
    if (frameStatus.blur > 0.0f) {
        tempImage = [self GPUImageStyleWithImage:tempImage blur:frameStatus.blur];
    }
    
    CGFloat width = pixelSize.width * frameStatus.widthPercent;
    CGFloat height = pixelSize.height * frameStatus.heightPercent;
    
    tempImage = [tempImage scaledToFillSize:CGSizeMake(width, height)];
    
    CGContextSaveGState(mainViewContentContext);
    CGFloat centerX = pixelSize.width * frameStatus.locationCenterXPercent;
    CGFloat centerY = pixelSize.height * (1-frameStatus.locationCenterYPercent);
    
    
    CGContextTranslateCTM(mainViewContentContext, centerX, centerY);
    CGContextRotateCTM(mainViewContentContext,-frameStatus.angle * M_PI / 180);
    CGContextDrawImage(mainViewContentContext, CGRectMake(-width / 2, -height / 2, width, height), tempImage.CGImage);
    CGContextRestoreGState(mainViewContentContext);
    
    CGImageRef newImageRef = CGBitmapContextCreateImage(mainViewContentContext);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease(newImageRef);
    CGContextRelease(mainViewContentContext);
    return newImage;
}

- (UIImage *)GPUImageStyleWithImage:(UIImage *)image blur:(CGFloat)blur{
    GPUImageGaussianBlurFilter *filter = [[GPUImageGaussianBlurFilter alloc] init];
    filter.blurRadiusInPixels = blur * 10;//值越大，模糊度越大
    UIImage *blurImage = [filter imageByFilteringImage:image];
    return blurImage;
}

-(UIImage *)addTextlayerWithSnapshotTexts:(NSMutableArray *)frameAxiosList onImage:(UIImage *)image pixelSize:(CGSize)size
{
    CGColorSpaceRef colorSpace = [[UTImageHanderManager shareManager] currentColorSpaceRef];
    CGContextRef mainViewContentContext = CGBitmapContextCreate(NULL, size.width, size.height,8,0, colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(mainViewContentContext, CGRectMake(0, 0, size.width, size.height), image.CGImage);
    for (FrameAxios *axios in frameAxiosList) {
        SnapshotText *snapshotText = axios.snapshotText;
        AnimationForText *animationForText = axios.animationForText;
        
        CGFloat width = size.width * snapshotText.widthPercent;
        CGFloat height = size.height * snapshotText.heightPercent;
        CGPoint currentCenterPoint = CGPointZero;
        if (animationForText) {
            currentCenterPoint = CGPointMake(size.width * animationForText.centerXPercent, size.height * animationForText.centerYPercent);
        }else{
            currentCenterPoint = CGPointMake(size.width * snapshotText.centerXPercent, size.height * snapshotText.centerYPercent);
        }
        CGContextSaveGState(mainViewContentContext);
        CGContextTranslateCTM(mainViewContentContext, currentCenterPoint.x, size.height - currentCenterPoint.y);
        CATextLayer *layerText = [CATextLayer layer];
        layerText.wrapped = YES;
        layerText.backgroundColor = [UIColor clearColor].CGColor;
        layerText.contentsScale = [UIScreen mainScreen].scale;
        layerText.bounds = CGRectMake(0, 0, width, height);
        //    [layerText setForegroundColor:[UIColor colorFromHexString:snapshotText.text.fontColor].CGColor];
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.firstLineHeadIndent = 0;
        paragraphStyle.paragraphSpacing = 0;
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        [attributes setObject:[UIColor colorFromHexString:snapshotText.text.fontColor] forKey:NSForegroundColorAttributeName];
        // 字体名称、大小
        UIFont *font = nil;
        NSString *fontDirectory = [AppUtils createDirectory:@"UTFont"];
        NSString *fontFileDirectoryPath = [NSString stringWithFormat:@"%@/%@",fontDirectory,[AppUtils getMd5_32Bit:snapshotText.text.fontUrl]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:fontFileDirectoryPath]) {
            font = [AppUtils customFontWithPath:fontFileDirectoryPath isDirectory:YES size:snapshotText.text.fontSize];
            paragraphStyle.lineSpacing = - (font.lineHeight - font.pointSize);
        }else{
            font = [UIFont systemFontOfSize:snapshotText.text.fontSize];
        }
        [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
        [attributes setObject:font forKey:NSFontAttributeName];
        //    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
        //    CGFontRef fontRef =CGFontCreateWithFontName(fontName);
        //    layerText.font = fontRef;
        //    layerText.fontSize = font.pointSize;
        //    CGFontRelease(fontRef);
        // 字体对方方式
        switch (snapshotText.text.horizontalAlignType) {
            case TextHorizontalAlignLeft:
                layerText.alignmentMode = kCAAlignmentLeft;
                break;
            case TextHorizontalAlignRight:
                layerText.alignmentMode = kCAAlignmentRight;
                break;
            case TextHorizontalAlignCenter:
                layerText.alignmentMode = kCAAlignmentCenter;
                break;
            default:
                break;
        }
        
        switch (snapshotText.text.verticalAlignType) {
            case TextVerticalAlignTop:
                //            [attributes setObject:@(-160) forKey:NSBaselineOffsetAttributeName];
                //            layerText.alignmentMode = kCAAlignmentLeft;
                break;
            case TextVerticalAlignCenter:
                //            layerText.alignmentMode = kCAAlignmentRight;
                break;
            case TextVerticalAlignBottom:
                //            layerText.alignmentMode = kCAAlignmentCenter;
                break;
            default:
                break;
        }
        NSAttributedString *attributeString = [[NSAttributedString alloc] initWithString:snapshotText.text.content attributes:attributes];
        layerText.string = attributeString;
        UIImage *textLayerImage = [self imageWithTextLayer:layerText size:CGSizeMake(width, height)];
        CGContextDrawImage(mainViewContentContext, CGRectMake( - width / 2,  - height / 2, width, height), textLayerImage.CGImage);
        
        CGContextRestoreGState(mainViewContentContext);
    }

    CGImageRef newImageRef = CGBitmapContextCreateImage(mainViewContentContext);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease(newImageRef);
    CGContextRelease(mainViewContentContext);
    return newImage;
}

-(UIImage *)imageWithTextLayer:(CATextLayer *)textLayer size:(CGSize)size
{
    CGColorSpaceRef colorSpace = [[UTImageHanderManager shareManager] currentColorSpaceRef];
    CGContextRef mainViewContentContext = CGBitmapContextCreate(NULL, size.width, size.height,8,0, colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGContextTranslateCTM(mainViewContentContext, 0, size.height);
    CGContextScaleCTM(mainViewContentContext, 1, -1);
    
    [textLayer renderInContext:mainViewContentContext];
    CGImageRef newImageRef = CGBitmapContextCreateImage(mainViewContentContext);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease(newImageRef);
    CGContextRelease(mainViewContentContext);
    return newImage;
}
@end
