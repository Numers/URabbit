//
//  URHomeRecommendCollectionViewCell.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/4.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "URHomeRecommendCollectionViewCell.h"
#import "RecommendTemplate.h"
#import "UIImageView+WebCache.h"

@implementation URHomeRecommendCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        recommendImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [recommendImageView.layer setCornerRadius:5];
        [recommendImageView.layer masksToBounds];
        [recommendImageView setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:recommendImageView];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height - 30, frame.size.width, 20)];
        [nameLabel setTextColor:[UIColor whiteColor]];
        [nameLabel setTextAlignment:NSTextAlignmentCenter];
        [nameLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
        [self addSubview:nameLabel];
    }
    return self;
}

-(void)setupWithRecommendTemplate:(RecommendTemplate *)recommend
{
    [recommendImageView sd_setImageWithURL:[NSURL URLWithString:recommend.coverImage] placeholderImage:[UIImage imageNamed:@"CoverPlaceholdImage"]];
    [nameLabel setText:recommend.name];
}
@end
