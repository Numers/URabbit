//
//  UTAuthorCollectionViewCell.h
//  URabbit
//
//  Created by 鲍利成 on 2018/12/10.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeTemplate;
@interface UTAuthorCollectionViewCell : UICollectionViewCell
{
    UIImageView *templateImageView;
    UILabel *nameLabel;
    
    UILabel *vipLabel;
}
-(void)setupCellWithHomeTemplate:(HomeTemplate *)homeTemplate;
@end
