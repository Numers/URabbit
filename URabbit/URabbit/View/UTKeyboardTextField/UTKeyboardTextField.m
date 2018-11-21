//
//  UTKeyboardTextField.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/21.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTKeyboardTextField.h"

@implementation UTKeyboardTextField
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor blackColor]];
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width - 50, frame.size.height)];
        [_textField setTextColor:[UIColor whiteColor]];
        [self addSubview:_textField];
        
        _completeButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 50, 0, 50, frame.size.height)];
        [_completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_completeButton setTitle:@"完成" forState:UIControlStateNormal];
        [_completeButton addTarget:self action:@selector(clickComplete) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_completeButton];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

-(void)becomeFirstResponseWithText:(NSString *)text
{
    [_textField setText:text];
    [_textField becomeFirstResponder];
}

-(void)clickComplete
{
    if ([self.delegate respondsToSelector:@selector(resignFirstResponseWithText:)]) {
        [self.delegate resignFirstResponseWithText:_textField.text];
    }
    [_textField resignFirstResponder];
}

- (void)keyBoardWillShow:(NSNotification *) note {
    // 获取用户信息
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:note.userInfo];
    // 获取键盘高度
    CGRect keyBoardBounds  = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyBoardHeight = keyBoardBounds.size.height;
    // 获取键盘动画时间
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    // 定义好动作
    void (^animation)(void) = ^void(void) {
        self.transform = CGAffineTransformMakeTranslation(0, -keyBoardHeight - self.frame.size.height);
    };
    
    if (animationTime > 0) {
        [UIView animateWithDuration:animationTime animations:animation];
    } else {
        animation();
    }
    
}

- (void)keyBoardWillHide:(NSNotification *) note {
    // 获取用户信息
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:note.userInfo];
    // 获取键盘动画时间
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    // 定义好动作
    void (^animation)(void) = ^void(void) {
        self.transform = CGAffineTransformIdentity;
    };
    
    if (animationTime > 0) {
        [UIView animateWithDuration:animationTime animations:animation];
    } else {
        animation();
    }
}

-(void)removeFromSuperview
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super removeFromSuperview];
}
@end
