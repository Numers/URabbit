//
//  URMemberViewController.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/23.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Member,VIPPrice;
@protocol MemberViewProtocol <NSObject>
-(void)returnContentSizeHeight:(CGFloat)height;
-(void)presentLoginView;
@end
@interface URMemberViewController : UIViewController
@property(nonatomic, weak) id<MemberViewProtocol> delegate;
-(CGFloat)returnMemberContentHeight;
-(VIPPrice *)selectedVipPrice;
-(void)setCurrentMember:(Member *)member;
@end
