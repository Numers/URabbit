//
//  URPhotoEditCollectionViewCell.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/6.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "URPhotoEditCollectionViewCell.h"
#import "Snapshot.h"
#import "URPhotoEditCanMoveView.h"
#import "URPhotoEditNotMoveView.h"
#import "UIImage+FixImage.h"
#import "URImageHanderManager.h"
@interface URPhotoEditCollectionViewCell()<URPhotoEditViewProtocol>

@end
@implementation URPhotoEditCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUserInteractionEnabled:YES];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

-(void)setupCellWithSnapshot:(Snapshot *)snapshot style:(TemplateStyle)style
{
    if (editView) {
        [editView removeFromSuperview];
        editView = nil;
    }
    currentSnapshot = snapshot;
    CGFloat height = self.frame.size.height;
    CGFloat width = height * (snapshot.videoSize.width / snapshot.videoSize.height);
    if (width > self.frame.size.width) {
        width = self.frame.size.width;
        height = width * (snapshot.videoSize.height / snapshot.videoSize.width);
    }
    currentStyle = style;
    if (style == TemplateStyleGoodNight) {
        editView = [[URPhotoEditCanMoveView alloc] initWithSnapshot:snapshot frame:CGRectMake(0, 0, width, height)];
    }else if (style == TemplateStyleAnimation){
        editView = [[URPhotoEditCanMoveView alloc] initWithSnapshot:snapshot frame:CGRectMake(0, 0, width, height)];
    }
    else if(style == TemplateStyleFriend){
        editView = [[URPhotoEditNotMoveView alloc] initWithSnapshot:snapshot frame:CGRectMake(0, 0, width, height)];
    }
    
    
    editView.delegate = self;
    [self addSubview:editView];
    
    [editView setCenter:CGPointMake(self.frame.size.width / 2.0f, self.frame.size.height / 2.0f)];
}

-(void)dowithEditViewSnapshotMedia
{
    if ([editView isKindOfClass:[URPhotoEditCanMoveView class]]) {
        URPhotoEditCanMoveView *view = (URPhotoEditCanMoveView *)editView;
        [view generateImageWithSize:currentSnapshot.videoSize style:currentStyle];
    }
    
    if ([editView isKindOfClass:[URPhotoEditNotMoveView class]]) {
        URPhotoEditNotMoveView *view = (URPhotoEditNotMoveView *)editView;
        [view generateImageWithSize:currentSnapshot.videoSize style:currentStyle];
    }
}

-(UIImage *)tranferViewToImage
{
    UIImage *image = [AppUtils convertViewToImage:editView];
    return image;
}
#pragma -mark URPhotoEditViewProtocol
-(void)openImagePickerViewWithScale:(CGFloat)scale
{
    if ([self.delegate respondsToSelector:@selector(openImagePickerViewFromView:scale:)]) {
        [self.delegate openImagePickerViewFromView:editView scale:scale];
    }
}
@end
