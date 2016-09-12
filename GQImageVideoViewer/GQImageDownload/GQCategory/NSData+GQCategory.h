//
//  NSData+GQCategory.h
//  GQImageVideoViewerDemo
//
//  Created by 高旗 on 16/9/12.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSData (GQCategory)

- (UIImage *)gqImageWithData;

- (NSString *)gqTypeForImageData;

@end
