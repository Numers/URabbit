//
//  UTSelectView.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/7.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTSelectView.h"

@implementation UTSelectView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

-(void)showViewWithIndex:(NSInteger)index
{
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    switch (index) {
        case 0:
        {
            if (filterView == nil) {
                filterView = [[UTFilterView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
                filterView.delegate = self;
                if ([self.delegate respondsToSelector:@selector(requestFilterViewDataSource)]) {
                    NSMutableArray *datasource = [self.delegate requestFilterViewDataSource];
                    [filterView setFilterList:datasource];
                }
            }
            [self addSubview:filterView];
        }
            break;
        case 1:
        {
            if (musicView == nil) {
                musicView = [[UTMusicView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
                musicView.delegate = self;
                if ([self.delegate respondsToSelector:@selector(requestMusicViewDataSource)]) {
                   [self.delegate requestMusicViewDataSource];
                }
            }
            [self addSubview:musicView];
        }
            break;
            
        default:
            break;
    }
}

-(void)setMusicList:(NSMutableArray *)list
{
    if (musicView) {
        [musicView setMusicList:list];
    }
}

-(void)setFilterList:(NSMutableArray *)list
{
    if (filterView) {
        [filterView setFilterList:list];
    }
}
#pragma -mark UTFilterViewProtocol
-(void)selectFilter:(FilterInfo *)info
{
    if ([self.delegate respondsToSelector:@selector(didSelectFilter:)]) {
        [self.delegate didSelectFilter:info];
    }
}

#pragma -mark UTMusicViewProtocol
-(void)selectMusic:(MusicInfo *)info
{
    if ([self.delegate respondsToSelector:@selector(didSelectMusic:)]) {
        [self.delegate didSelectMusic:info];
    }
}
@end
