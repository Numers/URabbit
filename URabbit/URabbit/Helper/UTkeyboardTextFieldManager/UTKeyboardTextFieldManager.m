//
//  UTKeyboardTextFieldManager.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/21.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTKeyboardTextFieldManager.h"
#import "UTKeyboardTextField.h"
@interface UTKeyboardTextFieldManager()<UTKeyboardTextFieldProtocol>
{
    UTKeyboardTextField *keyboardTextField;
    KeyboardTextFieldCallback currentCallback;
}
@end
@implementation UTKeyboardTextFieldManager
+(instancetype)shareManager
{
    static UTKeyboardTextFieldManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[UTKeyboardTextFieldManager alloc] init];
    });
    return manager;
}

-(void)showKeyboardTextFieldWithText:(NSString *)text callback:(KeyboardTextFieldCallback)callback
{
    currentCallback = callback;
    if (keyboardTextField == nil) {
        keyboardTextField = [[UTKeyboardTextField alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 50)];
        keyboardTextField.delegate = self;
        [[UIApplication sharedApplication].keyWindow addSubview:keyboardTextField];
    }
    [keyboardTextField becomeFirstResponseWithText:text];
}

-(void)destroyKeyboardTextField
{
    if (keyboardTextField) {
        [keyboardTextField removeFromSuperview];
        keyboardTextField = nil;
    }
}

#pragma -mark UTKeyboardTextFieldProtocol
-(void)resignFirstResponseWithText:(NSString *)text
{
    [self destroyKeyboardTextField];
    if (currentCallback) {
        currentCallback(text);
    }
}
@end
