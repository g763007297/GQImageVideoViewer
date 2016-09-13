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

@interface GQBaseImageVideoModel : NSObject<NSCopying,NSCoding>

/**
 *  可以传NSString,NSUrl,UIImage,UIImageView类型
 */
@property (nonatomic, copy) id GQURLString;

/**
 *  是否为图片，如果是图片地址就传YES，如果是视频地址就传NO
 */
@property (nonatomic, assign) BOOL GQIsImageURL;

- (id)initWithDataDic:(NSDictionary*)data;

@end
