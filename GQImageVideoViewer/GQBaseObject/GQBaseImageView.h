//
//  GQImageView.h
//  GQImageVideoViewerDemo
//
//  Created by 高旗 on 16/9/12.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GQImageCompletionBlock)(UIImage *image, NSError *error, NSURL *imageUrl);

@interface GQBaseImageView : UIImageView

@property (nonatomic,strong) NSURL *imageUrl;

/**
 配置图片显示界面
 */
- (void)configureImageView;

- (void)loadImage:(NSURL*)url complete:(GQImageCompletionBlock)complete;
- (void)loadImage:(NSURL*)url placeHolder:(UIImage *)placeHolderImage complete:(GQImageCompletionBlock)complete;
- (void)cancelCurrentImageRequest;     //caller must call this method in its dealloc method

@end
