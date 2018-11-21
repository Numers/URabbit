//
//  UTMiddleEditContainerView.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/6.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTMiddleEditContainerView.h"
#import "UTPhotoEditCollectionViewCell.h"
#import "Snapshot.h"

static NSString *photoEditCollectionViewCellIdentify = @"PhotoEditCollectionViewCellIdentify";
@interface UTMiddleEditContainerView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,UTPhotoEditCollectionViewCellProtocol>
{
    int scrollPage;
}
@end
@implementation UTMiddleEditContainerView
-(instancetype)initWithSnapshots:(NSMutableArray *)snapshots style:(TemplateStyle)style
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        dataSource = snapshots;
        currentStyle = style;
        cells = [NSMutableArray array];
        scrollPage = 0;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [collectionView registerClass:[UTPhotoEditCollectionViewCell class] forCellWithReuseIdentifier:photoEditCollectionViewCellIdentify];
        [collectionView setBackgroundColor:[UIColor clearColor]];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView setPagingEnabled:YES];
        [self addSubview:collectionView];
        [self makeConstraints];
    }
    return self;
}

-(void)makeConstraints
{
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.bottom.equalTo(self);
    }];
}

-(void)scrollToIndexPath:(NSIndexPath *)indexPath
{
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

-(void)deSelectIndexPath:(NSIndexPath *)indexPath
{
    UTPhotoEditCollectionViewCell *cell = (UTPhotoEditCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell tranferViewToImage];
}

-(void)generateImagesToCompose
{
    for (NSInteger i = 0; i< dataSource.count; i++) {
        if (i < cells.count) {
            UTPhotoEditCollectionViewCell *cell = (UTPhotoEditCollectionViewCell *)[cells objectAtIndex:i];
            [cell dowithEditViewSnapshotMedia];
        }
    }
}
#pragma -mark UICollectionViewDataSource | UICollectionViewDelegateFlowLayout
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UTPhotoEditCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoEditCollectionViewCellIdentify forIndexPath:indexPath];
    if (![cells containsObject:cell]) {
        [cells addObject:cell];
    }
    cell.delegate = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        Snapshot *info = [dataSource objectAtIndex:indexPath.row];
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell setupCellWithSnapshot:info style:currentStyle];
        });
    });
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.frame.size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.x;
    int page = offset / self.frame.size.width;
    if (page != scrollPage) {
        if ([self.delegate respondsToSelector:@selector(scrollToIndexPath:fromIndex:)]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:page inSection:0];
            NSIndexPath *fromIndexPath = [NSIndexPath indexPathForRow:scrollPage inSection:0];
            UTPhotoEditCollectionViewCell *cell = (UTPhotoEditCollectionViewCell *)[collectionView cellForItemAtIndexPath:fromIndexPath];
            [cell tranferViewToImage];
            [self.delegate scrollToIndexPath:indexPath fromIndex:fromIndexPath];
        }
        scrollPage = page;
    }
}

#pragma -mark UTPhotoEditCollectionViewCellProtocol
-(void)openImagePickerViewFromView:(UTPhotoEditView *)view
{
    if ([self.delegate respondsToSelector:@selector(openImagePickerViewFromView:)]) {
        [self.delegate openImagePickerViewFromView:view];
    }
}
@end
