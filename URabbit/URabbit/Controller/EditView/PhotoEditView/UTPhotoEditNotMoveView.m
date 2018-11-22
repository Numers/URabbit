//
//  UTPhotoEditNotMoveView.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/21.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTPhotoEditNotMoveView.h"
#import "Snapshot.h"
#import "SnapshotMedia.h"
#import "SnapshotText.h"
#import "UTTextLabel.h"
#import "Text.h"
#import "UTPictureImageLayerView.h"
#import "UTTplImageLayerView.h"
#import "UTImageHanderManager.h"

#import "UTKeyboardTextFieldManager.h"
@interface UTPhotoEditNotMoveView()<UTTextLabelProtocol,UTPictureImageLayerViewProtocol>
{
    Snapshot *currentSnapshot;
    NSString *selectMediaName;
}
@end
@implementation UTPhotoEditNotMoveView
-(instancetype)initWithSnapshot:(Snapshot *)snapshot frame:(CGRect)frame
{
    self = [super initWithSnapshot:snapshot frame:frame];
    if (self) {
        [self setUserInteractionEnabled:YES];
        currentSnapshot = snapshot;
        for (SnapshotMedia *media in snapshot.mediaList) {
            CGFloat width = frame.size.width * media.imageWidthPercent;
            CGFloat height = frame.size.height * media.imageHeightPercent;
            [media.demoImageView setFrame:CGRectMake(0, 0, width, height)];
            media.demoImageView.delegate = self;
            CGPoint currentCenterPoint = CGPointMake(frame.size.width * media.centerXPercent, frame.size.height * media.centerYPercent);
            [media.demoImageView setImage:media.demoImage];
            [media.demoImageView setCenter:currentCenterPoint];
            if (self.templateImageView) {
                [self insertSubview:media.demoImageView belowSubview:self.templateImageView];
            }else{
                [self addSubview:media.demoImageView];
            }
            
        }
        
        for(SnapshotText *snapshotText in snapshot.textList){
            CGFloat width = frame.size.width * snapshotText.widthPercent;
            CGFloat height = frame.size.height * snapshotText.heightPercent;
            CGPoint center = CGPointMake(frame.size.width * snapshotText.centerXPercent, frame.size.height * snapshotText.centerYPercent);
            [snapshotText.textLabel setFrame:CGRectMake(0, 0, width, height)];
            snapshotText.textLabel.delegate = self;
            CGFloat fontsize = snapshotText.text.fontSize * (frame.size.width / snapshot.videoSize.width);
            [snapshotText.textLabel setFont:[UIFont systemFontOfSize:fontsize]];
            [snapshotText.textLabel setCenter:center];
            if (height < 30) {
                [snapshotText.textLabel setVerticalAlignment:VerticalAlignmentDefault];
            }
            if (self.templateImageView) {
                [self insertSubview:snapshotText.textLabel aboveSubview:self.templateImageView];
            }else{
                [self addSubview:snapshotText.textLabel];
            }
        }
    }
    return self;
}

-(void)setPictureImage:(UIImage *)image
{
    for (SnapshotMedia *media in currentSnapshot.mediaList){
        CGFloat width = self.frame.size.width * media.imageWidthPercent;
        CGFloat height = self.frame.size.height * media.imageHeightPercent;
        UIImage *cropImage = [AppUtils cropImage:image ratio:width/height];
        if ([media.mediaName isEqualToString:selectMediaName]) {
            [media changePicture:cropImage];
        }
    }
}

-(void)generateImageWithSize:(CGSize)size style:(TemplateStyle)style
{
    if (style == TemplateStyleFriend) {
        CGColorSpaceRef colorSpace = [[UTImageHanderManager shareManager] currentColorSpaceRef];
        CGContextRef mainViewContentContext = CGBitmapContextCreate(NULL, size.width, size.height,8,0, colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
        
        for (SnapshotMedia *media in currentSnapshot.mediaList) {
            CGFloat width = size.width * media.imageWidthPercent;
            CGFloat height = size.height * media.imageHeightPercent;
            CGPoint currentCenterPoint = CGPointMake(size.width * media.centerXPercent, size.height * media.centerYPercent);
            CGContextSaveGState(mainViewContentContext);
            CGContextTranslateCTM(mainViewContentContext, currentCenterPoint.x, size.height - currentCenterPoint.y);
            CGContextDrawImage(mainViewContentContext, CGRectMake( - width / 2,  - height / 2, width, height), media.demoImage.CGImage);
            CGContextRestoreGState(mainViewContentContext);
        }
        
        for(SnapshotText *snapshotText in currentSnapshot.textList){
            CGFloat width = size.width * snapshotText.widthPercent;
            CGFloat height = size.height * snapshotText.heightPercent;
            CGPoint currentCenterPoint = CGPointMake(size.width * snapshotText.centerXPercent, size.height * snapshotText.centerYPercent);
            CGContextSaveGState(mainViewContentContext);
            CGContextTranslateCTM(mainViewContentContext, currentCenterPoint.x, size.height - currentCenterPoint.y);
            CATextLayer *layerText = [CATextLayer layer];
            layerText.backgroundColor = [UIColor clearColor].CGColor;
            layerText.contentsScale = [UIScreen mainScreen].scale;
            layerText.bounds = CGRectMake(0, 0, width, height);
            [layerText setForegroundColor:[UIColor colorFromHexString:snapshotText.text.fontColor].CGColor];
            // 字体名称、大小
            UIFont *font = [UIFont systemFontOfSize:snapshotText.text.fontSize];
            CFStringRef fontName = (__bridge CFStringRef)font.fontName;
            CGFontRef fontRef =CGFontCreateWithFontName(fontName);
            layerText.font = fontRef;
            layerText.fontSize = font.pointSize;
            CGFontRelease(fontRef);
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
            layerText.string = snapshotText.text.content;
            UIImage *textLayerImage = [self imageWithTextLayer:layerText size:CGSizeMake(width, height)];
            CGContextDrawImage(mainViewContentContext, CGRectMake( - width / 2,  - height / 2, width, height), textLayerImage.CGImage);
            CGContextRestoreGState(mainViewContentContext);
        }
        
        CGImageRef newImageRef = CGBitmapContextCreateImage(mainViewContentContext);
        UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
        currentSnapshot.snapshotImage = newImage;
        CGImageRelease(newImageRef);
        CGContextRelease(mainViewContentContext);
    }
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
    currentSnapshot.snapshotImage = newImage;
    CGImageRelease(newImageRef);
    CGContextRelease(mainViewContentContext);
    return newImage;
}
#pragma -mark UTTextLabelProtocol
-(void)didSelectTextLabelWithName:(NSString *)name content:(NSString *)content
{
    [[UTKeyboardTextFieldManager shareManager] showKeyboardTextFieldWithText:content callback:^(NSString *text) {
        for(SnapshotText *snapshotText in currentSnapshot.textList){
            if ([snapshotText.textName isEqualToString:name]) {
                [snapshotText changeText:text];
            }
        }
    }];
}

#pragma -mark UTPictureImageLayerViewProtocol
-(void)selectPictureWithMediaName:(NSString *)mediaName
{
    selectMediaName = mediaName;
    if ([self.delegate respondsToSelector:@selector(openImagePickerView)]) {
        [self.delegate openImagePickerView];
    }
}
@end
