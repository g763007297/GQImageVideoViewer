//
//  GQImageVideoViewerConst.h
//  GQImageVideoViewerDemo
//
//  Created by 高旗 on 16/9/12.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#ifndef GQImageVideoViewerConst_h
#define GQImageVideoViewerConst_h

#import <objc/runtime.h>

#define GQOBJECT_SINGLETON_BOILERPLATE(_object_name_, _shared_obj_name_)    \
static _object_name_ *z##_shared_obj_name_ = nil;                           \
+ (_object_name_ *)_shared_obj_name_ {                                      \
    @synchronized(self) {                                                   \
        if (z##_shared_obj_name_ == nil) {                                  \
            static dispatch_once_t done;                                    \
            dispatch_once(&done, ^{ z##_shared_obj_name_                    \
            = [[super allocWithZone:nil] init]; });                         \
        }                                                                   \
    }                                                                       \
    return z##_shared_obj_name_;                                            \
}                                                                           \
+ (id)allocWithZone:(NSZone *)zone {                                        \
    @synchronized(self) {                                                   \
        if (z##_shared_obj_name_ == nil) {                                  \
            z##_shared_obj_name_ = [super allocWithZone:NULL];              \
            return z##_shared_obj_name_;                                    \
        }                                                                   \
    }                                                                       \
    return nil;                                                             \
}                                                                           \
- (id)copyWithZone:(NSZone*)zone                                            \
{                                                                           \
    return z##_shared_obj_name_;                                            \
}


#define GQChainObjectDefine(_key_name_,_Chain_, _type_ , _block_type_)      \
- (_block_type_)_key_name_                                                  \
{                                                                           \
    __weak typeof(self) weakSelf = self;                                    \
    if (!_##_key_name_) {                                                   \
        _##_key_name_ = ^(_type_ value){                                    \
            __strong typeof(weakSelf) strongSelf = weakSelf;                \
            [strongSelf set##_Chain_:value];                                \
            return strongSelf;                                              \
        };                                                                  \
    }                                                                       \
    return _##_key_name_;                                                   \
}


#define GQ_DYNAMIC_PROPERTY_BOOL(_getter_, _setter_)                            \
- (void)_setter_:(BOOL)object{                                                  \
    [self willChangeValueForKey:@#_getter_];                                    \
    objc_setAssociatedObject(self, _cmd, @(object), OBJC_ASSOCIATION_ASSIGN);   \
    [self didChangeValueForKey:@#_getter_];                                     \
}                                                                               \
-(BOOL)_getter_{                                                                \
    return [objc_getAssociatedObject(self, @selector(_setter_:)) boolValue];    \
}                                                                               \

//强弱引用
#ifndef GQWeakify
#define GQWeakify(object) __weak __typeof__(object) weak##_##object = object
#endif

#ifndef GQStrongify
#define GQStrongify(object) __typeof__(object) object = weak##_##object
#endif


#endif /* GQImageVideoViewerConst_h */
