//
//  AxiosInfo.h
//  URabbit
//
//  Created by 鲍利成 on 2018/10/11.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum{
    AlgorithmMix = 1, //模板图片和上传图片像素混合
    AlgorithmTemplateFront = 2,//模板图片在上传图片上面
} AlgorithmType;

typedef enum{
    MaskAlgorithmMix = 1, //mask图片像素进行&操作
    MaskAlgorithmNone = 2, //mask图片不进行任何处理，仅当MaskVideo只有一个时
} MaskAlgorithmType;
@interface AxiosInfo : NSObject
@property(nonatomic) NSRange range;
@property(nonatomic) float centerX;  //用户图片相对于模板图片旋转的center
@property(nonatomic) float centerY;
@property(nonatomic) float offsetX;  //相对上面模板图片的centerX用户图像中心偏移
@property(nonatomic) float offsetY; //相对上面模板图片的centerY用户图像中心偏移
@property(nonatomic) float imageWith;
@property(nonatomic) float imageHeight;
@property(nonatomic) float rotateAngle;
@property(nonatomic, strong) UIImage *image;
@property(nonatomic) AlgorithmType algorithmType;
@property(nonatomic) MaskAlgorithmType maskAlgorithmType;
@end
