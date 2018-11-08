//
//  UTMiddleEditContainerView.h
//  URabbit
//
//  Created by 鲍利成 on 2018/11/6.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UTPhotoEditView;
@protocol UTMiddleEditContainerViewProtocol <NSObject>
-(void)openImagePickerViewFromView:(UTPhotoEditView *)view;
-(void)scrollToIndexPath:(NSIndexPath *)indexPath fromIndex:(NSIndexPath *)fromIndexPath;
@end
@interface UTMiddleEditContainerView : UIView
{
    NSMutableArray *dataSource;
    UICollectionView *collectionView;
}
@property(nonatomic, weak) id<UTMiddleEditContainerViewProtocol> delegate;
-(instancetype)initWithEditInfo:(NSMutableArray *)editInfoList;
-(void)scrollToIndexPath:(NSIndexPath *)indexPath;
-(void)deSelectIndexPath:(NSIndexPath *)indexPath;
-(NSMutableArray *)imagesAxiosToCompose;
@end
