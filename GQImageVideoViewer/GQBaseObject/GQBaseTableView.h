//
//  GQBaseTableView.h
//  GQImageVideoViewerDemo
//
//  Created by 高旗 on 16/9/12.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GQBaseTableView : UICollectionView<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, copy) void (^block)(NSInteger index);

//当前选中的单元格IndexPath
@property(nonatomic,copy) NSIndexPath *selectedInexPath;

@end
