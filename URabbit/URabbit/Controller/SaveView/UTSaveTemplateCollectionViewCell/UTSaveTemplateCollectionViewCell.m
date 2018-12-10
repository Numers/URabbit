//
//  UTSaveTemplateCollectionViewCell.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/25.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTSaveTemplateCollectionViewCell.h"
#import "SavedTemplate.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation UTSaveTemplateCollectionViewCell
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
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height - 40, frame.size.width, 20)];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [nameLabel setTextColor:[UIColor colorFromHexString:@"#333333"]];
        [self addSubview:nameLabel];
    }
    return self;
}

-(void)setupCellWithSavedTemplate:(SavedTemplate *)savedTemplate
{
    [templateImageView sd_setImageWithURL:[NSURL URLWithString:savedTemplate.coverUrl] placeholderImage:[UIImage imageNamed:@"CoverPlaceholdImage"]];
    [nameLabel setText:savedTemplate.title];
}
@end
