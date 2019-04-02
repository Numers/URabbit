//
//  URPhotoEditCanMoveView.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/21.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "URPhotoEditCanMoveView.h"
#import "Snapshot.h"
#import "SnapshotMedia.h"
#import "SnapshotText.h"
#import "Text.h"
#import "URTextLabel.h"
#import "URPictureImageLayerView.h"
#import "URTplImageLayerView.h"
#import <Photos/Photos.h>
#import "UIImage+FixImage.h"
#import "URImageHanderManager.h"
#import "URKeyboardTextFieldManager.h"
@interface URPhotoEditCanMoveView()<URPictureImageLayerViewProtocol,URTextLabelProtocol>
{
    Snapshot *currentSnapshot;
}
@end
@implementation URPhotoEditCanMoveView
-(instancetype)initWithSnapshot:(Snapshot *)snapshot frame:(CGRect)frame
{
    self = [super initWithSnapshot:snapshot frame:frame];
    if (self) {
        [self setUserInteractionEnabled:YES];
        currentSnapshot = snapshot;
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tapGesture.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGesture];
        
        panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [panGesture setMaximumNumberOfTouches:1];
        [self addGestureRecognizer:panGesture];
        
        pinGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinGesture:)];
        [self addGestureRecognizer:pinGesture];
        
        rotateGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotateGesture:)];
        [self addGestureRecognizer:rotateGesture];
        

        snapshotMedia = [snapshot.mediaList objectAtIndex:0];
        [self setPictureImage:snapshotMedia.demoImage];
        pictureImageView = snapshotMedia.demoImageView;
        pictureImageView.delegate = self;
        if (self.templateImageView) {
            [self insertSubview:snapshotMedia.demoImageView belowSubview:self.templateImageView];
        }else{
            [self addSubview:snapshotMedia.demoImageView];
        }
        
        for (SnapshotText *snapshotText in snapshot.textList) {
            CGFloat width = frame.size.width * snapshotText.widthPercent;
            CGFloat height = frame.size.height * snapshotText.heightPercent;
            CGPoint center = CGPointMake(frame.size.width * snapshotText.centerXPercent, frame.size.height * snapshotText.centerYPercent);
            [snapshotText.textLabel setFrame:CGRectMake(0, 0, width, height)];
            snapshotText.textLabel.delegate = self;
            CGFloat fontsize = snapshotText.text.fontSize * (frame.size.width / snapshot.videoSize.width);
            UIFont *font = nil;
            NSString *fontDirectory = [AppUtils createDirectory:@"UTFont"];
            NSString *fontFileDirectoryPath = [NSString stringWithFormat:@"%@/%@",fontDirectory,[AppUtils getMd5_32Bit:snapshotText.text.fontUrl]];
            if ([[NSFileManager defaultManager] fileExistsAtPath:fontFileDirectoryPath]) {
                font = [AppUtils customFontWithPath:fontFileDirectoryPath isDirectory:YES size:fontsize];
            }else{
                font = [UIFont systemFontOfSize:fontsize];
            }
            [snapshotText.textLabel setFont:font];
            [snapshotText.textLabel setCenter:center];
            if (height < 30) {
                [snapshotText.textLabel setVerticalAlignment:VerticalAlignmentDefault];
            }
            [self addSubview:snapshotText.textLabel];
        }
    }
    return self;
}

-(void)setPictureImage:(UIImage *)image
{
    CGFloat width = self.frame.size.width * snapshotMedia.imageWidthPercent;
    CGFloat height = width * image.size.height / image.size.width;
    [snapshotMedia.demoImageView setFrame:CGRectMake(0, 0, width, height)];
    _useImageSize = CGSizeMake(width, height);
    currentCenterPoint = CGPointMake(self.frame.size.width * snapshotMedia.centerXPercent, self.frame.size.height * snapshotMedia.centerYPercent);
    [snapshotMedia.demoImageView setCenter:currentCenterPoint];
    snapshotMedia.demoImage = image;
    [snapshotMedia.demoImageView setImage:image];
}

