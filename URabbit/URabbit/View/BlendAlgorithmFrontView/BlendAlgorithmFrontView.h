//
//  BlendAlgorithmFrontView.h
//  URabbit
//
//  Created by 鲍利成 on 2018/10/12.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AxiosInfo;
@interface BlendAlgorithmFrontView : UIView
{
    UIImage *fontImage;
    AxiosInfo *currentAxiosInfo;
}
@property(nonatomic, strong) UIImageView *fontImageView;
@property(nonatomic, strong) UIImageView *backGroundImageView;

-(instancetype)initWithFontImage:(UIImage *)image axiosInfo:(AxiosInfo *)axiosInfo;
-(void)releaseView;
@end
