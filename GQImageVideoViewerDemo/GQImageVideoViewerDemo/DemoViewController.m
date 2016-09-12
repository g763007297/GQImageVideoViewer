//
//  DemoViewController.m
//  GQImageVideoViewerDemo
//
//  Created by 高旗 on 16/9/12.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "DemoViewController.h"
#import "GQImageVideoViewer.h"
#import <AVFoundation/AVFoundation.h>

@interface DemoViewController (){
    UIView *demoView;
}

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
    
    demoView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.view.frame)/2-100, 64, 200, 300)];
    demoView.backgroundColor = [UIColor redColor];
    [self.view addSubview:demoView];
}

- (void)showImageViewer:(id)sender{
    NSMutableArray *imageArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 1; i <11; i ++) {
        NSString *fromPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d.jpg",i] ofType:nil];
        NSData *data = [NSData dataWithContentsOfFile:fromPath];
        [imageArray addObject:[UIImage imageWithData:data]];
    }
    NSURL *url = [NSURL URLWithString:@"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4"];
    [imageArray addObjectsFromArray:@[[[NSURLRequest alloc] initWithURL:url],
                                      [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://192.168.31.152:8080/abc.mp4"]],
                                      [[NSURLRequest alloc] initWithURL:url],
                                      @"http://cdn.cocimg.com/bbs/attachment/upload/30/5811301473150224.gif",
                                      @"http://img0.imgtn.bdimg.com/it/u=513437991,1334115219&fm=206&gp=0.jpg",
                                      @"http://h.hiphotos.baidu.com/image/pic/item/203fb80e7bec54e7f14e9ce2bf389b504ec26aa8.jpg",
                                      @"http://f.hiphotos.baidu.com/image/pic/item/a8014c086e061d9507500dd67ff40ad163d9cacd.jpg",
                                      @"http://e.hiphotos.baidu.com/image/pic/item/8718367adab44aed02675424b71c8701a08bfbc1.jpg",
                                      @"http://e.hiphotos.baidu.com/image/pic/item/a9d3fd1f4134970a4c3910c891cad1c8a6865d8a.jpg",
                                      @"http://c.hiphotos.baidu.com/image/pic/item/35a85edf8db1cb139badc135d854564e93584bd4.jpg",
                                      @"http://b.hiphotos.baidu.com/image/pic/item/d043ad4bd11373f0a3f892b9a10f4bfbfaed04d4.jpg",
                                      @"http://a.hiphotos.baidu.com/image/pic/item/7af40ad162d9f2d30f78d8c9acec8a136327ccaf.jpg",
                                      @"http://a.hiphotos.baidu.com/image/pic/item/c8177f3e6709c93d8087f2d19a3df8dcd100549b.jpg",
                                      @"http://g.hiphotos.baidu.com/image/pic/item/a8ec8a13632762d0a97e5899a5ec08fa513dc650.jpg"]];
    
//    基本调用
//        [[GQImageVideoViewer sharedInstance] setImageArray:imageArray];
//        [GQImageVideoViewer sharedInstance].usePageControl = YES;
//        [GQImageVideoViewer sharedInstance].selectIndex = 6;
//        [GQImageVideoViewer sharedInstance].achieveSelectIndex = ^(NSInteger selectIndex){
//            NSLog(@"%ld",selectIndex);
//        };
//        [GQImageVideoViewer sharedInstance].laucnDirection = GQLaunchDirectionRight;
//        [[GQImageVideoViewer sharedInstance] showInView:self.navigationController.view];
    
    //    链式调用
    [GQImageVideoViewer sharedInstance]
    .imageArrayChain(imageArray)
    .usePageControlChain(NO)
    .selectIndexChain(12)
    .achieveSelectIndexChain(^(NSInteger selectIndex){
        NSLog(@"%ld",selectIndex);
    })
    .launchDirectionChain(GQLaunchDirectionRight)
    .showViewChain(self.navigationController.view);
}

@end