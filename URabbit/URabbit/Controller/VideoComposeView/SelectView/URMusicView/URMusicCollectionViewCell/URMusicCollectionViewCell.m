//
//  URMusicCollectionViewCell.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/22.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "URMusicCollectionViewCell.h"
#import "MusicInfo.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation URMusicCollectionViewCell
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
        [musicImageView sd_setImageWithURL:[NSURL URLWithString:info.musicImage] placeholderImage:[UIImage imageNamed:@"defaultMusic_Image"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image) {
                [musicImageView setContentMode:UIViewContentModeScaleAspectFit];
            }else{
                [musicImageView setContentMode:UIViewContentModeCenter];
            }
        }];
    }else{
        [musicImageView setBackgroundColor:[UIColor colorFromHexString:@"#173B8A"]];
        [musicImageView setContentMode:UIViewContentModeCenter];
        if (info.musicUrl) {
            [musicImageView setImage:[UIImage imageNamed:@"defaultMusic_Image"]];
        }else{
            [musicImageView setImage:[UIImage imageNamed:@"noMusic_Image"]];
        }
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
        [nameLabel setTextColor:[UIColor colorFromHexString:@"#333333"]];
        self.layer.borderWidth = 2;
        self.layer.borderColor = [UIColor colorFromHexString:@"#FFDE44"].CGColor;
    }else{
        [nameLabel setTextColor:[UIColor colorFromHexString:@"#333333"]];
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor colorFromHexString:@"#F5F5F5"].CGColor;
    }
}
@end
