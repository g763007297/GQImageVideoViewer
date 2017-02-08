//
//  GQImageVideoScrollView.m
//  GQImageVideoViewerDemo
//
//  Created by 高旗 on 16/9/12.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQImageVideoScrollView.h"
#import "GQImageVideoViewer.h"
#import "GQBaseImageView.h"
#import "GQBaseVideoView.h"

#import "GQImageCacheManager.h"

#import "GQImageVideoViewerConst.h"

@interface GQImageVideoScrollView()<UIScrollViewDelegate>{
    NSURL           *_currentUrl;
    BOOL            _isAddSubView;
}

@property (nonatomic, strong) GQBaseImageView *imageView;
@property (nonatomic, strong) GQBaseVideoView *videoView;

@end

@implementation GQImageVideoScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        _isAddSubView = NO;
        
        //设置最大放大倍数
        self.maximumZoomScale = 3.0;
        self.minimumZoomScale = 1.0;
        
        //隐藏滚动条
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        self.delegate = self;
        
        //单击手势
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap1];
        
        //双击放大缩小手势
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        //双击
        tap2.numberOfTapsRequired = 2;
        //手指的数量
        tap2.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tap2];
        
        //tap1、tap2两个手势同时响应时，则取消tap1手势
        [tap1 requireGestureRecognizerToFail:tap2];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.zoomScale == 1) {
        _videoView.frame = self.bounds;
        _imageView.frame = self.bounds;
    }
}

- (void)stopDisplay
{
    [_videoView replace];
}

- (void)beginDisplay
{
    if (_currentUrl&&!_data.GQIsImageURL)
    {
        [_videoView setItem:_currentUrl];
    }
}

- (void)setData:(GQBaseImageVideoModel *)data
{
    _data = [data copy];
    if (!_isAddSubView) {
        [self addSubview:self.videoView];
        [self addSubview:self.imageView];
        _isAddSubView = YES;
    }
    id urlString = _data.GQURLString;
    UIImage *image = nil;
    _currentUrl = nil;
    if ([urlString isKindOfClass:[UIImage class]])
    {
        image = urlString;
    }else if ([urlString isKindOfClass:[NSString class]]||[urlString isKindOfClass:[NSURL class]])
    {
        _currentUrl = urlString;
        if ([urlString isKindOfClass:[NSString class]]) {
            _currentUrl = [NSURL URLWithString:urlString];
        }
    }else if ([urlString isKindOfClass:[UIImageView class]])
    {
        UIImageView *imageView = (UIImageView *)urlString;
        image = imageView.image;
    }
    if (_data.GQIsImageURL) {
        [_videoView setHidden:YES];
        if (_currentUrl) {
            [_imageView cancelCurrentImageRequest];
            [_imageView loadImage:_currentUrl placeHolder:_placeholderImage complete:nil];
        }else if(image){
            _imageView.image = image;
        }else{
            _imageView.image = nil;
        }
    }else{
        _imageView.image = nil;
        [_videoView setHidden:NO];
    }
}

#pragma mark - UIScrollView delegate
//返回需要缩放的子视图
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    if (tap.numberOfTapsRequired == 1)
    {
        [_imageView cancelCurrentImageRequest];
        [[GQImageVideoViewer sharedInstance] dissMiss];
    }
    else if(tap.numberOfTapsRequired == 2)
    {
        if (self.zoomScale > 1)
        {
            [self setZoomScale:1 animated:YES];
        } else
        {
            [self setZoomScale:3 animated:YES];
        }
    }
}

- (void)dealloc
{
    [[GQImageCacheManager sharedManager] clearMemoryCache];
    [_videoView stop];
    [_imageView cancelCurrentImageRequest];
    _imageView = nil;
    _videoView = nil;
}

- (GQBaseImageView *)imageView {
    if (!_imageView) {
        _imageView = [[NSClassFromString(_data.GQImageViewClassName) alloc] initWithFrame:self.bounds];
        //让图片等比例适应图片视图的尺寸
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (GQBaseVideoView *)videoView {
    if (!_videoView) {
        _videoView = [[NSClassFromString(_data.GQVideoViewClassName) alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }
    return _videoView;
}

@end
