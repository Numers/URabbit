//
//  URMemberTableViewCell.h
//  URabbit
//
//  Created by 鲍利成 on 2018/12/4.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VIPPrice;
@interface URMemberTableViewCell : UITableViewCell
{
    UIView *backView;
    UIImageView *imageView;
    UILabel *nameLabel;
    UILabel *descLabel;
    UILabel *priceLabel;
    
    BOOL isSelected;
}

-(void)setupCellWithVipPrice:(VIPPrice *)price;
-(void)setIsSelect:(BOOL)selected;
@end
