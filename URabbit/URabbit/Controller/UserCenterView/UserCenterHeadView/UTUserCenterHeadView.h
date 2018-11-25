//
//  UTUserCenterHeadView.h
//  URabbit
//
//  Created by Mac on 2018/11/18.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Member;
@protocol UTUserCenterHeadViewProtocol <NSObject>
-(void)gotoLoadedView;
-(void)gotoSaveView;
-(void)gotoDraftView;
-(void)gotoLoginView;
@end
@interface UTUserCenterHeadView : UIView
{
    UIImageView *headImageView;
    UILabel *nickNameLabel;
    UILabel *memberIdLabel;
    
    UIButton *noLoginButton;
    
    UILabel *downloadNumberLabel;
    UILabel *downloadNumberDescLabel;
    
    UILabel *saveNumberLabel;
    UILabel *saveNumberDescLabel;
    
    UILabel *draftNumberLabel;
    UILabel *draftNumberDescLabel;
    
    UIView *line1View;
    UIView *line2View;
    
    UIButton *downloadButton;
    UIButton *saveButton;
    UIButton *draftButton;
}
@property(nonatomic, strong) id<UTUserCenterHeadViewProtocol> delegate;
-(void)setCurrentMember:(Member *)member;
-(void)setSaveNumber:(NSInteger)saveNumber downloadNumber:(NSInteger)downloadNumber draftNumber:(NSInteger)draftNumber;
@end

