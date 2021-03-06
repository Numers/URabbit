//
//  URVideoAuthorView.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/5.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "URVideoAuthorView.h"
#import "HomeTemplate.h"
#import "Author.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation URVideoAuthorView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUserInteractionEnabled:YES];
        [self setBackgroundColor:[UIColor clearColor]];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        [self addGestureRecognizer:tapGesture];
        headImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"authorHeadImage"]];
        [headImageView.layer setCornerRadius:20.5];
        [headImageView.layer setMasksToBounds:YES];
        [self addSubview:headImageView];
        
        authorNameLabel = [[UILabel alloc] init];
        [authorNameLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [authorNameLabel setTextColor:[UIColor colorFromHexString:@"#333333"]];
        [self addSubview:authorNameLabel];
        
        nextImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"next_button"]];
        [self addSubview:nextImageView];
        
        [self makeConstraints];
    }
    return self;
}

-(void)makeConstraints
{
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.width.equalTo(@(41));
        make.height.equalTo(@(41));
        make.centerY.equalTo(self.centerY);
    }];
    
    [authorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(headImageView.trailing).offset(10);
        make.centerY.equalTo(self.centerY);
        make.height.equalTo(@(20));
    }];
    
    [nextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-15);
        make.centerY.equalTo(self.centerY);
    }];
}

-(void)setHomeTemplate:(HomeTemplate *)homeTemplate
{
    [authorNameLabel setText:homeTemplate.author.nickName];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:homeTemplate.author.portrait] placeholderImage:nil];
}

-(void)tapClick
{
    if ([self.delegate respondsToSelector:@selector(didTapClickAuthorView)]) {
        [self.delegate didTapClickAuthorView];
    }
}
@end
