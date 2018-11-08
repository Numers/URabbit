//
//  UTFilterCollectionViewCell.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/8.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FilterInfo;
@interface UTFilterCollectionViewCell : UICollectionViewCell
{
    UIImageView *filterImageView;
    UILabel *nameLabel;
}
-(void)setupCellWithFilterInfo:(FilterInfo *)info;
-(void)setIsSelected:(BOOL)isSelected;
@end
