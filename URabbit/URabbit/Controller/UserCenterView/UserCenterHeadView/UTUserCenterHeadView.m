//
//  UTUserCenterHeadView.m
//  URabbit
//
//  Created by Mac on 2018/11/18.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTUserCenterHeadView.h"
#import "Member.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation UTUserCenterHeadView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headIconImage"]];
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
        
        saveNumberLabel = [[UILabel alloc] init];
        [saveNumberLabel setTextColor:[UIColor colorFromHexString:@"#333333"]];
        [saveNumberLabel setFont:[UIFont systemFontOfSize:18.0f]];
        [saveNumberLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:saveNumberLabel];
        
        saveNumberDescLabel = [[UILabel alloc] init];
        [saveNumberDescLabel setTextColor:[UIColor colorFromHexString:@"#999999"]];
        [saveNumberDescLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [saveNumberDescLabel setTextAlignment:NSTextAlignmentCenter];
        [saveNumberDescLabel setText:@"收藏夹"];
        [self addSubview:saveNumberDescLabel];
        
        draftNumberLabel = [[UILabel alloc] init];
        [draftNumberLabel setTextColor:[UIColor colorFromHexString:@"#333333"]];
        [draftNumberLabel setFont:[UIFont systemFontOfSize:18.0f]];
        [draftNumberLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:draftNumberLabel];
        
        draftNumberDescLabel = [[UILabel alloc] init];
        [draftNumberDescLabel setTextColor:[UIColor colorFromHexString:@"#999999"]];
        [draftNumberDescLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [draftNumberDescLabel setTextAlignment:NSTextAlignmentCenter];
        [draftNumberDescLabel setText:@"草稿箱"];
        [self addSubview:draftNumberDescLabel];
        
        downloadNumberLabel = [[UILabel alloc] init];
        [downloadNumberLabel setTextColor:[UIColor colorFromHexString:@"#333333"]];
        [downloadNumberLabel setFont:[UIFont systemFontOfSize:18.0f]];
        [downloadNumberLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:downloadNumberLabel];
        
        downloadNumberDescLabel = [[UILabel alloc] init];
        [downloadNumberDescLabel setTextColor:[UIColor colorFromHexString:@"#999999"]];
        [downloadNumberDescLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [downloadNumberDescLabel setTextAlignment:NSTextAlignmentCenter];
        [downloadNumberDescLabel setText:@"已下载"];
        [self addSubview:downloadNumberDescLabel];
        
        line1View = [[UIView alloc] init];
        [line1View setBackgroundColor:[UIColor colorFromHexString:@"#F1F1F1"]];
        [self addSubview:line1View];
        
        line2View = [[UIView alloc] init];
        [line2View setBackgroundColor:[UIColor colorFromHexString:@"#F1F1F1"]];
        [self addSubview:line2View];
        
        [self makeConstraints];
    }
    return self;
}

-(void)makeConstraints
{
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(25);
        make.top.equalTo(self).offset(26);
        make.width.equalTo(@(60));
        make.height.equalTo(@(60));
    }];
    
    [noLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(headImageView.trailing).offset(0);
        make.centerY.equalTo(headImageView.centerY);
        make.height.equalTo(@(30));
        make.width.equalTo(@(134));
    }];
    
    [nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(headImageView.trailing).offset(15);
        make.centerY.equalTo(headImageView.centerY).offset(-13);
        make.height.equalTo(@(22));
    }];
    
    [memberIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(headImageView.trailing).offset(15);
        make.centerY.equalTo(headImageView.centerY).offset(10);
        make.height.equalTo(@(17));
    }];
    
    [saveNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headImageView.bottom).offset(26);
        make.centerX.equalTo(self.centerX);
        make.width.equalTo(@(SCREEN_WIDTH / 3));
        make.height.equalTo(@(25));
    }];
    
    [saveNumberDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(saveNumberLabel.bottom).offset(4);
        make.leading.equalTo(saveNumberLabel.leading);
        make.trailing.equalTo(saveNumberLabel.trailing);
        make.height.equalTo(@(17));
    }];
    
    [line1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(saveNumberLabel.top);
        make.bottom.equalTo(saveNumberDescLabel.bottom);
        make.trailing.equalTo(saveNumberLabel.leading);
        make.width.equalTo(@(1));
    }];
    
    [downloadNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(saveNumberLabel.top);
        make.bottom.equalTo(saveNumberLabel.bottom);
        make.leading.equalTo(self);
        make.trailing.equalTo(line1View.leading);
    }];
    
    [downloadNumberDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(saveNumberDescLabel.top);
        make.bottom.equalTo(saveNumberDescLabel.bottom);
        make.leading.equalTo(downloadNumberLabel.leading);
        make.trailing.equalTo(downloadNumberLabel.trailing);
    }];
    
    [line2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(saveNumberLabel.top);
        make.bottom.equalTo(saveNumberDescLabel.bottom);
        make.leading.equalTo(saveNumberLabel.trailing);
        make.width.equalTo(@(1));
    }];
    
    [draftNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(saveNumberLabel.top);
        make.bottom.equalTo(saveNumberLabel.bottom);
        make.trailing.equalTo(self);
        make.leading.equalTo(line2View.trailing);
    }];
    
    [draftNumberDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(saveNumberDescLabel.top);
        make.bottom.equalTo(saveNumberDescLabel.bottom);
        make.leading.equalTo(draftNumberLabel.leading);
        make.trailing.equalTo(draftNumberLabel.trailing);
    }];
}

-(void)setCurrentMember:(Member *)member
{
    if (member) {
        [nickNameLabel setHidden:NO];
        [nickNameLabel setText:member.nickName];
        [memberIdLabel setHidden:NO];
        [memberIdLabel setText:member.memberId];
        [noLoginButton setHidden:YES];
        
        [headImageView sd_setImageWithURL:[NSURL URLWithString:member.headIcon] placeholderImage:[UIImage imageNamed:@"headIconImage"]];
    }else{
        [nickNameLabel setHidden:YES];
        [memberIdLabel setHidden:YES];
        [noLoginButton setHidden:NO];
        
        [headImageView setImage:[UIImage imageNamed:@"headIconImage"]];
        [saveNumberLabel setText:@"0"];
        [downloadNumberLabel setText:@"0"];
        [draftNumberLabel setText:@"0"];
    }
}

-(void)setSaveNumber:(NSInteger)saveNumber downloadNumber:(NSInteger)downloadNumber draftNumber:(NSInteger)draftNumber
{
    [saveNumberLabel setText:[NSString stringWithFormat:@"%ld",saveNumber]];
    [downloadNumberLabel setText:[NSString stringWithFormat:@"%ld",downloadNumber]];
    [draftNumberLabel setText:[NSString stringWithFormat:@"%ld",draftNumber]];
}
@end
