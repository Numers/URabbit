//
//  URMusicView.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/22.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MusicInfo;
@protocol URMusicViewProtocol <NSObject>
-(void)selectMusic:(MusicInfo *)info;
@end
@interface URMusicView : UIView
@property(nonatomic) BOOL isLoadData;
@property(nonatomic, weak) id<URMusicViewProtocol> delegate;
-(void)setMusicList:(NSMutableArray *)list;
@end
