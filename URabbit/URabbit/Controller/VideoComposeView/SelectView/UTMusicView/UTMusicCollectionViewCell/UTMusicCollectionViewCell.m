//
//  UTMusicCollectionViewCell.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/22.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTMusicCollectionViewCell.h"
#import "MusicInfo.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation UTMusicCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.layer setCornerRadius:3.0f];
        [self.layer setMasksToBounds:YES];
        musicImageView = [[UIImageView alloc] init];
        [self addSubview:musicImageView];
        
        nameLabel = [[UILabel alloc] init];
        [nameLabel setFont:[UIFont systemFontOfSize:10.0f]];
        [nameLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:nameLabel];
        [self makeConstraints];
    }
    return self;
}

-(void)makeConstraints
{
    [musicImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.height.equalTo(musicImageView.mas_width).multipliedBy(1);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(musicImageView.bottom);
        make.bottom.equalTo(self);
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
    }];
}

-(void)setupCellWithMusicInfo:(MusicInfo *)info
{
    if (info.musicImage) {
        [musicImageView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        [musicImageView setContentMode:UIViewContentModeScaleAspectFit];
        [musicImageView sd_setImageWithURL:[NSURL URLWithString:info.musicImage] placeholderImage:[UIImage imageNamed:@"defaultMusic_Image"]];
    }else{
        [musicImageView setBackgroundColor:[UIColor colorFromHexString:@"#173B8A"]];
        [musicImageView setContentMode:UIViewContentModeCenter];
        [musicImageView setImage:[UIImage imageNamed:@"defaultMusic_Image"]];
    }
    
    [nameLabel setText:info.musicName];
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
        [nameLabel setTextColor:[UIColor colorFromHexString:@"#E22262"]];
        self.layer.borderWidth = 2;
        self.layer.borderColor = [UIColor colorFromHexString:@"#E22262"].CGColor;
    }else{
        [nameLabel setTextColor:[UIColor colorFromHexString:@"#333333"]];
        self.layer.borderWidth = 0.01;
        self.layer.borderColor = [UIColor clearColor].CGColor;
    }
}
@end
