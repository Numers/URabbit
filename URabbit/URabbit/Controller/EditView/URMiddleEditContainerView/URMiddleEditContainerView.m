//
//  URMiddleEditContainerView.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/6.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "URMiddleEditContainerView.h"
#import "URPhotoEditCollectionViewCell.h"
#import "Snapshot.h"

static NSString *photoEditCollectionViewCellIdentify = @"PhotoEditCollectionViewCellIdentify";
@interface URMiddleEditContainerView()<UIScrollViewDelegate,URPhotoEditCollectionViewCellProtocol>
{
    int scrollPage;
}
@end
@implementation URMiddleEditContainerView
-(instancetype)initWithSnapshots:(NSMutableArray *)snapshots style:(TemplateStyle)style
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        dataSource = snapshots;
        currentStyle = style;
        cells = [NSMutableArray array];
        scrollPage = 0;
        _isGenerateData = NO;
        
        scrollView = [[UIScrollView alloc] init];
        [scrollView setShowsVerticalScrollIndicator:NO];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        scrollView.delegate = self;
        [scrollView setPagingEnabled:YES];
        [self addSubview:scrollView];
        [self makeConstraints];
    }
    return self;
}

-(void)makeConstraints
{
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.bottom.equalTo(self);
    }];
}

-(void)generateEditViews
{
    for (NSInteger i = 0; i<dataSource.count ; i++) {
        URPhotoEditCollectionViewCell *cell = [[URPhotoEditCollectionViewCell alloc] initWithFrame:CGRectMake(i * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
        cell.delegate = self;
        Snapshot *info = [dataSource objectAtIndex:i];
        [cell setupCellWithSnapshot:info style:currentStyle];
        [scrollView addSubview:cell];
        [cells addObject:cell];
    }
    [scrollView setContentSize:CGSizeMake(self.frame.size.width * dataSource.count, self.frame.size.height)];
    _isGenerateData = YES;
}

-(void)scrollToIndexPath:(NSIndexPath *)indexPath
{
    [scrollView setContentOffset:CGPointMake(self.frame.size.width * indexPath.row, 0) animated:NO];
}

-(UIImage *)deSelectIndexPath:(NSIndexPath *)indexPath
{
    UIImage *image = nil;
    if (cells.count > indexPath.row) {
        URPhotoEditCollectionViewCell *cell = (URPhotoEditCollectionViewCell *)[cells objectAtIndex:indexPath.row];
        image = [cell tranferViewToImage];
    }
    return image;
}

-(void)generateImagesToCompose
{
    for (NSInteger i = 0; i< dataSource.count; i++) {
        if (i < cells.count) {
            URPhotoEditCollectionViewCell *cell = (URPhotoEditCollectionViewCell *)[cells objectAtIndex:i];
            [cell dowithEditViewSnapshotMedia];
        }
    }
}

#pragma -mark UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.x;
    int page = offset / self.frame.size.width;
    if (page != scrollPage) {
        if ([self.delegate respondsToSelector:@selector(scrollToIndexPath:fromIndex:)]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:page inSection:0];
            NSIndexPath *fromIndexPath = [NSIndexPath indexPathForRow:scrollPage inSection:0];
            [self.delegate scrollToIndexPath:indexPath fromIndex:fromIndexPath];
        }
        scrollPage = page;
    }
}

#pragma -mark URPhotoEditCollectionViewCellProtocol
-(void)openImagePickerViewFromView:(URPhotoEditView *)view scale:(CGFloat)scale
{
    if ([self.delegate respondsToSelector:@selector(openImagePickerViewFromView:scale:)]) {
        [self.delegate openImagePickerViewFromView:view scale:scale];
    }
}
@end
