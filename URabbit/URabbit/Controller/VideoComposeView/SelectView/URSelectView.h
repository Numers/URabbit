//
//  URSelectView.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/7.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "URFilterView.h"
#import "URMusicView.h"
@protocol URSelectViewProtocol <NSObject>
-(NSMutableArray *)requestFilterViewDataSource;
-(NSMutableArray *)requestMusicViewDataSource;
-(void)didSelectFilter:(FilterInfo *)info;
-(void)didSelectMusic:(MusicInfo *)info;
@end
@interface URSelectView : UIView<URFilterViewProtocol,URMusicViewProtocol>
{
    URFilterView *filterView;
    URMusicView *musicView;
}
@property(nonatomic, weak) id<URSelectViewProtocol> delegate;
-(void)showViewWithIndex:(NSInteger)index;
-(void)setMusicList:(NSMutableArray *)list;
-(void)setFilterList:(NSMutableArray *)list;
@end
