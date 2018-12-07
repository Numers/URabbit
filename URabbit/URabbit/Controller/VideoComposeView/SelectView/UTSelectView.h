//
//  UTSelectView.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/7.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UTFilterView.h"
#import "UTMusicView.h"
@protocol UTSelectViewProtocol <NSObject>
-(NSMutableArray *)requestFilterViewDataSource;
-(NSMutableArray *)requestMusicViewDataSource;
-(void)didSelectFilter:(FilterInfo *)info;
-(void)didSelectMusic:(MusicInfo *)info;
@end
@interface UTSelectView : UIView<UTFilterViewProtocol,UTMusicViewProtocol>
{
    UTFilterView *filterView;
    UTMusicView *musicView;
}
@property(nonatomic, weak) id<UTSelectViewProtocol> delegate;
-(void)showViewWithIndex:(NSInteger)index;
-(void)setMusicList:(NSMutableArray *)list;
-(void)setFilterList:(NSMutableArray *)list;
@end
