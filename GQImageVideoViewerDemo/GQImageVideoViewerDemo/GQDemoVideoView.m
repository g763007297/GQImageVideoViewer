//
//  GQDemoVideoView.m
//  GQImageVideoViewerDemo
//
//  Created by tusm on 17/2/8.
//  Copyright © 2017年 gaoqi. All rights reserved.
//

#import "GQDemoVideoView.h"

@interface GQDemoVideoView()

@property (nonatomic, strong) UIButton *button;

@end

@implementation GQDemoVideoView

- (void)configureVideoView {
    [self addSubview:self.button];
}

- (void)buttonAction:(id)sender {
    if (self.state == GQBaseVideoViewStatePlaying) {
        [self puase];
    }else {
        [self play];
    }
}

#pragma mark -- lazy load

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-150)/2, 20, 150, 30);
        [_button setBackgroundColor:[UIColor yellowColor]];
        [_button setTitle:@"点击播放暂停" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

@end
