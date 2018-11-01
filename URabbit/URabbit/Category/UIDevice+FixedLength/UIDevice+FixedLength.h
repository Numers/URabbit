//
//  UIDevice+FixedLength.h
//  UniversalProduct
//
//  Created by 鲍利成 on 2017/7/18.
//  Copyright © 2017年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (FixedLength)
+(CGFloat)adaptLengthWithIphone6Length:(CGFloat)length;
+(CGFloat)adaptWidthWithIphone6Width:(CGFloat)width;
+(CGFloat)adaptFontSizeWithIphone6FontSize:(CGFloat)fontSize needFixed:(BOOL)needFixed;
@end
