//
//  UTPhotoEditView.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/5.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTPhotoEditView.h"
#import "Snapshot.h"
#import "SnapshotMedia.h"
#import "UTPictureImageLayerView.h"
#import "UTTplImageLayerView.h"
#import <Photos/Photos.h>

@implementation UTPhotoEditView
-(instancetype)initWithSnapshot:(Snapshot *)snapshot frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (snapshot.foregroundImage) {
            _templateImageView = [[UTTplImageLayerView alloc] init];
            UIImage *templateImage = [UIImage imageWithContentsOfFile:snapshot.foregroundImage];
            [_templateImageView setImage:templateImage];
            [self addSubview:_templateImageView];
            
            tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
            tapGesture.numberOfTapsRequired = 1;
            [self addGestureRecognizer:tapGesture];
        }
        [self makeConstraints];
    }
    return self;
}

-(void)makeConstraints
{
    if (_templateImageView) {
        [_templateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.leading.equalTo(self);
            make.trailing.equalTo(self);
            make.bottom.equalTo(self);
        }];
    }
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

-(void)drawRect:(CGRect)rect
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [path CGPath];
    maskLayer.fillRule = kCAFillRuleNonZero;
    self.layer.mask = maskLayer;
}
@end
