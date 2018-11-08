//
//  UTPhotoEditView.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/5.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UTPictureImageView,UTTplImageLayerView;
@protocol UTPhotoEditViewProtocol <NSObject>
-(void)openImagePickerView;
@end
@interface UTPhotoEditView : UIView
{
    UTPictureImageView *pictureImageView;
    UTTplImageLayerView *templateImageView;
    
    UIPanGestureRecognizer *panGesture;
    UIPinchGestureRecognizer *pinGesture;
    UIRotationGestureRecognizer *rotateGesture;
    UITapGestureRecognizer *tapGesture;
    
    CGFloat lastRotateAngle;
    CGFloat lastScale;
    CGFloat lastCenterX;
    CGFloat lastCenterY;
    CGPoint currentCenterPoint;
}
@property(nonatomic, weak) id<UTPhotoEditViewProtocol> delegate;
@property(nonatomic, strong) UIImage *pictureImage;
@property(nonatomic) CGPoint tplCenterPoint;
@property(nonatomic) CGRect boundRect;
@property(nonatomic) CGSize useImageSize;
@property(nonatomic) CGFloat useRotateAngle;
-(instancetype)initWithTemplateImage:(UIImage *)templateImage;
-(void)setPictureImage:(UIImage *)image;
-(CGPoint)returnCurrentPictureCenter;
@end
