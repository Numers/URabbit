//
//  URPlayCollectionViewCell.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/7.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface URPlayCollectionViewCell : UICollectionViewCell
{
    UIImageView *imageView;
}

-(void)setupCellWithImage:(UIImage *)image;
@end
