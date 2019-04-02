//
//  URDownloadAlertView.h
//  URabbit
//
//  Created by 鲍利成 on 2018/12/10.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol URDownloadAlertViewProtocl <NSObject>
-(void)didComfirm;
@end
@interface URDownloadAlertView : UIView
{
    UIImageView *vipImageView;
    UILabel *descLabel;
    UIButton *comfirmButton;
    UIButton *closeButton;
    
    UIView *backgroundView;
}
@property(nonatomic, weak) id<URDownloadAlertViewProtocl> delegate;
-(void)setDesctiption:(NSString *)description;
-(void)setLogoImage:(UIImage *)image;
-(void)setButtonTitle:(NSString *)title;
-(void)setContainerViewFrame:(CGRect)rect;
-(void)alert;
-(void)dismiss:(void (^)(void))callback;
@end
