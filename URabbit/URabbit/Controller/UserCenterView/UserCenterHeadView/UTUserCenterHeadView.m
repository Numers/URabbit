//
//  UTUserCenterHeadView.m
//  URabbit
//
//  Created by Mac on 2018/11/18.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTUserCenterHeadView.h"

@implementation UTUserCenterHeadView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"defaultHeadImage"]];
        [self addSubview:headImageView];
        
        nickNameLabel = [[UILabel alloc] init];
        [nickNameLabel setTextColor:[UIColor colorFromHexString:@"#333333"]];
        [nickNameLabel setTextAlignment:NSTextAlignmentLeft];
        [nickNameLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [nickNameLabel setHidden:YES];
        [self addSubview:nickNameLabel];
        
        memberIdLabel = [[UILabel alloc] init];
        [memberIdLabel setTextColor:[UIColor colorFromHexString:@"#999999"]];
        [memberIdLabel setTextAlignment:NSTextAlignmentLeft];
        [memberIdLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [memberIdLabel setHidden:YES];
        [self addSubview:memberIdLabel];
        
        noLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSAttributedString *title = [AppUtils generateAttriuteStringWithStr:@"点击登录/注册" WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:16.0f]];
        [noLoginButton setAttributedTitle:title forState:UIControlStateNormal];
        [noLoginButton setHidden:YES];
        [self addSubview:noLoginButton];
    }
    return self;
}

@end
