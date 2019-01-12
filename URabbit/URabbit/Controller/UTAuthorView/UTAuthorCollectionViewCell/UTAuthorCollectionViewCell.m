//
//  UTAuthorCollectionViewCell.m
//  URabbit
//
//  Created by 鲍利成 on 2018/12/10.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTAuthorCollectionViewCell.h"
#import "HomeTemplate.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation UTAuthorCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        templateImageView = [[UIImageView alloc] init];
        [templateImageView setContentMode:UIViewContentModeScaleAspectFit];
        [templateImageView setBackgroundColor:[UIColor colorWithRed:241.0f/ 255 green:241.0f/ 255 blue:241.0f/ 255 alpha:1.0f]];
        [templateImageView.layer setCornerRadius:5];
        [templateImageView.layer setMasksToBounds:YES];
        [self addSubview:templateImageView];
        
        vipLabel = [[UILabel alloc] init];
        [vipLabel setText:@"vip"];
        [vipLabel setHidden:YES];
        [vipLabel setTextColor:[UIColor whiteColor]];
        [vipLabel setBackgroundColor:[UIColor redColor]];
        [vipLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [vipLabel setTextAlignment:NSTextAlignmentCenter];
        [templateImageView addSubview:vipLabel];
        
        nameLabel = [[UILabel alloc] init];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [nameLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:nameLabel];
        
        [self makeContraints];
    }
    return self;
}

-(void)makeContraints
{
    [vipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.leading.equalTo(self);
        make.width.equalTo(@(30));
        make.height.equalTo(@(17));
    }];
    
    [templateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.bottom.equalTo(self).offset(-50);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(templateImageView.mas_bottom).offset(10);
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.height.equalTo(@(20));
    }];
}

-(void)setupCellWithHomeTemplate:(HomeTemplate *)homeTemplate
{
    [templateImageView sd_setImageWithURL:[NSURL URLWithString:homeTemplate.coverUrl] placeholderImage:[UIImage imageNamed:@"CoverPlaceholdImage"]];
    [nameLabel setText:homeTemplate.title];
    if (homeTemplate.isVip) {
        [vipLabel setHidden:NO];
    }else{
        [vipLabel setHidden:YES];
    }
}
@end
