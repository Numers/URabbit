//
//  UTVideoAuthorView.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/5.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeTemplate;
@interface UTVideoAuthorView : UIView
{
    HomeTemplate *currentHomeTemplate;
    UIImageView *headImageView;
    UILabel *authorNameLabel;
    
    UIImageView *nextImageView;
}
-(instancetype)initWithHomeTemplate:(HomeTemplate *)homeTemplate frame:(CGRect)frame;
@end
