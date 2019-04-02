//
//  URVideoAuthorView.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/5.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeTemplate;
@protocol URVideoAuthorViewProtocol <NSObject>
-(void)didTapClickAuthorView;
@end
@interface URVideoAuthorView : UIView
{
    HomeTemplate *currentHomeTemplate;
    UIImageView *headImageView;
    UILabel *authorNameLabel;
    
    UIImageView *nextImageView;
}
@property(nonatomic, weak) id<URVideoAuthorViewProtocol> delegate;
-(void)setHomeTemplate:(HomeTemplate *)homeTemplate;
@end
