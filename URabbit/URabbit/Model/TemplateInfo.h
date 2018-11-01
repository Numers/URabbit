//
//  TemplateInfo.h
//  URabbit
//
//  Created by 鲍利成 on 2018/10/11.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TemplateInfo : NSObject
@property(nonatomic, strong) NSString *templateImage;
@property(nonatomic, strong) NSString *userImage;
@property(nonatomic) float centerX; //推荐在模板图片上放置的中心点
@property(nonatomic) float centerY;
@property(nonatomic) float offsetX;  //相对上面模板图片的centerX用户图像中心偏移
@property(nonatomic) float offsetY; //相对上面模板图片的centerY用户图像中心偏移
@property(nonatomic) BOOL canMove;
@end
