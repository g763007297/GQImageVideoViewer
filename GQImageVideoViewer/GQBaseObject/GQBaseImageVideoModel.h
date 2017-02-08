//
//  GQBaseModel.h
//  GQImageVideoViewerDemo
//
//  Created by 高旗 on 16/9/13.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString *const GQURLString;
extern NSString *const GQIsImageURL;
extern NSString *const GQVideoViewClassName;
extern NSString *const GQImageViewClassName;
extern NSString *const GQNilClassName;

@interface GQBaseImageVideoModel : NSObject<NSCopying,NSCoding>

/**
 *  可以传NSString,NSUrl,UIImage,UIImageView类型
 */
@property (nonatomic, copy) id GQURLString;

/**
 *  是否为图片，如果是图片地址就传YES，如果是视频地址就传NO
 */
@property (nonatomic, assign) BOOL GQIsImageURL;

/**
 自定义视频播放界面class名称 必须继承GQBaseVideoView
 */
@property (nonatomic, strong) NSString *GQVideoViewClassName;

/**
 自定义图片浏览界面class名称 必须继承GQBaseImageView
 */
@property (nonatomic, strong) NSString *GQImageViewClassName;

- (id)initWithDataDic:(NSDictionary*)data;

@end
