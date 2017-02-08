//
//  GQImageVideoViewer.h
//  GQImageVideoViewerDemo
//
//  Created by 高旗 on 16/9/12.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GQBaseImageVideoModel.h"

typedef enum {
    GQLaunchDirectionBottom = 1,//从下往上推出
    GQLaunchDirectionTop,       //从上往下推出
    GQLaunchDirectionLeft,      //从左往右推出
    GQLaunchDirectionRight      //从右往左推出
}GQLaunchDirection;

typedef void (^GQAchieveIndexBlock)(NSInteger selectIndex);//获取当前图片的index的block

@class GQImageVideoViewer;

//链式调用block
typedef GQImageVideoViewer * (^GQUsePageControlChain)(BOOL pageControl);
typedef GQImageVideoViewer * (^GQStringClassChain) (NSString *className);
typedef GQImageVideoViewer * (^GQDataArrayChain)(NSArray *dataArray);
typedef GQImageVideoViewer * (^GQSelectIndexChain)(NSInteger selectIndex);
typedef GQImageVideoViewer * (^GQLaunchDirectionChain)(GQLaunchDirection launchDirection);
typedef GQImageVideoViewer * (^GQAchieveIndexChain)(GQAchieveIndexBlock selectIndexBlock);
typedef void (^GQShowViewChain)(UIView *showView);

@interface GQImageVideoViewer : UIView

#pragma mark -- 链式调用
/**
 自定义视频class名称   type : NSSting
 */
@property (nonatomic, copy, readonly) GQStringClassChain videoViewClassNameChain;

/**
 自定义图片浏览界面class名称   type : NSSting
 */
@property (nonatomic, copy, readonly) GQStringClassChain imageViewClassNameChain;

/**
 *  显示PageControl传yes   type : BOOL
 */
@property (nonatomic, copy, readonly) GQUsePageControlChain usePageControlChain;

/**
 *  图片数组    type : NSArray *
 */
@property (nonatomic, copy, readonly) GQDataArrayChain dataArrayChain;

/**
 *  选中的图片索引    type : NSInteger
 */
@property (nonatomic, copy, readonly) GQSelectIndexChain selectIndexChain;

/**
 *  推出方向  type : GQLaunchDirection
 */
@property (nonatomic, copy, readonly) GQLaunchDirectionChain launchDirectionChain;

/**
 *  显示GQImageViewer到指定view上   type: UIView *
 */
@property (nonatomic, copy, readonly) GQShowViewChain showViewChain;

/**
 *  获取当前选中的图片index  type: GQAchieveIndexBlock
 */
@property (nonatomic, copy, readonly) GQAchieveIndexChain achieveSelectIndexChain;

#pragma mark -- 普通调用

/*
 *  显示PageControl传yes   默认 : yes
 *  显示label就传no
 */
@property (nonatomic, assign) BOOL usePageControl;

/**
 自定义视频class名称   必须继承GQBaseVideoView
 */
@property (nonatomic, strong) NSString *videoViewClassName;

/**
 自定义图片浏览界面class名称 必须继承GQBaseImageView
 */
@property (nonatomic, strong) NSString *imageViewClassName;

/**
 *  如果有网络图片则设置默认图片
 */
@property (nonatomic, copy) UIImage *placeholderImage;

/**
 *  资源数组
 */
@property (nonatomic, copy) NSArray *dataArray;//资源数组

/**
 *  获取当前选中的图片index
 */
@property (nonatomic, copy) GQAchieveIndexBlock achieveSelectIndex;

/**
 *  选中的图片索引
 */
@property(nonatomic,assign) NSInteger selectIndex;

/**
 *  推出方向  默认GQLaunchDirectionBottom
 */
@property (nonatomic) GQLaunchDirection laucnDirection;

/**
 *  显示GQImageViewer到指定view上
 *
 *  @param showView view
 */
- (void)showInView:(UIView *)showView;

/**
 *  单例方法
 *
 *  @return GQImageViewer
 */
+ (GQImageVideoViewer *)sharedInstance;

/**
 *  取消显示
 */
- (void)dissMiss;

@end
