//
//  UTHomeCollectionViewCell.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/2.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeTemplate;
@interface UTHomeCollectionViewCell : UICollectionViewCell
{
    UIImageView *templateImageView;
    UILabel *nameLabel;
}
-(void)setupCellWithHomeTemplate:(HomeTemplate *)homeTemplate;
@end
