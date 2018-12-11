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
-(void)openImagePickerViewFromView:(UTPhotoEditView *)view scale:(CGFloat)scale;
-(void)scrollToIndexPath:(NSIndexPath *)indexPath fromIndex:(NSIndexPath *)fromIndexPath;
@end
@interface UTMiddleEditContainerView : UIView
{
    NSMutableArray *dataSource;
    UIScrollView *scrollView;
    NSMutableArray *cells;
    TemplateStyle currentStyle;
}
@property(nonatomic, weak) id<UTMiddleEditContainerViewProtocol> delegate;
@property(nonatomic) BOOL isGenerateData;
-(instancetype)initWithSnapshots:(NSMutableArray *)snapshots style:(TemplateStyle)style;
-(void)generateEditViews;
-(void)scrollToIndexPath:(NSIndexPath *)indexPath;
-(UIImage *)deSelectIndexPath:(NSIndexPath *)indexPath;
-(void)generateImagesToCompose;
@end
