//
//  UTHomeRecommendCollectionViewCell.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/4.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTHomeRecommendCollectionViewCell.h"
#import "RecommendTemplate.h"

@implementation UTHomeRecommendCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        recommendImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [recommendImageView.layer setCornerRadius:5];
        [recommendImageView.layer masksToBounds];
        [recommendImageView setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:recommendImageView];
    }
    return self;
}

-(void)setupWithRecommendTemplate:(RecommendTemplate *)recommend
{
    [recommendImageView setImage:[UIImage imageNamed:recommend.image]];
}
@end
