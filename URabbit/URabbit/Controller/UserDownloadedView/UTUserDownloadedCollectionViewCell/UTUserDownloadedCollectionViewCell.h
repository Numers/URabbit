//
//  UTUserDownloadedCollectionViewCell.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/25.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoadedTemplate;
@interface UTUserDownloadedCollectionViewCell : UICollectionViewCell
{
    UIImageView *templateImageView;
    UILabel *nameLabel;
}
-(void)setupCellWithLoadedTemplate:(LoadedTemplate *)loadedTemplate;
@end
