//
//  GQImageVideoTableView.m
//  GQImageVideoViewerDemo
//
//  Created by 高旗 on 16/9/12.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQImageVideoTableView.h"
#import "GQImageVideoScrollView.h"

#import "GQImageVideoViewerConst.h"

@interface GQImageVideoCollectionViewCell : UICollectionViewCell

@end

@implementation GQImageVideoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    GQImageVideoScrollView *photoSV = [[GQImageVideoScrollView alloc] init];
    self.backgroundColor = [UIColor clearColor];
    photoSV.tag = 100;
    [self.contentView addSubview:photoSV];
}

- (void)layoutSubviews {
    GQImageVideoScrollView *photoSV = (GQImageVideoScrollView *)[self.contentView viewWithTag:100];
    photoSV.frame = self.bounds;
}

@end

@interface GQImageVideoTableView()
{
    NSIndexPath *currentIndexPath;
    BOOL isFirstLayout;
}

@end

@implementation GQImageVideoTableView

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(nonnull UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self registerClass:[GQImageVideoCollectionViewCell class] forCellWithReuseIdentifier:@"GQImageVideoScrollViewIdentify"];
        self.pagingEnabled = YES;
    }
    return self;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"GQImageVideoScrollViewIdentify";
    
    GQImageVideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    
    GQImageVideoScrollView *photoSV = (GQImageVideoScrollView *)[cell.contentView viewWithTag:100];
    
    photoSV.data = self.dataArray[indexPath.row];
    
    photoSV.row = indexPath.row;
    
    if (isFirstLayout) {
        isFirstLayout = NO;
        [photoSV beginDisplay];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(nonnull UICollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    GQImageVideoScrollView *photoSV = (GQImageVideoScrollView *)[cell.contentView viewWithTag:100];
    
    [photoSV setZoomScale:1.0 animated:YES];
    
    [photoSV stopDisplay];
}

- (void)scrollToItemAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UICollectionViewScrollPosition)scrollPosition animated:(BOOL)animated {
    [super scrollToItemAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
    //如果不存在currentIndexPath
    if (!currentIndexPath)
    {
        currentIndexPath = indexPath;
    }else if (currentIndexPath != indexPath)//如果currentIndexPath不等于indexPath则停止currentIndexPath的播放
    {
        UICollectionViewCell *cell = [self cellForItemAtIndexPath:currentIndexPath];
        GQImageVideoScrollView *photoSV = (GQImageVideoScrollView *)[cell.contentView viewWithTag:100];
        [photoSV stopDisplay];
        currentIndexPath = indexPath;
    }
    //播放当前indexPath
    UICollectionViewCell *cell = [self cellForItemAtIndexPath:indexPath];
    //如果指定的cell为空则说明是第一次展示，记录第一次
    if (!cell) {
        isFirstLayout = YES;
    }else {
        GQImageVideoScrollView *photoSV = (GQImageVideoScrollView *)[cell.contentView viewWithTag:100];
        [photoSV beginDisplay];
    }
}

@end

