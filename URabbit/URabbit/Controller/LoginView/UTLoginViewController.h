//
//  UTLoginViewController.h
//  URabbit
//
//  Created by 鲍利成 on 2018/10/11.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UTLoginViewProtocol <NSObject>
-(void)loginsuccess;
@end
@interface UTLoginViewController : UIViewController
@property(nonatomic, weak) id<UTLoginViewProtocol> delegate;
-(void)addTextFieldNotification;
-(void)removeTextFieldNotification;
-(void)stopTimer;
@end
