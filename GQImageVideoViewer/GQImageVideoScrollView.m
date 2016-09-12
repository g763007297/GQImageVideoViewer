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
    GQBaseImageView *_imageView;
    GQBaseVideoView *_videoView;
}

@end

@implementation GQImageVideoScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _imageView = [[GQBaseImageView alloc] initWithFrame:self.bounds];
        self.backgroundColor = [UIColor clearColor];
        //让图片等比例适应图片视图的尺寸
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
        
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
        
        _videoView = [[GQBaseVideoView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:_videoView];
    }
    return self;
}

- (void)stopDisplay{
    [_videoView puase];
}

- (void)beginDisplay{
    if ([_data isKindOfClass:[NSURLRequest class]]) {
        [_videoView setItem:((NSURLRequest *)_data).URL];
    }
}

- (void)setData:(id)data
{
    _data = [data copy];
    if ([data isKindOfClass:[UIImage class]])
    {
        [_videoView setHidden:YES];
        _imageView.image = data;
    }else if ([data isKindOfClass:[NSString class]]||[data isKindOfClass:[NSURL class]])
    {
        [_videoView setHidden:YES];
        NSURL *imageUrl = data;
        if ([data isKindOfClass:[NSString class]]) {
            imageUrl = [NSURL URLWithString:data];
        }
        [_imageView cancelCurrentImageRequest];
        [_imageView loadImage:imageUrl placeHolder:_placeholderImage complete:nil];
    }else if ([data isKindOfClass:[UIImageView class]])
    {
        [_videoView setHidden:YES];
        UIImageView *imageView = (UIImageView *)data;
        _imageView.image = imageView.image;
    }else
    {
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

@end
