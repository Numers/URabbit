//
//  URHomeRecommendView.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/4.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol URHomeRecommendViewProtocl <NSObject>
-(void)gotoCategoryViewWithIndex:(NSInteger)index;
@end
@interface URHomeRecommendView : UICollectionReusableView
@property(nonatomic, weak) id<URHomeRecommendViewProtocl> delegate;
-(void)setHeadImage:(UIImage *)image headTitle:(NSString *)title;
-(void)setDatasource:(NSArray *)datasource;
@end
