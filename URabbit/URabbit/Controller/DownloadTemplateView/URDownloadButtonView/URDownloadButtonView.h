//
//  URDownloadButtonView.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/5.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol URDownloadButtonViewProtocol<NSObject>
-(void)beginDownload;
@end
@interface URDownloadButtonView : UIView
{
    UIButton *downloadButton;
    UILabel *vipDescLabel;
}
@property(nonatomic, weak) id<URDownloadButtonViewProtocol> delegate;
-(void)setTitle:(NSString *)title isShowVipLabel:(BOOL)isShow;
-(void)setProgress:(CGFloat)progress;
-(void)setButtonTitle:(NSString *)title enable:(BOOL)enable;
@end
