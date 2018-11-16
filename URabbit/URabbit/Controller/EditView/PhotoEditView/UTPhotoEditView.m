//
//  UTPhotoEditView.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/5.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTPhotoEditView.h"
#import "UTPictureImageView.h"
#import "UTTplImageLayerView.h"
#import <Photos/Photos.h>

@implementation UTPhotoEditView
-(instancetype)initWithTemplateImage:(UIImage *)templateImage
{
    self = [super init];
    if (self) {
        [self setUserInteractionEnabled:YES];
        panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [panGesture setMaximumNumberOfTouches:1];
        [self addGestureRecognizer:panGesture];
        
        pinGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinGesture:)];
        [self addGestureRecognizer:pinGesture];
        
        rotateGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotateGesture:)];
        [self addGestureRecognizer:rotateGesture];
        
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tapGesture.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGesture];
        
        if (templateImage) {
            templateImageView = [[UTTplImageLayerView alloc] init];
            [templateImageView setImage:templateImage];
            [self addSubview:templateImageView];
        }
        [self makeConstraints];
    }
    return self;
}

-(void)makeConstraints
{
    if (templateImageView) {
        [templateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.leading.equalTo(self);
            make.trailing.equalTo(self);
            make.bottom.equalTo(self);
        }];
    }
}

-(CGPoint)returnCurrentPictureCenter
{
    return currentCenterPoint;
}

-(void)setPictureImage:(UIImage *)image
{
    if (pictureImageView) {
        [pictureImageView removeFromSuperview];
        pictureImageView = nil;
    }
    _pictureImage = image;
    pictureImageView = [[UTPictureImageView alloc] initWithImage:image];
    _useImageSize = [self sizeFitWithSize:image.size inRect:_boundRect];
    [pictureImageView setFrame:CGRectMake(0, 0, _useImageSize.width, _useImageSize.height)];
    if (templateImageView) {
        [self insertSubview:pictureImageView belowSubview:templateImageView];
    }else{
        [self addSubview:pictureImageView];
    }
    
    [pictureImageView setCenter:_tplCenterPoint];
    currentCenterPoint = _tplCenterPoint;
    _useRotateAngle = 0;
}

-(CGSize)sizeFitWithSize:(CGSize)size inRect:(CGRect)rect
{
    CGFloat width = size.width;
    CGFloat height = size.height;
    if (width > rect.size.width) {
        width = rect.size.width;
        height = width * (size.height / size.width);
    }
    
    if (height > rect.size.height) {
        height = rect.size.height;
        width = height * (size.width / size.height);
    }
    return CGSizeMake(width, height);
}

-(void)handleTapGesture:(UITapGestureRecognizer *)gesture
{
    PHAuthorizationStatus authStatusAlbm  = [PHPhotoLibrary authorizationStatus];
    if (authStatusAlbm == PHAuthorizationStatusAuthorized || authStatusAlbm == PHAuthorizationStatusNotDetermined) {
        if ([self.delegate respondsToSelector:@selector(openImagePickerView)]) {
            [self.delegate openImagePickerView];
        }
    }
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

-(void)drawRect:(CGRect)rect
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [path CGPath];
    maskLayer.fillRule = kCAFillRuleNonZero;
    self.layer.mask = maskLayer;
}
@end
