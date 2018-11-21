//
//  UTPhotoEditShowImageCollectionViewCell.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/6.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Snapshot;
@interface UTPhotoEditShowImageCollectionViewCell : UICollectionViewCell
{
    Snapshot *snapshot;
    UIImageView *imageView;
    BOOL isSelected;
}

-(void)setupCellWithSnapshot:(Snapshot *)info;
-(void)updateImageView;
-(void)setPictureImage:(UIImage *)image;
-(void)setIsSelected:(BOOL)selected;
@end
