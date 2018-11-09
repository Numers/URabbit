//
//  UTPhotoEditShowImageCollectionViewCell.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/6.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTPhotoEditShowImageCollectionViewCell.h"
#import "EditInfo.h"

@implementation UTPhotoEditShowImageCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.5, 0.5, frame.size.width - 1, frame.size.height - 1)];
        [self addSubview:imageView];
    }
    return self;
}

-(void)setupCellWithEditInfo:(EditInfo *)info
{
    editInfo = info;
    [imageView setImage:info.editImage];
}

-(void)updateImageView
{
    [imageView setImage:editInfo.editImage];
}

-(void)setPictureImage:(UIImage *)image
{
    [imageView setImage:image];
}

-(void)setIsSelected:(BOOL)selected
{
    isSelected = selected;
    if (selected) {
        [self setBackgroundColor:[UIColor redColor]];
    }else{
        [self setBackgroundColor:[UIColor blackColor]];
    }
}
@end
