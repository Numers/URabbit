//
//  UTHomeRecommendView.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/4.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UTHomeRecommendViewProtocl <NSObject>
-(void)gotoCategoryViewWithIndex:(NSInteger)index;
@end
@interface UTHomeRecommendView : UICollectionReusableView
@property(nonatomic, weak) id<UTHomeRecommendViewProtocl> delegate;
-(void)setHeadImage:(UIImage *)image headTitle:(NSString *)title;
-(void)setDatasource:(NSArray *)datasource;
@end