-(void)generateImageWithSize:(CGSize)size style:(TemplateStyle)style
{
    if (style == TemplateStyleGoodNight || style == TemplateStyleAnimation) {
        float scale = size.height / self.frame.size.height;
        float imageCenterX = currentCenterPoint.x * scale;
        float imageCenterY = currentCenterPoint.y * scale;
        CGSize imageSize = CGSizeMake(_useImageSize.width * scale, _useImageSize.height * scale);
        snapshotMedia.resultImage =  [self imageWithCenter:CGPointMake(imageCenterX, size.height - imageCenterY) image:[snapshotMedia.demoImage fixOrientation] imageSize:imageSize rotation:_useRotateAngle toSize:size];
    }
}

-(UIImage *)imageWithCenter:(CGPoint)center image:(UIImage *)image imageSize:(CGSize)imageSize rotation:(CGFloat)rotation toSize:(CGSize)size
{
    CGColorSpaceRef colorSpace = [[URImageHanderManager shareManager] currentColorSpaceRef];
    CGContextRef mainViewContentContext = CGBitmapContextCreate(NULL, size.width, size.height,8,0, colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    
    CGImageRef imageRef = image.CGImage;
    CGContextSaveGState(mainViewContentContext);
    CGContextTranslateCTM(mainViewContentContext, center.x, center.y);
    CGContextRotateCTM(mainViewContentContext, -rotation);
    CGContextDrawImage(mainViewContentContext, CGRectMake( - imageSize.width / 2,  - imageSize.height / 2, imageSize.width, imageSize.height), imageRef);
    CGContextRestoreGState(mainViewContentContext);
    
    CGImageRef newImageRef = CGBitmapContextCreateImage(mainViewContentContext);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    CGImageRelease(newImageRef);
    CGContextRelease(mainViewContentContext);
    return newImage;
}

-(void)handleTapGesture:(UITapGestureRecognizer *)gesture
{
    [self selectPictureWithMediaName:nil];
}

-(void)handlePanGesture:(UIPanGestureRecognizer *)gesture
{
    if([gesture state] == UIGestureRecognizerStateBegan) {
        lastCenterX = [pictureImageView center].x;
        lastCenterY = [pictureImageView center].y;
    }
    CGPoint transPoint = [gesture translationInView:self];
    currentCenterPoint = CGPointMake(lastCenterX+transPoint.x, lastCenterY+transPoint.y);
    
    [pictureImageView setCenter:currentCenterPoint];
}

-(void)handlePinGesture:(UIPinchGestureRecognizer *)pinGesture
{
    if([pinGesture state] == UIGestureRecognizerStateBegan) {
        lastScale = 1.0;
    }
    
    CGFloat scale = 1.0 - (lastScale - [pinGesture scale]);
    CGAffineTransform newTransform = CGAffineTransformScale(pictureImageView.transform, scale, scale);
    [pictureImageView setTransform:newTransform];
    
    lastScale = [pinGesture scale];
    _useImageSize = CGSizeMake(_useImageSize.width * scale, _useImageSize.height * scale);
}

-(void)handleRotateGesture:(UIRotationGestureRecognizer *)rotateGesture
{
    if([rotateGesture state] == UIGestureRecognizerStateEnded) {
        
        lastRotateAngle = 0.0;
        return;
    }
    
    CGFloat rotation = 0.0 - (lastRotateAngle - [rotateGesture rotation]);
    
    CGAffineTransform newTransform = CGAffineTransformRotate(pictureImageView.transform,rotation);
    [pictureImageView setTransform:newTransform];
    
    lastRotateAngle = [rotateGesture rotation];
    _useRotateAngle += rotation;
}

#pragma -mark URPictureImageLayerViewProtocol
-(void)selectPictureWithMediaName:(NSString *)mediaName
{
    CGFloat ratio = 1.0f;
    for (SnapshotMedia *media in currentSnapshot.mediaList){
        if ([media.mediaName isEqualToString:mediaName]) {
            CGFloat width = self.frame.size.width * media.imageWidthPercent;
            CGFloat height = self.frame.size.height * media.imageHeightPercent;
            ratio = height / width;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(openImagePickerViewWithScale:)]) {
        [self.delegate openImagePickerViewWithScale:ratio];
    }
}

#pragma -mark URTextLabelProtocol
-(void)didSelectTextLabelWithName:(NSString *)name content:(NSString *)content
{
    [[URKeyboardTextFieldManager shareManager] showKeyboardTextFieldWithText:content callback:^(NSString *text) {
        for(SnapshotText *snapshotText in currentSnapshot.textList){
            if ([snapshotText.textName isEqualToString:name]) {
                [snapshotText changeText:text];
            }
        }
    }];
}
@end
