//
//  UTKeyboardTextFieldManager.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/21.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^KeyboardTextFieldCallback) (NSString *text);
@interface UTKeyboardTextFieldManager : NSObject
+(instancetype)shareManager;
-(void)showKeyboardTextFieldWithText:(NSString *)text callback:(KeyboardTextFieldCallback)callback;
-(void)destroyKeyboardTextField;
@end
