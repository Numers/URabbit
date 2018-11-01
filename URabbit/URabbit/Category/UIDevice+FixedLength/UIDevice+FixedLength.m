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

@implementation UIDevice (FixedLength)
+(CGFloat)adaptLengthWithIphone6Length:(CGFloat)length
{
    CGFloat tempLength = length;
    if(IS_IPHONE_4){
        tempLength = length *(480.0 / 667.0);
    }else if (IS_IPHONE_5){
        tempLength = length * (568.0 / 667.0);
    }else if (IS_IPHONE_6_OR_Iphone7){
        tempLength = length;
    }else if (IS_IPHONE_6P_OR_Iphone7P){
        tempLength = length * (736.0 / 667.0);
    }
    return tempLength;
}

+(CGFloat)adaptWidthWithIphone6Width:(CGFloat)width
{
    CGFloat tempLength = width;
    if(IS_IPHONE_4){
        tempLength = width *(320.0 / 375.0);
    }else if (IS_IPHONE_5){
        tempLength = width * (320.0 / 375.0);
    }else if (IS_IPHONE_6_OR_Iphone7){
        tempLength = width;
    }else if (IS_IPHONE_6P_OR_Iphone7P){
        tempLength = width * (414.0 / 375.0);
    }
    return tempLength;
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
    }
    return size;
}
@end
