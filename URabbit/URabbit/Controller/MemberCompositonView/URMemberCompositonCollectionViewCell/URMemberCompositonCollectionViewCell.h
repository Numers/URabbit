//
//  URMemberCompositonCollectionViewCell.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/24.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Composition;
@interface URMemberCompositonCollectionViewCell : UICollectionViewCell
{
    UIImageView *templateImageView;
    UILabel *nameLabel;
}
-(void)setupCellWithCompositon:(Composition *)compositon;
@end
