//
//  UTDownloadAlertView.h
//  URabbit
//
//  Created by 鲍利成 on 2018/12/10.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UTDownloadAlertViewProtocl <NSObject>
-(void)didComfirm;
@end
@interface UTDownloadAlertView : UIView
{
    UIImageView *vipImageView;
    UILabel *descLabel;
    UIButton *comfirmButton;
    UIButton *closeButton;
    
    UIView *backgroundView;
}
@property(nonatomic, weak) id<UTDownloadAlertViewProtocl> delegate;
-(void)alert;
-(void)dismiss:(void (^)(void))callback;
@end
