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

@property(nonatomic,assign) NSInteger row;

- (void)puase;

- (void)stop;

@end
