//
//  URKeyboardTextFieldManager.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/21.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "URKeyboardTextFieldManager.h"
#import "URKeyboardTextField.h"
@interface URKeyboardTextFieldManager()<URKeyboardTextFieldProtocol>
{
    URKeyboardTextField *keyboardTextField;
    KeyboardTextFieldCallback currentCallback;
}
@end
@implementation URKeyboardTextFieldManager
+(instancetype)shareManager
{
    static URKeyboardTextFieldManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[URKeyboardTextFieldManager alloc] init];
    });
    return manager;
}

-(void)showKeyboardTextFieldWithText:(NSString *)text callback:(KeyboardTextFieldCallback)callback
{
    currentCallback = callback;
    if (keyboardTextField == nil) {
        keyboardTextField = [[URKeyboardTextField alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 50)];
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
