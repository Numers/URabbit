//
//  URPhotoEditCollectionViewCell.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/6.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@class URPhotoEditView,Snapshot;
@protocol URPhotoEditCollectionViewCellProtocol<NSObject>
-(void)openImagePickerViewFromView:(URPhotoEditView *)view scale:(CGFloat)scale;
@end
@interface URPhotoEditCollectionViewCell : UICollectionViewCell
{
    Snapshot *currentSnapshot;
    URPhotoEditView *editView;
    TemplateStyle currentStyle;
}
@property(nonatomic, weak) id<URPhotoEditCollectionViewCellProtocol> delegate;
-(void)setupCellWithSnapshot:(Snapshot *)snapshot style:(TemplateStyle)style;
-(UIImage *)tranferViewToImage;
-(void)dowithEditViewSnapshotMedia;
@end
