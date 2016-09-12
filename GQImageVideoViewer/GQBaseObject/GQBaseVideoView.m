//
//  GQBaseVideoView.m
//  GQImageVideoViewerDemo
//
//  Created by 高旗 on 16/9/12.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQBaseVideoView.h"
#import "GQImageVideoViewerConst.h"

@interface GQBaseVideoView(){
    NSString *currentUrlString;
}

@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) AVPlayerItem *playerItem;

@end

@implementation GQBaseVideoView

GQ_DYNAMIC_PROPERTY_BOOL(isExitObserver, setIsExitObserver);

#pragma mark -- privateMethod

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        _player = [AVPlayer playerWithPlayerItem:[AVPlayerItem playerItemWithURL:[NSURL URLWithString:@""]]];
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        [self.layer addSublayer:_playerLayer];
    }
    return self;
}

- (void)addObserver
{
    if (![self isExitObserver]&&self.superview)
    {
        //KVO
        [self setIsExitObserver:YES];
        [_playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [_player addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * note) {
            [_player seekToTime:kCMTimeZero];
            [_player play];
        }];
    }
}

- (void)removeObserver
{
    if ([self isExitObserver])
    {
        [self setIsExitObserver:NO];
        [_playerItem removeObserver:self forKeyPath:@"status"];
        [_player removeObserver:self forKeyPath:@"status"];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
        self.playerItem = nil;
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    self.frame = newSuperview.bounds;
    _playerLayer.frame = newSuperview.bounds;
}

- (void)removeFromSuperview{
    [self removeObserver];
    [super removeFromSuperview];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]&&object == _playerItem) {
        AVPlayerItemStatus status = _playerItem.status;
        switch (status) {
            case AVPlayerItemStatusReadyToPlay:
            {
                if (_player.status == AVPlayerStatusReadyToPlay) {
                    [self hideLoading];
                }
                if (_player) {
                    [_player play];
                }
                break;
            }
            case AVPlayerItemStatusFailed:
            {
                [self hideLoading];
                break;
            }
            default:
                break;
        }
    }else if ([keyPath isEqualToString:@"status"]&&object == _player){
        AVPlayerStatus stadus = _player.status;
        switch (stadus) {
            case AVPlayerStatusFailed:{
                [self hideLoading];
                break;
            }
            case AVPlayerStatusReadyToPlay:{
                if (_playerItem.status == AVPlayerItemStatusReadyToPlay) {
                    [self hideLoading];
                }
                break;
            }
            default:
                break;
        }
    }
}

- (void)dealloc
{
    [self hideLoading];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    self.player = nil;
    self.playerLayer = nil;
}

#pragma mark -- publicMethod

- (void)puase
{
    [self hideLoading];
    [self.player seekToTime:kCMTimeZero];
    [self.player pause];
}

- (void)stop
{
    [self hideLoading];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    [self removeObserver];
}

#pragma mark -- set get method

- (void)setItem:(NSURL *)item
{
    if ([currentUrlString isEqualToString:item.absoluteString]&&_player.currentItem) {
        if (_playerItem.status == AVPlayerItemStatusReadyToPlay) {
            [_player play];
            return;
        }
    }else{
        [self showLoading];
        currentUrlString = item.absoluteString;
        _item = [item copy];
        [self removeObserver];
        _playerItem = [[AVPlayerItem alloc] initWithURL:item];
        [self.player replaceCurrentItemWithPlayerItem:_playerItem];
        [self addObserver];
    }
}

-(void)showLoading
{
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _indicator.center = CGPointMake(self.bounds.origin.x+(self.bounds.size.width/2), self.bounds.origin.y+(self.bounds.size.height/2));
        [_indicator setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin];
    }
    if (!_indicator.isAnimating||_indicator.hidden) {
        _indicator.hidden = NO;
        if(!_indicator.superview){
            [self addSubview:_indicator];
        }
        [_indicator startAnimating];
    }
}

-(void)hideLoading
{
    if (_indicator) {
        [_indicator stopAnimating];
        _indicator.hidden = YES;
    }
}
@end