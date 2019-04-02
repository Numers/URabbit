//
//  URFilterCollectionViewCell.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/8.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "URFilterCollectionViewCell.h"
#import "FilterInfo.h"

@implementation URFilterCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.layer setCornerRadius:3.0f];
        [self.layer setMasksToBounds:YES];
        filterImageView = [[UIImageView alloc] init];
        [self addSubview:filterImageView];
        
        nameLabel = [[UILabel alloc] init];
        [nameLabel setBackgroundColor:[UIColor whiteColor]];
        [nameLabel setFont:[UIFont systemFontOfSize:10.0f]];
        [nameLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:nameLabel];
        [self makeConstraints];
    }
    return self;
}

-(void)makeConstraints
{
    [filterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.height.equalTo(filterImageView.mas_width).multipliedBy(1);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(filterImageView.bottom);
        make.bottom.equalTo(self).offset(0);
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
    }];
}

-(void)setupCellWithFilterInfo:(FilterInfo *)info
{
    [filterImageView setImage:[UIImage imageNamed:info.filterImage]];
    [nameLabel setText:info.filterName];
}

-(void)setIsSelected:(BOOL)isSelect
{
    isSelected = isSelect;
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (isSelected) {
        [nameLabel setTextColor:[UIColor colorFromHexString:@"#333333"]];
        self.layer.borderWidth = 2;
        self.layer.borderColor = [UIColor colorFromHexString:@"#FFDE44"].CGColor;
    }else{
        [nameLabel setTextColor:[UIColor colorFromHexString:@"#333333"]];
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor colorFromHexString:@"#F5F5F5"].CGColor;
    
//        //shadow不能masksToBounds=YES
//        [nameLabel.layer setShadowOpacity:0.5f];
//        [nameLabel.layer setShadowOffset:CGSizeMake(0, 1.0)];
//        [nameLabel.layer setShadowColor:[UIColor colorFromHexString:@"#F5F5F5"].CGColor];
    }
}
@end
