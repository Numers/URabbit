//
//  URShareViewController.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/25.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UTShareViewProtocol <NSObject>
@optional
-(void)sendShareToWeixin;
-(void)sendShareToFriend;
-(void)sendShareToQQ;
-(void)sendShareToWeibo;
@end
@interface URShareViewController : UIViewController
@property(nonatomic, weak) id<UTShareViewProtocol> delegate;
@property(nonatomic, strong) IBOutlet UIButton *weixinButton;
@property(nonatomic, strong) IBOutlet UIButton *friendButton;
@property(nonatomic, strong) IBOutlet UIButton *qqButton;
@property(nonatomic, strong) IBOutlet UIButton *weiboButton;
@property(nonatomic, strong) IBOutlet UIButton *cancelButton;
@end
