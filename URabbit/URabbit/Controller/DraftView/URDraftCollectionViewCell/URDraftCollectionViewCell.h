//
//  URDraftCollectionViewCell.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/27.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DraftTemplate;
@interface URDraftCollectionViewCell : UICollectionViewCell
{
    UIImageView *templateImageView;
    UILabel *nameLabel;
}
-(void)setupCellWithDraftTemplate:(DraftTemplate *)draftTemplate;
@end
