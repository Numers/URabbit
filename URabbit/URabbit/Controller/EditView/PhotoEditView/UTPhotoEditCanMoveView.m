//
//  UTPhotoEditCanMoveView.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/21.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTPhotoEditCanMoveView.h"
#import "Snapshot.h"
#import "SnapshotMedia.h"
#import "UTPictureImageLayerView.h"
#import "UTTplImageLayerView.h"
#import <Photos/Photos.h>
#import "UIImage+FixImage.h"
#import "UTImageHanderManager.h"
@interface UTPhotoEditCanMoveView()<UTPictureImageLayerViewProtocol>
@end
@implementation UTPhotoEditCanMoveView
-(instancetype)initWithSnapshot:(Snapshot *)snapshot frame:(CGRect)frame
{
    self = [super initWithSnapshot:snapshot frame:frame];
    if (self) {
        [self setUserInteractionEnabled:YES];
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

-(void)generateImageWithSize:(CGSize)size
{
    float scale = size.height / self.frame.size.height;
    float imageCenterX = currentCenterPoint.x * scale;
    float imageCenterY = currentCenterPoint.y * scale;
    CGSize imageSize = CGSizeMake(_useImageSize.width * scale, _useImageSize.height * scale);
    snapshotMedia.resultImage =  [self imageWithCenter:CGPointMake(imageCenterX, size.height - imageCenterY) image:[snapshotMedia.demoImage fixOrientation] imageSize:imageSize rotation:_useRotateAngle toSize:size];
}

-(UIImage *)imageWithCenter:(CGPoint)center image:(UIImage *)image imageSize:(CGSize)imageSize rotation:(CGFloat)rotation toSize:(CGSize)size
{
    CGColorSpaceRef colorSpace = [[UTImageHanderManager shareManager] currentColorSpaceRef];
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

#pragma -mark UTPictureImageLayerViewProtocol
-(void)selectPictureWithMediaName:(NSString *)mediaName
{
    PHAuthorizationStatus authStatusAlbm  = [PHPhotoLibrary authorizationStatus];
    if (authStatusAlbm == PHAuthorizationStatusAuthorized || authStatusAlbm == PHAuthorizationStatusNotDetermined) {
        if ([self.delegate respondsToSelector:@selector(openImagePickerView)]) {
            [self.delegate openImagePickerView];
        }
    }
}
@end
