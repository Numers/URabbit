//
//  URUserCenterTableViewCell.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/23.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface URUserCenterTableViewCell : UITableViewCell
{
    UIImageView *iconImageView;
    UILabel *leftLabel;
    UILabel *rightLabel;
    UIImageView *accessoryImageView;
    UIView *bottomLine;
}

-(void)setIcon:(UIImage *)image leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle isShowBottomLine:(BOOL)isShow;
@end
