//
//  URSelectView.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/7.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "URSelectView.h"

@implementation URSelectView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        filterView = [[URFilterView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        filterView.delegate = self;
        [filterView setHidden:YES];
        [self addSubview:filterView];
        
        musicView = [[URMusicView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        musicView.delegate = self;
        [musicView setHidden:YES];
        [self addSubview:musicView];
    }
    return self;
}

-(void)showViewWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            [filterView setHidden:NO];
            [musicView setHidden:YES];
            if (![filterView isLoadData]) {
                if ([self.delegate respondsToSelector:@selector(requestFilterViewDataSource)]) {
                    NSMutableArray *datasource = [self.delegate requestFilterViewDataSource];
                    [filterView setFilterList:datasource];
                }
            }
        }
            break;
        case 1:
        {
            [filterView setHidden:YES];
            [musicView setHidden:NO];
            if (![musicView isLoadData]) {
                if ([self.delegate respondsToSelector:@selector(requestMusicViewDataSource)]) {
                    [self.delegate requestMusicViewDataSource];
                }
            }
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
#pragma -mark URFilterViewProtocol
-(void)selectFilter:(FilterInfo *)info
{
    if ([self.delegate respondsToSelector:@selector(didSelectFilter:)]) {
        [self.delegate didSelectFilter:info];
    }
}

#pragma -mark URMusicViewProtocol
-(void)selectMusic:(MusicInfo *)info
{
    if ([self.delegate respondsToSelector:@selector(didSelectMusic:)]) {
        [self.delegate didSelectMusic:info];
    }
}
@end
