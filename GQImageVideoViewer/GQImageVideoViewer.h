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

typedef enum {
    GQShowIndexTypeNone = 1,        // 不显示下标
    GQShowIndexTypePageControl,     // 以pageControl的形式显示
    GQShowIndexTypeLabel            // 以文字样式显示
    
}GQShowIndexType;

typedef void (^GQAchieveIndexBlock)(NSInteger selectIndex);//获取当前图片的index的block
typedef void (^GQDissMissAtIndexBlock)(NSInteger dissMissIndex);// 移除浏览器时的block

@class GQImageVideoViewer;

//链式调用block
typedef GQImageVideoViewer * (^GQShowIndexTypeChain)(GQShowIndexType showIndexType);
typedef GQImageVideoViewer * (^GQStringClassChain) (NSString *className);
typedef GQImageVideoViewer * (^GQDataArrayChain)(NSArray *dataArray);
typedef GQImageVideoViewer * (^GQSelectIndexChain)(NSInteger selectIndex);
typedef GQImageVideoViewer * (^GQLaunchDirectionChain)(GQLaunchDirection launchDirection);
typedef GQImageVideoViewer * (^GQAchieveIndexChain)(GQAchieveIndexBlock selectIndexBlock);
typedef GQImageVideoViewer * (^GQDissMissAtIndexChain)(GQDissMissAtIndexBlock dissMissAtIndexBlock);
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
@property (nonatomic, copy, readonly) GQShowIndexTypeChain showIndexTypeChain;

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

/**
 *  移除浏览器时和移除时的index type:  GQDissMissWithIndexBlock
 */
@property (nonatomic, copy, readonly) GQDissMissAtIndexChain dissMissAtIndexChain;
#pragma mark -- 普通调用

/*
 *  显示PageControl传yes   默认 : yes
 *  显示label就传no
 */
@property (nonatomic, assign) GQShowIndexType showIndexType;

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
 *  移除浏览器时的index
 */
@property (copy, nonatomic) GQDissMissAtIndexBlock dissMissAtIndex;

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
