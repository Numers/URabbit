//
//  URFilterCollectionViewCell.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/8.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSTCollectionViewCell.h"
@class FilterInfo;
@interface URFilterCollectionViewCell : PSTCollectionViewCell
{
    UIImageView *filterImageView;
    UILabel *nameLabel;
    BOOL isSelected;
}
-(void)setupCellWithFilterInfo:(FilterInfo *)info;
-(void)setIsSelected:(BOOL)isSelect;
@end
