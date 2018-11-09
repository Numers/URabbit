//
//  UTPhotoEditShowImageCollectionViewCell.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/6.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EditInfo;
@interface UTPhotoEditShowImageCollectionViewCell : UICollectionViewCell
{
    EditInfo *editInfo;
    UIImageView *imageView;
    BOOL isSelected;
}

-(void)setupCellWithEditInfo:(EditInfo *)info;
-(void)updateImageView;
-(void)setPictureImage:(UIImage *)image;
-(void)setIsSelected:(BOOL)selected;
@end
