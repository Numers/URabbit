//
//  URPlayView.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/7.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "URPlayView.h"
#import "URPlayCollectionViewCell.h"

static NSString *playCollectionViewCellIdentify = @"PlayCollectionViewCellIdentify";
@interface URPlayView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@end
@implementation URPlayView
-(instancetype)init
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:YES];
        dataSource = [NSMutableArray array];
        playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [playButton setImage:[UIImage imageNamed:@"play_button"] forState:UIControlStateNormal];
        [playButton addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:playButton];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [collectionView registerClass:[URPlayCollectionViewCell class] forCellWithReuseIdentifier:playCollectionViewCellIdentify];
        [collectionView setContentInset:UIEdgeInsetsMake(0, SCREEN_WIDTH / 2 - 74, 0, SCREEN_WIDTH / 2)];
        [collectionView setBounces:NO];
        [collectionView setShowsVerticalScrollIndicator:NO];
        [collectionView setShowsHorizontalScrollIndicator:NO];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:collectionView];
        
        whiteLine = [[UIView alloc] init];
        [whiteLine setBackgroundColor:[UIColor colorFromHexString:@"#999999"]];
        [self addSubview:whiteLine];
        [self makeConstraints];
    }
    return self;
}

-(void)makeConstraints
{
    [playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.leading.equalTo(self);
        make.width.equalTo(@(74));
    }];
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(playButton.trailing);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.trailing.equalTo(self);
    }];
    
    [whiteLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.centerX.equalTo(self.centerX);
        make.width.equalTo(@(2));
    }];
}

-(void)setDatasource:(NSMutableArray *)images
{
    if (dataSource.count > 0) {
        [dataSource removeAllObjects];
    }
    [dataSource addObjectsFromArray:images];
    [collectionView reloadData];
}

-(void)play
{
    BOOL status = !isPlaying;
    [self setIsPlaying:status];
    if ([self.delegate respondsToSelector:@selector(playStatusChanged:)]) {
        [self.delegate playStatusChanged:status];
    }
}

-(void)setIsPlaying:(BOOL)playing
{
    isPlaying = playing;
    if (isPlaying) {
        [playButton setImage:[UIImage imageNamed:@"pause_button"] forState:UIControlStateNormal];
    }else{
        [playButton setImage:[UIImage imageNamed:@"play_button"] forState:UIControlStateNormal];
    }
}

-(void)playFinished
{
    [self setIsPlaying:NO];
}

-(void)scrollToOffsetPercent:(CGFloat)percent
{
    if (!isPlaying) {
        [self setIsPlaying:YES];
    }
    CGFloat contentSize = [collectionView contentSize].width;
    CGFloat offset = contentSize * percent - collectionView.contentInset.left;
    [collectionView setContentOffset:CGPointMake(offset, 0) animated:NO];
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
    URPlayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:playCollectionViewCellIdentify forIndexPath:indexPath];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *img = [dataSource objectAtIndex:indexPath.row];
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell setupCellWithImage:img];
        });
    });
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UIImage *img = [dataSource objectAtIndex:indexPath.row];
    CGFloat height = 43.0f;
    CGFloat width =  (height-10) * (img.size.width / img.size.height);
    return CGSizeMake(width,height);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!isDragging) {
        return;
    }
    CGFloat offsetX = [scrollView contentOffset].x + scrollView.contentInset.left;
    if (offsetX > 0) {
        CGFloat contentSize = [scrollView contentSize].width;
        CGFloat percent = offsetX / contentSize;
        if ([self.delegate respondsToSelector:@selector(dragScrollPercentage:)]) {
            [self.delegate dragScrollPercentage:percent];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    isDragging = YES;
    [self setIsPlaying:NO];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        isDragging = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    isDragging = NO;
}
@end
