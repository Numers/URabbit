//
//  BlendAlgorithmFrontView.m
//  URabbit
//
//  Created by 鲍利成 on 2018/10/12.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "BlendAlgorithmFrontView.h"
#import "AxiosInfo.h"

@implementation BlendAlgorithmFrontView
-(instancetype)initWithFontImage:(UIImage *)image axiosInfo:(AxiosInfo *)axiosInfo
{
    self = [super initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    if (self) {
        fontImage = image;
        currentAxiosInfo = axiosInfo;
        [self createBlendView];
    }
    return self;
}

-(void)createBlendView
{
    _backGroundImageView = [[UIImageView alloc] initWithImage:currentAxiosInfo.image];
    [_backGroundImageView setFrame:CGRectMake(0, 0, currentAxiosInfo.imageWith, currentAxiosInfo.imageHeight)];
    _backGroundImageView.center = CGPointMake(currentAxiosInfo.centerX + currentAxiosInfo.offsetX, currentAxiosInfo.centerY + currentAxiosInfo.offsetY);
    [self addSubview:_backGroundImageView];
//    self.layer.contents = (id)currentAxiosInfo.image.CGImage;
    
    _fontImageView = [[UIImageView alloc] initWithImage:fontImage];
    [_fontImageView setFrame:CGRectMake(0, 0, fontImage.size.width, fontImage.size.height)];
    [self addSubview:_fontImageView];
}

-(void)releaseView
{
    [_backGroundImageView removeFromSuperview];
    _backGroundImageView = nil;
    [_fontImageView removeFromSuperview];
    _fontImageView = nil;
}
@end
