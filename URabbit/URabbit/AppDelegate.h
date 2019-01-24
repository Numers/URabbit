//
//  AppDelegate.h
//  URabbit
//
//  Created by 鲍利成 on 2018/10/11.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic, copy) NSString *regId;
@property(nonatomic, copy) NSString *deviceToken; //设备唯一标示
@property(nonatomic) BOOL needShowUpdateAlert;

@end

