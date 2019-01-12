//
//  UTHomeTemplateView.m
//  URabbit
//
//  Created by 鲍利成 on 2018/11/4.
//  Copyright © 2018年 鲍利成. All rights reserved.
//

#import "UTHomeTemplateView.h"
#import "UTHomeCollectionViewCell.h"
#import "HomeTemplate.h"
#import "LJJWaterFlowLayout.h"
#define HeadViewHeight 50.0f

NSString *homeTemplateCollectionViewCellIdentify = @"HomeTemplateCollectionViewCellIdentify";
@interface UTHomeTemplateView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,LJJWaterFlowLayoutProtocol>
{
    UIView *headerView;
    UIImageView *headImageView;
    UILabel *headLabel;
    UIButton *categoryButton;
    
    UICollectionView *collectionView;
    
    id viewIdentify;
    
    NSMutableArray *dataSource;
}
@end
@implementation UTHomeTemplateView
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
        
        categoryButton = [[UIButton alloc] init];
        [categoryButton addTarget:self action:@selector(clickCategoryButton) forControlEvents:UIControlEventTouchUpInside];
        [categoryButton setImage:[UIImage imageNamed:@"nextIconImage"] forState:UIControlStateNormal];
        [categoryButton setTitle:@"全部" forState:UIControlStateNormal];
        [categoryButton setTitleColor:[UIColor colorFromHexString:@"#B4B4B4"] forState:UIControlStateNormal];
        [categoryButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [headerView addSubview:categoryButton];
        
        LJJWaterFlowLayout *layout = [[LJJWaterFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.layoutDelegate = self;
        collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
        [collectionView registerClass:[UTHomeCollectionViewCell class] forCellWithReuseIdentifier:homeTemplateCollectionViewCellIdentify];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView setScrollEnabled:NO];
        [collectionView setBackgroundColor:[UIColor clearColor]];
        [collectionView setShowsHorizontalScrollIndicator:NO];
        [collectionView setShowsVerticalScrollIndicator:NO];
        [collectionView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [self addSubview:collectionView];
        
        [self makeConstraints];
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [collectionView setFrame:CGRectMake(0, HeadViewHeight, frame.size.width, frame.size.height - HeadViewHeight)];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [categoryButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -categoryButton.imageView.image.size.width - 3, 0,  categoryButton.imageView.image.size.width + 3)];
    [categoryButton setImageEdgeInsets:UIEdgeInsetsMake(0,  categoryButton.titleLabel.bounds.size.width + 3, 0, -categoryButton.titleLabel.bounds.size.width + 3)];
}

-(void)makeConstraints
{
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.top.equalTo(self);
        make.height.equalTo(@(HeadViewHeight));
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
    
    [categoryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(headerView.mas_trailing).offset(15);
        make.top.equalTo(headerView.mas_top);
        make.bottom.equalTo(headerView.mas_bottom);
        make.width.equalTo(@(100));
    }];
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.bottom).offset(0);
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.bottom.equalTo(self);
    }];
}

-(void)setHeadImage:(UIImage *)image headTitle:(NSString *)title viewIdentify:(id)identify
{
    viewIdentify = identify;
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
    if ([self.delegate respondsToSelector:@selector(gotoCategoryView)]) {
        [self.delegate gotoCategoryView];
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
    UTHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:homeTemplateCollectionViewCellIdentify forIndexPath:indexPath];
    [cell setNeedsDisplay];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        HomeTemplate *template = [dataSource objectAtIndex:indexPath.row];
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell setupCellWithHomeTemplate:template];
        });
    });
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 15, 0, 15);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 15.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 15.0f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeTemplate *template = [dataSource objectAtIndex:indexPath.row];
    CGFloat width = (SCREEN_WIDTH - 45) / 2.0f;
    CGFloat ratio = template.videoSize.height / template.videoSize.width;
    CGFloat height = width * ratio + HeadViewHeight;
    return CGSizeMake(width,height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeTemplate *template = [dataSource objectAtIndex:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(selectHomeTemplate:)]) {
        [self.delegate selectHomeTemplate:template];
    }
}

#pragma -mark LJJWaterFlowLayoutProtocol
-(void)calculateCollectionViewContentHeight:(CGFloat)height
{
    if ([self.delegate respondsToSelector:@selector(updateViewHeight:identify:)]) {
        if (height > 0) {
            [self.delegate updateViewHeight:height + HeadViewHeight identify:viewIdentify];
        }
    }
}
@end
