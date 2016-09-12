//
//  GQImageVideoScrollView.h
//  GQImageVideoViewerDemo
//
//  Created by 高旗 on 16/9/12.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GQImageVideoScrollView : UIScrollView

@property (nonatomic, retain) id data;

@property(nonatomic,assign) NSInteger row;

@property (nonatomic, copy) UIImage *placeholderImage;

//暂停播放
- (void)stopDisplay;

//开始播放
- (void)beginDisplay;

@end