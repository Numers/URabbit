//
//  URCategoryPageCollectionViewCell.h
//  URabbit
//
//  Created by 鲍利成 on 2019/1/5.
//  Copyright © 2019年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HomeTemplate;
@interface URCategoryPageCollectionViewCell : UICollectionViewCell
{
    UIImageView *templateImageView;
    UILabel *nameLabel;
    
    UILabel *vipLabel;
}
-(void)setupCellWithHomeTemplate:(HomeTemplate *)homeTemplate;
@end

NS_ASSUME_NONNULL_END
