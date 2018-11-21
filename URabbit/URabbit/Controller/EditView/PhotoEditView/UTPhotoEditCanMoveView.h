//
//  UTPhotoEditCanMoveView.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/21.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTPhotoEditView.h"
@class SnapshotMedia;
@interface UTPhotoEditCanMoveView : UTPhotoEditView
{
    SnapshotMedia *snapshotMedia;
    UITapGestureRecognizer *tapGesture;
    UTPictureImageLayerView *pictureImageView;
    UIPanGestureRecognizer *panGesture;
    UIPinchGestureRecognizer *pinGesture;
    UIRotationGestureRecognizer *rotateGesture;
    
    CGFloat lastRotateAngle;
    CGFloat lastScale;
    CGFloat lastCenterX;
    CGFloat lastCenterY;
    CGPoint currentCenterPoint;
}
@property(nonatomic) CGSize useImageSize;
@property(nonatomic) CGFloat useRotateAngle;
-(void)setPictureImage:(UIImage *)image;
-(void)generateImageWithSize:(CGSize)size;
@end
