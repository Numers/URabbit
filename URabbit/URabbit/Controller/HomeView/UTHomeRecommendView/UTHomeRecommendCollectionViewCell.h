//
//  UTHomeRecommendCollectionViewCell.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/4.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RecommendTemplate;
@interface UTHomeRecommendCollectionViewCell : UICollectionViewCell
{
    UIImageView *recommendImageView;
}

-(void)setupWithRecommendTemplate:(RecommendTemplate *)recommend;
@end
