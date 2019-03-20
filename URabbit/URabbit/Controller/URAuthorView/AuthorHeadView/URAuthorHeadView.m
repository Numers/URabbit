//
//  URAuthorHeadView.m
//  URabbit
//
//  Created by 鲍利成 on 2018/12/10.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "URAuthorHeadView.h"
#import "Author.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation URAuthorHeadView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        headImageView = [[UIImageView alloc] init];
        [headImageView.layer setCornerRadius:25];
        [headImageView.layer setMasksToBounds:YES];
        [self addSubview:headImageView];
        
        nickNameLabel = [[UILabel alloc] init];
        [nickNameLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [nickNameLabel setTextColor:[UIColor colorFromHexString:@"#333333"]];
        [nickNameLabel setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:nickNameLabel];
        
        subjectLabel = [[UILabel alloc] init];
        [self addSubview:subjectLabel];
        
        makeLabel = [[UILabel alloc] init];
        [self addSubview:makeLabel];
        
        summaryLabel = [[UILabel alloc] init];
        [summaryLabel setNumberOfLines:0];
        [summaryLabel setTextAlignment:NSTextAlignmentLeft];
        [summaryLabel setTextColor:[UIColor colorFromHexString:@"#999999"]];
        [summaryLabel setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:summaryLabel];
        
        [self makeConstraints];
    }
    return self;
}

-(void)makeConstraints
{
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.top.equalTo(self).offset(24);
        make.width.equalTo(@(50));
        make.height.equalTo(@(50));
    }];
    
    [nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(headImageView.trailing).offset(16);
        make.centerY.equalTo(headImageView.mas_centerY).offset(-13.5);
        make.height.equalTo(@(22));
    }];
    
    [subjectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(headImageView.trailing).offset(16);
        make.centerY.equalTo(headImageView.mas_centerY).offset(12.5);
        make.height.equalTo(@(20));
        make.width.equalTo(@(100));
    }];
    
    [makeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(20));
        make.centerY.equalTo(subjectLabel.mas_centerY);
        make.leading.equalTo(subjectLabel.trailing).offset(0);
    }];
    
    [summaryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(15);
        make.trailing.equalTo(self).offset(-15);
        make.top.equalTo(headImageView.bottom).offset(19);
    }];
}

-(NSAttributedString *)generateWithTitle:(NSString *)title count:(NSInteger)count
{
    NSMutableAttributedString *attributeString = [AppUtils generateAttriuteStringWithStr:title WithColor:[UIColor colorFromHexString:@"#999999"] WithFont:[UIFont systemFontOfSize:14]];
    NSAttributedString *countString = [AppUtils generateAttriuteStringWithStr:[NSString stringWithFormat:@" %ld",count] WithColor:[UIColor colorFromHexString:@"#333333"] WithFont:[UIFont systemFontOfSize:14]];
    [attributeString appendAttributedString:countString];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentLeft;
    [attributeString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attributeString.length)];
    return attributeString;
}

-(void)setAuthor:(Author *)author
{
    currentAuthor = author;
    [headImageView sd_setImageWithURL:[NSURL URLWithString:author.portrait] placeholderImage:[UIImage imageNamed:@"authorHeadImage"]];
    [nickNameLabel setText:author.nickName];
    [subjectLabel setAttributedText:[self generateWithTitle:@"主题" count:author.subjectCount]];
    [makeLabel setAttributedText:[self generateWithTitle:@"制作" count:author.makeCount]];
    [summaryLabel setText:author.summary];
}
@end
