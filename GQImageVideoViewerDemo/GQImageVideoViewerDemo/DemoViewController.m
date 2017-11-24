//
//  DemoViewController.m
//  GQImageVideoViewerDemo
//
//  Created by 高旗 on 16/9/12.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "DemoViewController.h"
#import "GQImageVideoViewer.h"

#import <WebKit/WebKit.h>

@interface DemoViewController ()<WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.visibleViewController.title = @"ImageViewer";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(CGRectGetMaxX(self.view.frame)/2-100, CGRectGetMaxY(self.view.frame)/2+140, 200, 40)];
    [button setTitle:@"点击此处查看图片和视频" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    button.layer.borderColor = [UIColor orangeColor].CGColor;
    button.layer.borderWidth = 1;
    
    button.layer.cornerRadius = 5;
    [button setClipsToBounds:YES];
    
    [button addTarget:self action:@selector(showImageViewer:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    [self.view addSubview:self.webView];
    NSString *string = @"https://v.qq.com/iframe/player.html?vid=g0023ffgekb&tiny=0&auto=0";
//    NSString *HTMLString = [NSString stringWithFormat:@"<iframe frameborder=\"0\" width=\"640\" height=\"498\" src=\"%@\" allowfullscreen></iframe>",string];
//    [self.webView loadHTMLString:HTMLString baseURL:nil];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:string]];
    [self.webView loadRequest:request];
}

- (void)showImageViewer:(id)sender{
    NSMutableArray *imageArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 1; i <11; i ++) {
        NSString *fromPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d.jpg",i] ofType:nil];
        NSData *data = [NSData dataWithContentsOfFile:fromPath];
        [imageArray addObject:@{GQIsImageURL:@(YES),
                                GQURLString:[UIImage imageWithData:data]}];
    }
    NSURL *url = [NSURL URLWithString:@"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4"];
    [imageArray addObjectsFromArray:@[@{GQIsImageURL:@(NO),
                                        GQURLString:[NSURL URLWithString:@"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"]},
                                      @{GQIsImageURL:@(NO),
                                        GQURLString:[NSURL URLWithString:@"http://res.jiuyan.info/in_promo/20160627_meinan/video/tang.mp4"]},
                                      @{GQIsImageURL:@(NO),
                                        GQURLString:url},
                                      @{GQIsImageURL:@(YES),
                                        GQURLString:@"http://cdn.cocimg.com/bbs/attachment/upload/30/5811301473150224.gif"},
                                      @{GQIsImageURL:@(YES),
                                        GQURLString:@"http://img0.imgtn.bdimg.com/it/u=513437991,1334115219&fm=206&gp=0.jpg"},
                                      @{GQIsImageURL:@(YES),
                                        GQURLString:@"http://desk.fd.zol-img.com.cn/t_s960x600c5/g4/M00/0D/01/Cg-4y1ULoXCII6fEAAeQFx3fsKgAAXCmAPjugYAB5Av166.jpg"},
                                      @{GQIsImageURL:@(YES),
                                        GQURLString:@"http://desk.fd.zol-img.com.cn/t_s960x600c5/g5/M00/05/0F/ChMkJ1erCriIJ_opAAY8rSwt72wAAUU6gMmHKwABjzF444.jpgg"},
                                      @{GQIsImageURL:@(YES),
                                        GQURLString:@"http://desk.fd.zol-img.com.cn/t_s960x600c5/g5/M00/02/00/ChMkJ1bKxCSIRtwrAA2uHQvukJIAALHCALaz_UADa41063.jpg"},
                                      @{GQIsImageURL:@(YES),
                                        GQURLString:@"http://game2.1332255.com:80/group1/M00/00/0A/Cj2sWVhYtG6AOE4pAFfzq2lUi7E423.gif"},
                                      @{GQIsImageURL:@(YES),
                                        GQURLString:@"http://desk.fd.zol-img.com.cn/t_s960x600c5/g5/M00/07/0D/ChMkJlgaksOIEZcSAAYHVJbTdlwAAXcSwNDVmYABgds319.jpg"},
                                      @{GQIsImageURL:@(YES),
                                        GQURLString:@"http://desk.fd.zol-img.com.cn/t_s960x600c5/g5/M00/02/03/ChMkJlbKxtqIF93BABJ066MJkLcAALHrQL_qNkAEnUD253.jpg"},
                                      @{GQIsImageURL:@(YES),
                                        GQURLString:@"http://image101.360doc.com/DownloadImg/2016/11/0404/83709873_1.jpg"},
                                      @{GQIsImageURL:@(YES),
                                        GQURLString:@"http://image101.360doc.com/DownloadImg/2016/11/0404/83709873_8.jpg"},
                                      @{GQIsImageURL:@(YES),
                                        GQURLString:@"http://game2.1332255.com:80/group1/M00/00/0A/Cj2sWVhYtGeAQV15ACz1-KrKcsE448.gif"}
                                      ]];
    
//    基本调用
//    [[GQImageVideoViewer sharedInstance] setImageArray:imageArray];
//    [GQImageVideoViewer sharedInstance].usePageControl = YES;
//    [GQImageVideoViewer sharedInstance].selectIndex = 6;
//    [GQImageVideoViewer sharedInstance].achieveSelectIndex = ^(NSInteger selectIndex){
//        NSLog(@"%ld",selectIndex);
//    };
//    [GQImageVideoViewer sharedInstance].laucnDirection = GQLaunchDirectionRight;
//    [[GQImageVideoViewer sharedInstance] showInView:self.navigationController.view];
    
    //    链式调用
    [GQImageVideoViewer sharedInstance]
    .videoViewClassNameChain(@"GQDemoVideoView")
    .dataArrayChain(imageArray)
    .usePageControlChain(YES)
    .selectIndexChain(15)
    .achieveSelectIndexChain(^(NSInteger selectIndex){
        NSLog(@"%zd",selectIndex);
    })
    .launchDirectionChain(GQLaunchDirectionRight)
    .showViewChain(self.navigationController.view);
}

- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *configure = [[WKWebViewConfiguration alloc] init];
        configure.allowsPictureInPictureMediaPlayback = YES;
        configure.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeAll;
        configure.allowsAirPlayForMediaPlayback = YES;
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 60, 320, 300) configuration:configure];
        _webView.navigationDelegate = self;
    }
    return _webView;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    switch (navigationAction.navigationType) {
        case WKNavigationTypeLinkActivated:
            NSLog(@"WKNavigationTypeLinkActivated");
            break;
        case WKNavigationTypeFormSubmitted:
            NSLog(@"WKNavigationTypeFormSubmitted");
            break;
        case WKNavigationTypeOther:
        {
            NSLog(@"WKNavigationTypeOther");
            break;
        }
        case WKNavigationTypeBackForward:
        {
            NSLog(@"WKNavigationTypeBackForward");
            break;
        }
        case WKNavigationTypeReload:
            NSLog(@"WKNavigationTypeReload");
            break;
        case WKNavigationTypeFormResubmitted:
            NSLog(@"WKNavigationTypeFormResubmitted");
            break;
        default:
            break;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

@end
