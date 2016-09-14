//
//  GQBaseVideoView.m
//  GQImageVideoViewerDemo
//
//  Created by 高旗 on 16/9/12.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQBaseVideoView.h"
#import "GQImageVideoViewerConst.h"

@interface GQBaseVideoView()

@property (nonatomic, strong) UIActivityIndicatorView *indicator;//加载指示器

@property (nonatomic, strong) AVPlayerLayer *playerLayer;//播放视图载体

@property (nonatomic, strong) AVPlayer *player;//播放器

@property (nonatomic, strong) AVPlayerItem *playerItem;//当前播放条

@end

@implementation GQBaseVideoView

GQ_DYNAMIC_PROPERTY_BOOL(isExitObserver, setIsExitObserver);

#pragma mark -- privateMethod

- (instancetype)initWithFrame:(CGRect)frame
{
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

- (void)addObserver
{
    //判断是否已经添加KVO和存在父视图
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]&&object == _playerItem)
    {
        AVPlayerItemStatus status = _playerItem.status;
        switch (status) {
            case AVPlayerItemStatusReadyToPlay:
            {
                //判断_player的status是否是准备播放
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
    }else if ([keyPath isEqualToString:@"status"]&&object == _player)
    {
        AVPlayerStatus stadus = _player.status;
        switch (stadus) {
                //判断_playerItem的status是否为准备播放
            case AVPlayerStatusReadyToPlay:{
                if (_playerItem.status == AVPlayerItemStatusReadyToPlay)
                {
                    [self hideLoading];
                }
                break;
            }
            case AVPlayerStatusFailed:{
                [self hideLoading];
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark -- Object lifecycle

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    self.frame = newSuperview.bounds;
    _playerLayer.frame = newSuperview.bounds;
}

- (void)removeFromSuperview
{
    [self removeObserver];
    [super removeFromSuperview];
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
    //判断之前播放的url地址是否一致
    if ([_item.absoluteString isEqualToString:item.absoluteString]&&_player.currentItem)
    {
        //如果一致并且_playerItem的status是准备播放时就直接播放
        if (_playerItem.status == AVPlayerItemStatusReadyToPlay&&_player.status == AVPlayerStatusReadyToPlay)
        {
            [_player play];
            return;
        }
    }
    _item = [item copy];
    
    [self showLoading];
    
    //移除所有之前的KVO
    [self removeObserver];
    
    //重置_playerItem
    _playerItem = [[AVPlayerItem alloc] initWithURL:_item];
    
    //添加KVO
    [self addObserver];
    
    //替换player的当前播放item
    [self.player replaceCurrentItemWithPlayerItem:_playerItem];
}

@end
