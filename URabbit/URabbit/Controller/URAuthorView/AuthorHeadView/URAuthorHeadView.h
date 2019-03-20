//
//  URAuthorHeadView.h
//  URabbit
//
//  Created by 鲍利成 on 2018/12/10.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Author;
@interface URAuthorHeadView : UICollectionReusableView
{
    UIImageView *headImageView;
    UILabel *nickNameLabel;
    UILabel *subjectLabel;
    UILabel *makeLabel;
    UILabel *summaryLabel;
    
    Author *currentAuthor;
}

-(void)setAuthor:(Author *)author;
@end
