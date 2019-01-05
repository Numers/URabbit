//
//  UTCategoryPageCollectionViewCell.m
//  URabbit
//
//  Created by 鲍利成 on 2019/1/5.
//  Copyright © 2019年 鲍利成. All rights reserved.
//

#import "UTCategoryPageCollectionViewCell.h"
#import "HomeTemplate.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation UTCategoryPageCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        templateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - 50)];
        [templateImageView setContentMode:UIViewContentModeScaleAspectFit];
        [templateImageView setBackgroundColor:[UIColor colorWithRed:241.0f/ 255 green:241.0f/ 255 blue:241.0f/ 255 alpha:1.0f]];
        [templateImageView.layer setCornerRadius:5];
        [templateImageView.layer setMasksToBounds:YES];
        [self addSubview:templateImageView];
        
        vipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 17)];
        [vipLabel setText:@"vip"];
        [vipLabel setHidden:YES];
        [vipLabel setTextColor:[UIColor whiteColor]];
        [vipLabel setBackgroundColor:[UIColor redColor]];
        [vipLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [vipLabel setTextAlignment:NSTextAlignmentCenter];
        [templateImageView addSubview:vipLabel];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height - 40, frame.size.width, 20)];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [nameLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:nameLabel];
    }
    return self;
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
