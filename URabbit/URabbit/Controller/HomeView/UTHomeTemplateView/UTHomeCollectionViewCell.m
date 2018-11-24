//
//  UTHomeCollectionViewCell.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/2.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTHomeCollectionViewCell.h"
#import "HomeTemplate.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation UTHomeCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        templateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - 50)];
        [templateImageView.layer setCornerRadius:5];
        [templateImageView.layer setMasksToBounds:YES];
        [self addSubview:templateImageView];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height - 40, frame.size.width, 20)];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [nameLabel setTextColor:[UIColor colorFromHexString:@"#333333"]];
        [self addSubview:nameLabel];
    }
    return self;
}

-(void)setupCellWithHomeTemplate:(HomeTemplate *)homeTemplate
{
    [templateImageView sd_setImageWithURL:[NSURL URLWithString:homeTemplate.coverUrl] placeholderImage:[UIImage imageNamed:@"CoverPlaceholdImage"]];
    [nameLabel setText:homeTemplate.title];
}
@end
