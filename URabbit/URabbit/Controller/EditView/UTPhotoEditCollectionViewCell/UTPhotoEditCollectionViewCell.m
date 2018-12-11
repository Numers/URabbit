//
//  UTPhotoEditCollectionViewCell.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/6.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTPhotoEditCollectionViewCell.h"
#import "Snapshot.h"
#import "UTPhotoEditCanMoveView.h"
#import "UTPhotoEditNotMoveView.h"
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

-(void)setupCellWithSnapshot:(Snapshot *)snapshot style:(TemplateStyle)style
{
    if (editView) {
        [editView removeFromSuperview];
        editView = nil;
    }
    currentSnapshot = snapshot;
    CGFloat height = self.frame.size.height;
    CGFloat width = height * (snapshot.videoSize.width / snapshot.videoSize.height);
    currentStyle = style;
    if (style == TemplateStyleGoodNight) {
        editView = [[UTPhotoEditCanMoveView alloc] initWithSnapshot:snapshot frame:CGRectMake(0, 0, width, height)];
    }else if (style == TemplateStyleAnimation){
        editView = [[UTPhotoEditCanMoveView alloc] initWithSnapshot:snapshot frame:CGRectMake(0, 0, width, height)];
    }
    else if(style == TemplateStyleFriend){
        editView = [[UTPhotoEditNotMoveView alloc] initWithSnapshot:snapshot frame:CGRectMake(0, 0, width, height)];
    }
    
    
    editView.delegate = self;
    [self addSubview:editView];
    
    [editView setCenter:CGPointMake(self.frame.size.width / 2.0f, self.frame.size.height / 2.0f)];
}

-(void)dowithEditViewSnapshotMedia
{
    if ([editView isKindOfClass:[UTPhotoEditCanMoveView class]]) {
        UTPhotoEditCanMoveView *view = (UTPhotoEditCanMoveView *)editView;
        [view generateImageWithSize:currentSnapshot.videoSize style:currentStyle];
    }
    
    if ([editView isKindOfClass:[UTPhotoEditNotMoveView class]]) {
        UTPhotoEditNotMoveView *view = (UTPhotoEditNotMoveView *)editView;
        [view generateImageWithSize:currentSnapshot.videoSize style:currentStyle];
    }
}

-(UIImage *)tranferViewToImage
{
    UIImage *image = [AppUtils convertViewToImage:editView];
    return image;
}
#pragma -mark UTPhotoEditViewProtocol
-(void)openImagePickerViewWithScale:(CGFloat)scale
{
    if ([self.delegate respondsToSelector:@selector(openImagePickerViewFromView:scale:)]) {
        [self.delegate openImagePickerViewFromView:editView scale:scale];
    }
}
@end
