//
//  UTKeyboardTextField.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/21.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol URKeyboardTextFieldProtocol<NSObject>
-(void)resignFirstResponseWithText:(NSString *)text;
@end
@interface URKeyboardTextField : UIView
@property(nonatomic, strong) UITextView *textField;
@property(nonatomic, weak) id<URKeyboardTextFieldProtocol> delegate;
@property(nonatomic, strong) UIButton *completeButton;

-(void)becomeFirstResponseWithText:(NSString *)text;
@end
