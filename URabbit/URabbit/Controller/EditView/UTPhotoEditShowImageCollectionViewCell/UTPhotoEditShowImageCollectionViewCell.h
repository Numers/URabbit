//
//  UTPhotoEditShowImageCollectionViewCell.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/6.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSTCollectionViewCell.h"
@class Snapshot;
@interface UTPhotoEditShowImageCollectionViewCell : PSTCollectionViewCell
{
    Snapshot *snapshot;
    UIImageView *imageView;
    UILabel *indexLabel;
    BOOL isSelected;
}

-(void)setupCellWithSnapshot:(Snapshot *)info index:(NSInteger)index;
-(void)setPictureImage:(UIImage *)image;
-(void)setIsSelected:(BOOL)selected;
@end
