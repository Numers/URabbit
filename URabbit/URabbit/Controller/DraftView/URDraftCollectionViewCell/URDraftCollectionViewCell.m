//
//  URDraftCollectionViewCell.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/27.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "URDraftCollectionViewCell.h"
#import "DraftTemplate.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation URDraftCollectionViewCell
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
        
        nameLabel = [[UILabel alloc] init];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [nameLabel setTextColor:[UIColor colorFromHexString:@"#333333"]];
        [self addSubview:nameLabel];
        
        [self makeContraints];
    }
    return self;
}

-(void)makeContraints
{
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

-(void)setupCellWithDraftTemplate:(DraftTemplate *)draftTemplate
{
    [templateImageView setContentMode:UIViewContentModeScaleAspectFit];
    [templateImageView sd_setImageWithURL:[NSURL URLWithString:draftTemplate.coverUrl] placeholderImage:[UIImage imageNamed:@"CoverPlaceholdImage"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if ([[imageURL absoluteString] isEqualToString:draftTemplate.coverUrl]) {
            [templateImageView setContentMode:UIViewContentModeScaleAspectFill];
        }
    }];
    [nameLabel setText:draftTemplate.title];
}
@end
