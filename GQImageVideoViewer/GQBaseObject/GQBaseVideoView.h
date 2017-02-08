//
//  GQBaseVideoView.h
//  GQImageVideoViewerDemo
//
//  Created by 高旗 on 16/9/12.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface GQBaseVideoView : UIView

@property (nonatomic, strong) NSURL *item;

/**
 自定义配置播放面板
 */
- (void)configureVideoView;

/**
 *  暂停
 */
- (void)puase;

/**
 *  停止播放
 */
- (void)stop;

@end
