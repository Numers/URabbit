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
    
    UIView *chooseHeaderView;
    UIImageView *chooseHeadImageView;
    UILabel *chooseHeadLabel;
    UIButton *categoryButton;
    
    UICollectionView *collectionView;
    
    NSMutableArray *dataSource;
}
@end
@implementation UTHomeRecommendView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorFromHexString:@"#F0F1F3"]];
        dataSource = [NSMutableArray array];
        headerView = [[UIView alloc] init];
        [headerView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:headerView];
        
        headImageView = [[UIImageView alloc] init];
        [headerView addSubview:headImageView];
        
        headLabel = [[UILabel alloc] init];
        [headLabel setFont:[UIFont systemFontOfSize:16]];
        [headLabel setTextColor:[UIColor colorFromHexString:@"#333333"]];
        [headerView addSubview:headLabel];
        
        chooseHeaderView = [[UIView alloc] init];
        [chooseHeaderView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:chooseHeaderView];
        
        chooseHeadImageView = [[UIImageView alloc] init];
        [chooseHeadImageView setImage:[UIImage imageNamed:@"jingxuan"]];
        [chooseHeaderView addSubview:chooseHeadImageView];
        
        chooseHeadLabel = [[UILabel alloc] init];
        [chooseHeadLabel setFont:[UIFont systemFontOfSize:16]];
        [chooseHeadLabel setText:@"精选模板"];
        [chooseHeadLabel setTextColor:[UIColor colorFromHexString:@"#333333"]];
        [chooseHeaderView addSubview:chooseHeadLabel];
        
        categoryButton = [[UIButton alloc] init];
        [categoryButton addTarget:self action:@selector(clickCategoryButton) forControlEvents:UIControlEventTouchUpInside];
        [categoryButton setImage:[UIImage imageNamed:@"nextIconImage"] forState:UIControlStateNormal];
        [categoryButton setTitle:@"全部" forState:UIControlStateNormal];
        [categoryButton setTitleColor:[UIColor colorFromHexString:@"#B4B4B4"] forState:UIControlStateNormal];
        [categoryButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [chooseHeaderView addSubview:categoryButton];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
        [collectionView registerClass:[UTHomeRecommendCollectionViewCell class] forCellWithReuseIdentifier:homeRecommendCollectionViewCellIdentify];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView setBackgroundColor:[UIColor whiteColor]];
        [collectionView setShowsHorizontalScrollIndicator:NO];
        [collectionView setShowsVerticalScrollIndicator:NO];
        [collectionView setContentInset:UIEdgeInsetsMake(0, 5, 25, 15)];
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
        make.height.equalTo(@(117.0f));
    }];
    
    [chooseHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(collectionView.mas_bottom).offset(8);
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.height.equalTo(@(50));
    }];
    
    [chooseHeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(chooseHeaderView).offset(15);
        make.centerY.equalTo(chooseHeaderView.centerY);
        make.width.equalTo(@(14));
        make.height.equalTo(@(14));
    }];
    
    [chooseHeadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(chooseHeadImageView.trailing).offset(7);
        make.centerY.equalTo(chooseHeaderView.centerY);
    }];
    
    [categoryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(chooseHeaderView.mas_trailing).offset(15);
        make.top.equalTo(chooseHeaderView.mas_top);
        make.bottom.equalTo(chooseHeaderView.mas_bottom);
        make.width.equalTo(@(100));
    }];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [categoryButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -categoryButton.imageView.image.size.width - 3, 0,  categoryButton.imageView.image.size.width + 3)];
    [categoryButton setImageEdgeInsets:UIEdgeInsetsMake(0,  categoryButton.titleLabel.bounds.size.width + 3, 0, -categoryButton.titleLabel.bounds.size.width + 3)];
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

-(void)clickCategoryButton
{
    if ([self.delegate respondsToSelector:@selector(gotoCategoryViewWithIndex:)]) {
        [self.delegate gotoCategoryViewWithIndex:0];
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
