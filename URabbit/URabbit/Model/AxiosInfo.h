//
//  AxiosInfo.h
//  URabbit
//
//  Created by 鲍利成 on 2018/10/11.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface AxiosInfo : NSObject
@property(nonatomic) NSRange range;
@property(nonatomic) float centerX;  //用户图片相对于模板图片旋转的center
@property(nonatomic) float centerY;
@property(nonatomic) float imageWith;
@property(nonatomic) float imageHeight;
@property(nonatomic) NSMutableArray *animationObjects; //转场动画
@property(nonatomic) float rotateAngle;
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, strong) UIImage *filterImage;
@property(nonatomic) FilterType filterType;
@end
