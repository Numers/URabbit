//
//  UTFilterView.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/8.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTFilterView.h"
#import "UTFilterCollectionViewCell.h"
#import "FilterInfo.h"
#import "PSTCollectionView.h"
static NSString *filterCollectionViewCellIdentify = @"FilterCollectionViewCellIdentify";
@interface UTFilterView()<PSTCollectionViewDelegate,PSTCollectionViewDataSource,PSTCollectionViewDelegateFlowLayout>
{
    NSMutableArray *dataSource;
    PSTCollectionView *collectionView;
    NSInteger selectIndex;
}
@end
@implementation UTFilterView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:YES];
        
        PSTCollectionViewFlowLayout *layout = [[PSTCollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        collectionView = [[PSTCollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 76) collectionViewLayout:layout];
        [collectionView registerClass:[UTFilterCollectionViewCell class] forCellWithReuseIdentifier:filterCollectionViewCellIdentify];
        [collectionView setContentInset:UIEdgeInsetsMake(0, 15, 0, 15)];
        [collectionView setBounces:NO];
        [collectionView setShowsVerticalScrollIndicator:NO];
        [collectionView setShowsHorizontalScrollIndicator:NO];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView setBackgroundColor:[UIColor clearColor]];
        [collectionView setCenter:CGPointMake(frame.size.width / 2, frame.size.height / 2)];
        [self addSubview:collectionView];
        
        dataSource = [NSMutableArray array];
    }
    return self;
}

-(void)setFilterList:(NSMutableArray *)list
{
    if (dataSource.count > 0) {
        [dataSource removeAllObjects];
    }
    selectIndex = 0;
    [dataSource addObjectsFromArray:list];
    [collectionView reloadData];
    [collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:selectIndex inSection:0] animated:NO scrollPosition:PSTCollectionViewScrollPositionCenteredHorizontally];
}

#pragma -mark UICollectionViewDataSource | UICollectionViewDelegateFlowLayout
- (NSInteger)numberOfSectionsInCollectionView:(PSTCollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(PSTCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dataSource.count;
}

- (PSTCollectionViewCell *)collectionView:(PSTCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UTFilterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:filterCollectionViewCellIdentify forIndexPath:indexPath];
    if (selectIndex == indexPath.row) {
        [cell setIsSelected:YES];
    }else{
        [cell setIsSelected:NO];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        FilterInfo *info = [dataSource objectAtIndex:indexPath.row];
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell setupCellWithFilterInfo:info];
        });
    });
    return cell;
}

- (CGFloat)collectionView:(PSTCollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 8.0f;
}

- (CGFloat)collectionView:(PSTCollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (UIEdgeInsets)collectionView:(PSTCollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(PSTCollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(50.0f,76.0f);
}

-(void)collectionView:(PSTCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectIndex == indexPath.row) {
        return;
    }
    
    UTFilterCollectionViewCell *cell = (UTFilterCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setIsSelected:YES];
    selectIndex = indexPath.row;
    FilterInfo *info = [dataSource objectAtIndex:selectIndex];
    if ([self.delegate respondsToSelector:@selector(selectFilter:)]) {
        [self.delegate selectFilter:info];
    }
}

-(void)collectionView:(PSTCollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UTFilterCollectionViewCell *cell = (UTFilterCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell setIsSelected:NO];
}
@end
