//
//  UTPhotoEditCollectionViewCell.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/6.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTPhotoEditCollectionViewCell.h"
#import "EditInfo.h"
#import "AxiosInfo.h"
#import "UTPhotoEditView.h"
#import "UIImage+FixImage.h"
#import "UTImageHanderManager.h"
@interface UTPhotoEditCollectionViewCell()<UTPhotoEditViewProtocol>

@end
@implementation UTPhotoEditCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUserInteractionEnabled:YES];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

-(void)setupCellWithEditInfo:(EditInfo *)info
{
    if (editView) {
        [editView removeFromSuperview];
        editView = nil;
    }
    editInfo = info;
    editView = [[UTPhotoEditView alloc] initWithTemplateImage:[UIImage imageNamed:info.editImage]];
    editView.delegate = self;
    CGFloat height = self.frame.size.height;
    CGFloat width = height * (info.originSize.width / info.originSize.height);
    CGRect rect = CGRectMake(0, 0, width, height);
    [editView setFrame:rect];
    [editView setBoundRect:rect];
    CGPoint center = CGPointMake(width * info.editImageCenterXPercent, height * info.editImageCenterYPercent);
    [editView setTplCenterPoint:center];
    [self addSubview:editView];
    
    [editView setCenter:CGPointMake(self.frame.size.width / 2.0f, self.frame.size.height / 2.0f)];
}

-(UIImage *)tranferViewToImage
{
    UIImage *image = [AppUtils convertViewToImage:editView];
    [editInfo setEditScreenShotImage:image];
    return image;
}

-(AxiosInfo *)generateAxiosInfo
{
    AxiosInfo * info = [[AxiosInfo alloc] init];
    float scale = editInfo.originSize.height / editView.frame.size.height;
    float imageCenterX = [editView returnCurrentPictureCenter].x * scale;
    float imageCenterY = [editView returnCurrentPictureCenter].y * scale;
    
    float templateCenterX = editInfo.originSize.width * editInfo.editImageCenterXPercent;
    float templateCenterY = editInfo.originSize.height *  editInfo.editImageCenterYPercent;
    
    info.centerX = templateCenterX;
    info.centerY = editInfo.originSize.height *  (1 - editInfo.editImageCenterYPercent);
    info.range = editInfo.range;
    [info.animationObjects addObjectsFromArray:editInfo.animationObjects];
    info.filterType = editInfo.filterType;
    info.rotateAngle = editView.useRotateAngle;
    CGFloat imageWith = editView.useImageSize.width * scale;
    CGFloat imageHeight = editView.useImageSize.height * scale;
    info.imageWith = editInfo.originSize.width;
    info.imageHeight = editInfo.originSize.height;
    UIImage *image = [self imageWithCenter:CGPointMake(imageCenterX, editInfo.originSize.height - imageCenterY) image:[editView.pictureImage fixOrientation] imageSize:CGSizeMake(imageWith, imageHeight) rotation:info.rotateAngle toSize:editInfo.originSize];
    info.image = image;
    return info;
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
#pragma -mark UTPhotoEditViewProtocol
-(void)openImagePickerView
{
    if ([self.delegate respondsToSelector:@selector(openImagePickerViewFromView:)]) {
        [self.delegate openImagePickerViewFromView:editView];
    }
}
@end
