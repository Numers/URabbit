//
//  URMemberTableViewCell.m
//  URabbit
//
//  Created by 鲍利成 on 2018/12/4.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "URMemberTableViewCell.h"
#import "VIPPrice.h"

@implementation URMemberTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        backView = [[UIView alloc] init];
        [backView.layer setCornerRadius:5];
        [backView.layer setMasksToBounds:YES];
        [self addSubview:backView];
        
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"VipIconImage"]];
        [backView addSubview:imageView];
        
        nameLabel = [[UILabel alloc] init];
        [nameLabel setTextColor:[UIColor colorFromHexString:@"#333333"]];
        [nameLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [backView addSubview:nameLabel];
        
        descLabel = [[UILabel alloc] init];
        [descLabel setTextColor:[UIColor colorFromHexString:@"#999999"]];
        [descLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [descLabel setTextAlignment:NSTextAlignmentLeft];
        [backView addSubview:descLabel];
        
        priceLabel = [[UILabel alloc] init];
        [priceLabel setTextColor:[UIColor colorFromHexString:@"#ED9248"]];
        [priceLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
        [priceLabel setTextAlignment:NSTextAlignmentRight];
        [backView addSubview:priceLabel];
        
        [self makeConstraints];
    }
    return self;
}

-(void)makeConstraints
{
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(25);
        make.trailing.equalTo(self).offset(-25);
        make.height.equalTo(@(71));
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(backView.mas_leading).offset(23);
        make.centerY.equalTo(backView.mas_centerY);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(imageView.trailing).offset(19);
        make.centerY.equalTo(backView.mas_centerY).offset(-11);
        make.height.equalTo(@(20));
    }];
    
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(imageView.trailing).offset(19);
        make.centerY.equalTo(backView.mas_centerY).offset(9.5);
        make.height.equalTo(@(17));
    }];
    
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(backView.mas_trailing).offset(-16);
        make.centerY.equalTo(backView.mas_centerY);
        make.height.equalTo(@(22));
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    [self setIsSelect:selected];
}

-(void)setIsSelect:(BOOL)selected
{
    isSelected = selected;
    if (selected) {
        [backView.layer setBorderColor:[UIColor colorFromHexString:@"#ED9248"].CGColor];
        [backView.layer setBorderWidth:1];
        [backView setBackgroundColor:[UIColor colorFromHexString:@"#ED9248" opacity:0.08]];
    }else{
        [backView.layer setBorderColor:[UIColor colorFromHexString:@"#999999"].CGColor];
        [backView.layer setBorderWidth:1];
        [backView setBackgroundColor:[UIColor colorWithRed:153.0f/ 255 green:153.0f / 255 blue:153.0 / 255 alpha:0.08]];
    }
}

-(void)setupCellWithVipPrice:(VIPPrice *)price
{
    [nameLabel setText:price.name];
    [descLabel setText:price.desc];
    NSString *pricestring = [NSString stringWithFormat:@"￥%ld",price.amount];
    [priceLabel setText:pricestring];
}
@end
