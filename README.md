 [![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/angelcs1990/GQImageViewer/master/LICENSE)&nbsp;
[![](https://img.shields.io/badge/platform-iOS-brightgreen.svg)](http://cocoapods.org/?q=GQImageViewer)&nbsp;
[![support](https://img.shields.io/badge/support-iOS6.0%2B-blue.svg)](https://www.apple.com/nl/ios/)&nbsp;
# GQImageVideoViewer
一款仿微信多图片及视频浏览器，图片和视频原尺寸显示，不会变形，双击图片放大缩小，单击消失，支持多张本地和网络图片以及网络视频混合查看，支持链式调用。不需要跳转到新的viewcontroller，就可以覆盖当前控制器显示。

## Overview

![Demo Overview](https://github.com/g763007297/GQImageVideoViewer/blob/master/Screenshot/demo.gif)

##CocoaPods

1.在 Podfile 中添加 pod 'GQImageVideoViewer'。
2.执行 pod install 或 pod update。
3.导入 GQImageVideoViewer.h。

## Basic usage

1.将GQImageVideoViewer文件夹加入到工程中。如果你的工程中有SDWebImage就不需要再添加，如果没有则需要将SDWebImage加入。

2.在需要使用的图片查看器的控制器中#import "GQImageVideoViewer.h"。

3.在需要触发查看器的地方添加以下代码:

注:
< 1 >图片数组中可以放单独的NSString,NSUrl,UIImage,UIImageView，如果是单独放这些类型，则默认为是图片类型。

< 2 >如果需要放视频链接，则需要放字典或者GQBaseImageVideoModel类型，数组的key为以下两个：
(1).GQURLString(链接地址，支持类型为NSUrl和NSString)
(2).GQIsImageURL(是否为图片，如果是图片地址就传YES，如果是视频地址就传NO)。

< 3 >如果需要自定义图片和视频显示画面，则需要分别继承基类:  （分别在两个覆盖的方法中写需要自定义的样式。）
(1).自定义图片显示view:  继承 GQBaseImageView 类，然后在子类中覆盖方法: - (void)configureImageView;
(2).自定义视频显示view:  继承 GQBaseVideoView 类，然后在子类中覆盖方法: - (void)configureVideoView;


```objc

NSMutableArray *imageArray = [[NSMutableArray alloc] initWithCapacity:0];

NSURL *url = [NSURL URLWithString:@"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4"];

[imageArray addObjectsFromArray:@[@{GQIsImageURL:@(NO),
                                        GQURLString:url},
                                      @{GQIsImageURL:@(NO),
                                        GQURLString:[NSURL URLWithString:@"http://192.168.31.152:8080/abc.mp4"]},
                                      @{GQIsImageURL:@(NO),
                                        GQURLString:url},
                                      @{GQIsImageURL:@(YES),
                                        GQURLString:@"http://cdn.cocimg.com/bbs/attachment/upload/30/5811301473150224.gif"},
                                      @{GQIsImageURL:@(YES),
                                        GQURLString:@"http://img0.imgtn.bdimg.com/it/u=513437991,1334115219&fm=206&gp=0.jpg"},
                                      @{GQIsImageURL:@(YES),
                                        GQURLString:@"http://h.hiphotos.baidu.com/image/pic/item/203fb80e7bec54e7f14e9ce2bf389b504ec26aa8.jpg"},
                                      @{GQIsImageURL:@(YES),
                                        GQURLString:@"http://f.hiphotos.baidu.com/image/pic/item/a8014c086e061d9507500dd67ff40ad163d9cacd.jpg"},
                                      @{GQIsImageURL:@(YES)]];


//基本调用
[[GQImageVideoViewer sharedInstance] setImageArray:imageArray];//这是图片和视频数组
[GQImageVideoViewer sharedInstance].usePageControl = YES;//设置是否使用pageControl
[GQImageVideoViewer sharedInstance].selectIndex = 5;//设置选中的图片索引
[GQImageVideoViewer sharedInstance].achieveSelectIndex = ^(NSInteger selectIndex){
    NSLog(@"%ld",selectIndex);
};//获取当前选中的图片索引
[GQImageVideoViewer sharedInstance].laucnDirection = GQLaunchDirectionRight;//设置推出方向
[[GQImageVideoViewer sharedInstance] showInView:self.navigationController.view];//显示GQImageViewer到指定view上

//链式调用
[GQImageVideoViewer sharedInstance]
.imageArrayChain(imageArray)
.usePageControlChain(NO)
.selectIndexChain(6)
.achieveSelectIndexChain(^(NSInteger selectIndex){
    NSLog(@"%ld",selectIndex);
})
.launchDirectionChain(GQLaunchDirectionRight)
.showViewChain(self.navigationController.view);

```

特别说明，如果是拉取网络图片的话，在iOS9以上的系统需要添加plist字段，否则无法拉取图片:

```objc

<key>NSAppTransportSecurity</key>

<dict>

<key>NSAllowsArbitraryLoads</key>

<true/>

</dict>

``` 

## Level history

(1) 0.0.1

github添加代码

(2) 0.0.2

添加model，传图片和视频数组更加方便。

(3) 0.0.3

将tableView替换成collectionView，完美适配屏幕旋转，修复滑动不播放的bug。

(4) 0.0.4

添加自定义图片展示和视频展示功能

(5) wait a moment

##Support

欢迎指出bug或者需要改善的地方，欢迎提出issues，或者联系qq：763007297， 我会及时的做出回应，觉得好用的话不妨给个star吧，你的每个star是我持续维护的强大动力。
