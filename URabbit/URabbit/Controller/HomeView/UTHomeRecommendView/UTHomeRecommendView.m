//
//  UTHomeRecommendView.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/4.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTHomeRecommendView.h"
#import "UTHomeRecommendCollectionViewCell.h"

static NSString *homeRecommendCollectionViewCellIdentify = @"HomeRecommendCollectionViewCellIdentify";
@interface UTHomeRecommendView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UIView *headerView;
    UIImageView *headImageView;
    UILabel *headLabel;
    
    UICollectionView *collectionView;
    
    NSMutableArray *dataSource;
}
@end
@implementation UTHomeRecommendView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        dataSource = [NSMutableArray array];
        headerView = [[UIView alloc] init];
        [headerView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:headerView];
        
        headImageView = [[UIImageView alloc] init];
        [headerView addSubview:headImageView];
        
        headLabel = [[UILabel alloc] init];
        [headLabel setFont:[UIFont systemFontOfSize:16]];
        [headLabel setTextColor:[UIColor colorFromHexString:@"#333333"]];
        [headerView addSubview:headLabel];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
        [collectionView registerClass:[UTHomeRecommendCollectionViewCell class] forCellWithReuseIdentifier:homeRecommendCollectionViewCellIdentify];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView setBackgroundColor:[UIColor clearColor]];
        [collectionView setShowsHorizontalScrollIndicator:NO];
        [collectionView setShowsVerticalScrollIndicator:NO];
        [collectionView setContentInset:UIEdgeInsetsMake(0, 5, 0, 0)];
        [self addSubview:collectionView];
        
        [self makeConstraints];
    }
    return self;
}


-(void)makeConstraints
{
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.top.equalTo(self);
        make.height.equalTo(@(50));
    }];
    
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(headerView).offset(15);
        make.centerY.equalTo(headerView.centerY);
        make.width.equalTo(@(14));
        make.height.equalTo(@(14));
    }];
    
    [headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(headImageView.trailing).offset(7);
        make.centerY.equalTo(headerView.centerY);
    }];
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.bottom).offset(0);
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.bottom.equalTo(self).offset(-25);
    }];
}

-(void)setHeadImage:(UIImage *)image headTitle:(NSString *)title
{
    [headImageView setImage:image];
    [headLabel setText:title];
}

-(void)setDatasource:(NSArray *)datasource
{
    if (dataSource.count > 0) {
        [dataSource removeAllObjects];
    }
    
    [dataSource addObjectsFromArray:datasource];
    [collectionView reloadData];
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
    UTHomeRecommendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:homeRecommendCollectionViewCellIdentify forIndexPath:indexPath];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        RecommendTemplate *recommend = [dataSource objectAtIndex:indexPath.row];
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell setupWithRecommendTemplate:recommend];
        });
    });
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(92.0f,92.0f);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(gotoCategoryViewWithIndex:)]) {
        [self.delegate gotoCategoryViewWithIndex:indexPath.row];
    }
}
@end
