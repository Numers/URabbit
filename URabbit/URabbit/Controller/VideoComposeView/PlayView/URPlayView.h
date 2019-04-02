//
//  URPlayView.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/7.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UTPlaySubViewProtocol <NSObject>
@optional
-(void)dragScrollPercentage:(CGFloat)percent;
-(void)playStatusChanged:(BOOL)isPlaying;
@end
@interface URPlayView : UIView
{
    UIButton *playButton;
    UIView *whiteLine;
    UICollectionView *collectionView;
    NSMutableArray *dataSource;
    
    BOOL isPlaying;
    BOOL isDragging;
}
@property(nonatomic, weak) id<UTPlaySubViewProtocol> delegate;
-(void)setDatasource:(NSMutableArray *)images;
-(void)scrollToOffsetPercent:(CGFloat)percent;
-(void)playFinished;
@end
