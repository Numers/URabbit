//
//  FilterInfo.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/8.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum
{
    FilterNormal = 0, //无
    FilterToon, //卡通
    FilterBulgeDistortion,//凸起
    FilterSketch,//素描
    FilterGamma, //伽马线
    FilterToneCurve, //色调曲线
    FilterSepia, //怀旧
    FilterGrayscale, //灰度
    FilterHistogram //色彩直方图
} FilterType;
@interface FilterInfo : NSObject
@property(nonatomic, copy) NSString *filterName;
@property(nonatomic, copy) NSString *filterImage;
@property(nonatomic) FilterType type;
@end
