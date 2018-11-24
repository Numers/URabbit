//
//  UTUserSettingTableViewCell.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/24.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UTUserSettingTableViewCell : UITableViewCell
{
    UILabel *leftLabel;
    UILabel *rightLabel;
    UIImageView *accessoryImageView;
    UIView *bottomLine;
}

-(void)setLeftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle isShowBottomLine:(BOOL)isShow;
@end
