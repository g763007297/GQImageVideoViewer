//
//  GQHttpRequestManager.h
//  GQImageVideoViewerDemo
//
//  Created by 高旗 on 16/9/12.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GQHttpRequestManager : NSObject

+ (GQHttpRequestManager *)sharedHttpRequestManager;

- (void)addOperation:(NSOperation *)operation;

- (void)suspendLoading;

- (void)restoreLoading;

@end