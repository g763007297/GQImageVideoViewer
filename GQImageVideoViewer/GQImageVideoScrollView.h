//
//  GQImageVideoScrollView.h
//  GQImageVideoViewerDemo
//
//  Created by 高旗 on 16/9/12.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GQBaseImageVideoModel.h"

@interface GQImageVideoScrollView : UIScrollView

@property (nonatomic, copy) GQBaseImageVideoModel *data;

@property(nonatomic,assign) NSInteger row;

@property (nonatomic, copy) UIImage *placeholderImage;

//暂停展示视频画面
- (void)stopDisplay;

//开始展示视频画面
- (void)beginDisplay;

@end