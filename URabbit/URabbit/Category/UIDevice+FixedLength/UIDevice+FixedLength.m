//
//  UIDevice+FixedLength.m
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/7/18.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import "UIDevice+FixedLength.h"
#import "AppStartManager.h"
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 480.0)
#define IS_IPHONE_4 (IS_IPHONE && SCREEN_MAX_LENGTH == 480.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6_OR_Iphone7 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P_OR_Iphone7P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)


#define IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

/**
 *导航栏高度
 */
#define SafeAreaTopHeight (IPHONE_X ? 88 : 64)

/**
 *tabbar高度
 */
#define SafeAreaBottomHeight (IPHONE_X ? (49 + 34) : 49)


@implementation UIDevice (FixedLength)
+(CGFloat)adaptHeightWithIphone6Length:(CGFloat)height
{
    CGFloat tempLength = height * (SCREEN_HEIGHT / 667.0f);
    return tempLength;
}

+(CGFloat)adaptWidthWithIphone6Width:(CGFloat)width
{
    CGFloat tempLength = width * (SCREEN_WIDTH / 375.0f);
    return tempLength;
}

+(CGFloat)safeAreaTopHeight
{
    return SafeAreaTopHeight;
}

+(CGFloat)safeAreaBottomHeight
{
    return SafeAreaBottomHeight;
}

+(CGFloat)adaptFontSizeWithIphone6FontSize:(CGFloat)fontSize needFixed:(BOOL)needFixed
{
    CGFloat size = fontSize;
    if(IS_IPHONE_4){
        
    }else if (IS_IPHONE_5){
        
    }else if (IS_IPHONE_6_OR_Iphone7){
        
    }else if (IS_IPHONE_6P_OR_Iphone7P){
        if (needFixed) {
            size = fontSize + 2;
        }else{
            size = fontSize;
        }
    }else if (IPHONE_X){
        if (needFixed) {
            size = fontSize + 2;
        }else{
            size = fontSize;
        }
    }
    return size;
}
@end
