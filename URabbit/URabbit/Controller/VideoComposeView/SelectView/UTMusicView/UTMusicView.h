//
//  UTMusicView.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/22.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MusicInfo;
@protocol UTMusicViewProtocol <NSObject>
-(void)selectMusic:(MusicInfo *)info;
@end
@interface UTMusicView : UIView
@property(nonatomic) BOOL isLoadData;
@property(nonatomic, weak) id<UTMusicViewProtocol> delegate;
-(void)setMusicList:(NSMutableArray *)list;
@end
