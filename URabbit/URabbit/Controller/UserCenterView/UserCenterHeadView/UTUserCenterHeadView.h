//
//  UTUserCenterHeadView.h
//  URabbit
//
//  Created by Mac on 2018/11/18.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Member;
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
}

-(void)setCurrentMember:(Member *)member;
-(void)setSaveNumber:(NSInteger)saveNumber downloadNumber:(NSInteger)downloadNumber draftNumber:(NSInteger)draftNumber;
@end

