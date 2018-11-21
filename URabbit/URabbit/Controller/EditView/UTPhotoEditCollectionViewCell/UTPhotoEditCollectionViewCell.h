//
//  UTPhotoEditCollectionViewCell.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/6.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UTPhotoEditView,Snapshot;
@protocol UTPhotoEditCollectionViewCellProtocol<NSObject>
-(void)openImagePickerViewFromView:(UTPhotoEditView *)view;
@end
@interface UTPhotoEditCollectionViewCell : UICollectionViewCell
{
    Snapshot *currentSnapshot;
    UTPhotoEditView *editView;
    TemplateStyle currentStyle;
}
@property(nonatomic, weak) id<UTPhotoEditCollectionViewCellProtocol> delegate;
-(void)setupCellWithSnapshot:(Snapshot *)snapshot style:(TemplateStyle)style;
-(UIImage *)tranferViewToImage;
-(void)dowithEditViewSnapshotMedia;
@end
