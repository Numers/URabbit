//
//  GlobalVar.h
//  GLPFinance
//
//  Created by 鲍利成 on 16/10/28.
//  Copyright © 2016年 鲍利成. All rights reserved.
//

#ifndef GlobalVar_h
#define GlobalVar_h
#define GDeviceWidth [UIScreen mainScreen].bounds.size.width
#define GDeviceHeight [UIScreen mainScreen].bounds.size.height

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
typedef enum
{
    TemplateStyleGoodNight = 1,
    TemplateStyleFriend,
    TemplateStyleAnimation,
    TemplateStyleFace
}TemplateStyle;

typedef enum
{
    MediaTypeImage = 1,
    MediaTypeVideo,
    MediaTypeBoth
} MediaType;

typedef enum{
    TextHorizontalAlignLeft = 1,
    TextHorizontalAlignCenter,
    TextHorizontalAlignRight
} TextHorizontalAlignType;

typedef enum{
    TextVerticalAlignTop = 1,
    TextVerticalAlignCenter,
    TextVerticalAlignBottom
} TextVerticalAlignType;

typedef enum
{
    AnimationNone = 0,
    AnimationRotation = 1,
    AnimationScale = 2,
    AnimationTransform = 4,
    AnimationBlur = 8
}AnimationType;

typedef enum{
    SwitchAnimationNone = 0,
    SwitchAnimationRightIn = 1001,
    SwitchAnimationRightOut = 2,
    SwitchAnimationLeftIn = 1002,
    SwitchAnimationLeftOut = 1,
    SwitchAnimationBottomIn = 1003,
    SwitchAnimationBottomOut = 4,
    SwitchAnimationTopIn = 1004,
    SwitchAnimationTopOut = 3,
    SwitchAnimationOpacityIn = 1009,
    SwitchAnimationOpacityOut = 9
    
} SwitchAnimationType;
typedef enum
{
    //图片渲染
    FilterNormal = 0, //无
    FilterToon, //卡通
    FilterBulgeDistortion,//凸起
    FilterSketch,//素描
    FilterGamma, //伽马线
    FilterToneCurve, //色调曲线
    FilterSepia, //怀旧
    FilterGrayscale, //灰度
    FilterHistogram, //色彩直方图
    
    //像素处理
    FilterAddBlend, //图片混合
} FilterType;

#define ViewBackgroundColor [UIColor whiteColor]

#define ThemeHexColor @"#FFFFFF"

#define IconfontGoBackDefaultSize 18

#define CompositionTableName @"Compositon"
#define LoadedTableName @"LoadedTemplate"

#define NOUSERMemberID @"NOUSER"

#define UnitDivisor 1000

#define Version_Code 0
#endif /* GlobalVar_h */
