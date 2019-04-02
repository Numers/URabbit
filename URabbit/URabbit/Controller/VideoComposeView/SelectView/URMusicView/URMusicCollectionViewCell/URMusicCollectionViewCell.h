//
//  UTMusicCollectionViewCell.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/22.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSTCollectionViewCell.h"
@class MusicInfo;
@interface URMusicCollectionViewCell : PSTCollectionViewCell
{
    UIImageView *musicImageView;
    UILabel *nameLabel;
    BOOL isSelected;
}
-(void)setupCellWithMusicInfo:(MusicInfo *)info;
-(void)setIsSelected:(BOOL)isSelect;
@end
