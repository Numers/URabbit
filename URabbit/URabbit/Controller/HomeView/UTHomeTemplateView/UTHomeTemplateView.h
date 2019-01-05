//
//  UTHomeTemplateView.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/4.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeTemplate;
@protocol HomeTemplateViewProtocol <NSObject>
-(void)updateViewHeight:(CGFloat)height identify:(id)identify;
-(void)selectHomeTemplate:(HomeTemplate *)homeTemplate;
-(void)gotoCategoryView;
@end
@interface UTHomeTemplateView : UIView
@property(nonatomic, weak) id<HomeTemplateViewProtocol> delegate;
-(void)setHeadImage:(UIImage *)image headTitle:(NSString *)title viewIdentify:(id)identify;
-(void)setDatasource:(NSArray *)datasource;
@end
