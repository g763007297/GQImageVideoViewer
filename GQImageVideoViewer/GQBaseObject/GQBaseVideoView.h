//
//  GQBaseVideoView.h
//  GQImageVideoViewerDemo
//
//  Created by 高旗 on 16/9/12.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef enum : NSUInteger {
    GQBaseVideoViewStateConfigure,//配置状态
    GQBaseVideoViewStateBuffer,//缓冲状态
    GQBaseVideoViewStateReadyToPlay,//准备播放状态
    GQBaseVideoViewStatePlaying,//播放状态
    GQBaseVideoViewStateStop,//停止状态
    GQBaseVideoViewStatePuase,//暂停状态
    GQBaseVideoViewStateFail,//播放失败
} GQBaseVideoViewState;

@interface GQBaseVideoView : UIView

@property (nonatomic, strong) NSURL *item;

@property (nonatomic, strong, readonly) AVPlayerItem *playerItem;

@property (nonatomic, strong, readonly) AVPlayer *player;//播放器

/**
 视频播放状态
 */
@property (nonatomic, assign) GQBaseVideoViewState state;

/**
 自定义配置播放面板
 */
- (void)configureVideoView;

/**
 *  暂停
 */
- (void)puase;

/**
 切换
 */
- (void)replace;

/**
 播放
 */
- (void)play;

/**
 *  停止播放
 */
- (void)stop;

@end
