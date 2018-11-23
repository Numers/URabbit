//
//  UTUserCenterTableViewCell.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/23.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTUserCenterTableViewCell.h"

@implementation UTUserCenterTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        iconImageView = [[UIImageView alloc] init];
        [self addSubview:iconImageView];
        
        leftLabel = [[UILabel alloc] init];
        [leftLabel setTextColor:[UIColor colorFromHexString:@"#333333"]];
        [leftLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [leftLabel setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:leftLabel];
        
        accessoryImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nextIconImage"]];
        [self addSubview:accessoryImageView];
        
        rightLabel = [[UILabel alloc] init];
        [rightLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [rightLabel setTextColor:[UIColor colorFromHexString:@"#999999"]];
        [self addSubview:rightLabel];
        
        bottomLine = [[UIView alloc] init];
        [bottomLine setBackgroundColor:[UIColor colorFromHexString:@"#F1F1F1"]];
        [bottomLine setHidden:YES];
        [self addSubview:bottomLine];
        
        [self makeConstraints];
    }
    return self;
}

-(void)makeConstraints
{
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(25);
        make.centerY.equalTo(self.centerY);
        make.width.equalTo(@(18));
    }];
    
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(iconImageView.trailing).offset(14);
        make.centerY.equalTo(self.centerY);
    }];
    
    [accessoryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self).offset(-25);
        make.centerY.equalTo(self.centerY);
    }];
    
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(accessoryImageView.leading).offset(-12);
        make.centerY.equalTo(self.centerY);
    }];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.leading.equalTo(@(25));
        make.trailing.equalTo(@(-25));
        make.height.equalTo(@(1));
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setIcon:(UIImage *)image leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle isShowBottomLine:(BOOL)isShow
{
    [iconImageView setImage:image];
    [leftLabel setText:leftTitle];
    [rightLabel setText:rightTitle];
    [bottomLine setHidden:!isShow];
}
@end
