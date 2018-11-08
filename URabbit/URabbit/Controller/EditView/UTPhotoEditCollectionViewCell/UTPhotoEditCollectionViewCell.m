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
        return;
    }
    editInfo = info;
    editView = [[UTPhotoEditView alloc] initWithTemplateImage:info.editImage];
    editView.delegate = self;
    CGFloat height = self.frame.size.height;
    CGFloat width = height * (info.editImage.size.width / info.editImage.size.height);
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
    [editInfo setEditImage:image];
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
    
    float offsetX = imageCenterX - templateCenterX;
    float offsetY = -(imageCenterY - templateCenterY);
    
    info.centerX = templateCenterX;
    info.centerY = editInfo.originSize.height *  (1 - editInfo.editImageCenterYPercent);
    info.offsetX = offsetX;
    info.offsetY = offsetY;
    info.range = editInfo.range;
    info.rotateAngle = editView.useRotateAngle;
    info.imageWith = editView.useImageSize.width * scale;
    info.imageHeight = editView.useImageSize.height * scale;
    info.image = [editView.pictureImage fixOrientation];
    return info;
}
#pragma -mark UTPhotoEditViewProtocol
-(void)openImagePickerView
{
    if ([self.delegate respondsToSelector:@selector(openImagePickerViewFromView:)]) {
        [self.delegate openImagePickerViewFromView:editView];
    }
}
@end
