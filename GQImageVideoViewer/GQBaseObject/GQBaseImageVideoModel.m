//
//  GQBaseModel.m
//  GQImageVideoViewerDemo
//
//  Created by 高旗 on 16/9/13.
//  Copyright © 2016年 gaoqi. All rights reserved.
//

#import "GQBaseImageVideoModel.h"
#import <objc/runtime.h>

NSString *const GQURLString = @"GQURLString";
NSString *const GQIsImageURL = @"GQIsImageURL";
NSString *const GQVideoViewClassName = @"GQVideoViewClassName";
NSString *const GQImageViewClassName = @"GQImageViewClassName";
NSString *const GQNilClassName = @"nil";
/**
 *  Given a scalar or struct value, wraps it in NSValue
 *  Based on EXPObjectify: https://github.com/specta/expecta
 */
static inline id _GQBoxValue(const char *type, ...) {
    va_list v;
    va_start(v, type);
    id obj = nil;
    if (strcmp(type, @encode(id)) == 0) {
        id actual = va_arg(v, id);
        obj = actual;
    } else if (strcmp(type, @encode(CGPoint)) == 0) {
        CGPoint actual = (CGPoint)va_arg(v, CGPoint);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(CGSize)) == 0) {
        CGSize actual = (CGSize)va_arg(v, CGSize);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(UIEdgeInsets)) == 0) {
        UIEdgeInsets actual = (UIEdgeInsets)va_arg(v, UIEdgeInsets);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(double)) == 0) {
        double actual = (double)va_arg(v, double);
        obj = [NSNumber numberWithDouble:actual];
    } else if (strcmp(type, @encode(float)) == 0) {
        float actual = (float)va_arg(v, double);
        obj = [NSNumber numberWithFloat:actual];
    } else if (strcmp(type, @encode(int)) == 0) {
        int actual = (int)va_arg(v, int);
        obj = [NSNumber numberWithInt:actual];
    } else if (strcmp(type, @encode(long)) == 0) {
        long actual = (long)va_arg(v, long);
        obj = [NSNumber numberWithLong:actual];
    } else if (strcmp(type, @encode(long long)) == 0) {
        long long actual = (long long)va_arg(v, long long);
        obj = [NSNumber numberWithLongLong:actual];
    } else if (strcmp(type, @encode(short)) == 0) {
        short actual = (short)va_arg(v, int);
        obj = [NSNumber numberWithShort:actual];
    } else if (strcmp(type, @encode(char)) == 0) {
        char actual = (char)va_arg(v, int);
        obj = [NSNumber numberWithChar:actual];
    } else if (strcmp(type, @encode(bool)) == 0) {
        bool actual = (bool)va_arg(v, int);
        obj = [NSNumber numberWithBool:actual];
    } else if (strcmp(type, @encode(unsigned char)) == 0) {
        unsigned char actual = (unsigned char)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedChar:actual];
    } else if (strcmp(type, @encode(unsigned int)) == 0) {
        unsigned int actual = (unsigned int)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedInt:actual];
    } else if (strcmp(type, @encode(unsigned long)) == 0) {
        unsigned long actual = (unsigned long)va_arg(v, unsigned long);
        obj = [NSNumber numberWithUnsignedLong:actual];
    } else if (strcmp(type, @encode(unsigned long long)) == 0) {
        unsigned long long actual = (unsigned long long)va_arg(v, unsigned long long);
        obj = [NSNumber numberWithUnsignedLongLong:actual];
    } else if (strcmp(type, @encode(unsigned short)) == 0) {
        unsigned short actual = (unsigned short)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedShort:actual];
    }
    va_end(v);
    return obj;
}

#define GQBoxValue(value) _GQBoxValue(@encode(__typeof__((value))), (value))

typedef void(^GQEnumerateSuper)(Class c , BOOL *stop);

@interface GQBaseImageVideoModel()

- (void)setAttributes:(NSDictionary*)dataDic;

@end

@implementation GQBaseImageVideoModel

+ (NSDictionary *)attributeMapDictionary{
    return [[[[self class] alloc] init] propertiesAttributeMapDictionary];
}

- (NSString *)customDescription
{
    return nil;
}

- (NSData*)getArchivedData
{
    return [NSKeyedArchiver archivedDataWithRootObject:self];
}

- (NSString *)description
{
    NSMutableString *attrsDesc = [NSMutableString stringWithCapacity:100];
    NSDictionary *attrMapDic = [[self class] attributeMapDictionary];
    NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
    id attributeName;
    while ((attributeName = [keyEnum nextObject])) {
        id valueObj = [self getValue:attributeName];
        if (valueObj) {
            [attrsDesc appendFormat:@" [%@=%@] ",attributeName,valueObj];
        }else {
            [attrsDesc appendFormat:@" [%@=nil] ",attributeName];
        }
    }
    NSString *customDesc = [self customDescription];
    NSString *desc;
    if (customDesc && [customDesc length] > 0 ) {
        desc = [NSString stringWithFormat:@"%@:{%@,%@}", [self class], attrsDesc, customDesc];
    }
    else {
        desc = [NSString stringWithFormat:@"%@:{%@}", [self class], attrsDesc];
    }
    return desc;
}



-(id)initWithDataDic:(NSDictionary*)data
{
    if (self = [super init]) {
        [self setAttributes:data];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    id object = [[self class] allocWithZone:zone];
    NSDictionary *attrMapDic = [[self class] attributeMapDictionary];
    NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
    id attributeName;
    while ((attributeName = [keyEnum nextObject])) {
        SEL getSel = NSSelectorFromString(attributeName);
        SEL sel = [object getSetterSelWithAttibuteName:attributeName];
        if ([self respondsToSelector:sel] &&
            [self respondsToSelector:getSel]) {
            id valueObj = [self getValue:attributeName];
            if (valueObj) {
                [object setValue:valueObj forKey:attributeName];
            }
        }
    }
    return object;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if( self = [super init] ){
        NSDictionary *attrMapDic = [[self class] attributeMapDictionary];
        if (attrMapDic == nil) {
            return self;
        }
        NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
        id attributeName;
        while ((attributeName = [keyEnum nextObject])) {
            SEL sel = [self getSetterSelWithAttibuteName:attributeName];
            if ([self respondsToSelector:sel]) {
                id obj = [decoder decodeObjectForKey:attributeName];
                if (obj) {
                    [self setValue:obj forKey:attributeName];
                }
            }
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    NSDictionary *attrMapDic = [[self class] attributeMapDictionary];
    if (attrMapDic == nil) {
        return;
    }
    NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
    id attributeName;
    while ((attributeName = [keyEnum nextObject])) {
        id valueObj = [self getValue:attributeName];
        if (valueObj) {
            [encoder encodeObject:valueObj forKey:attributeName];
        }
    }
}

#pragma mark - private methods
-(SEL)getSetterSelWithAttibuteName:(NSString*)attributeName
{
    NSString *capital = [[attributeName substringToIndex:1] uppercaseString];
    NSString *setterSelStr = [NSString stringWithFormat:@"set%@%@:",capital,[attributeName substringFromIndex:1]];
    return NSSelectorFromString(setterSelStr);
}

-(void)setAttributes:(NSDictionary*)dataDic
{
    NSDictionary *attrMapDic = [[self class] attributeMapDictionary];
    if (attrMapDic == nil) {
        return;
    }
    NSEnumerator *keyEnum = [attrMapDic keyEnumerator];
    id attributeName;
    while ((attributeName = [keyEnum nextObject])) {
        SEL sel = [self getSetterSelWithAttibuteName:attributeName];
        if ([self respondsToSelector:sel]) {
            NSString *dataDicKey = attrMapDic[attributeName];
            NSString *value = nil;
            if([[dataDic objectForKey:dataDicKey] isKindOfClass:[NSNull class]]){
                value = nil;
            }else{
                value = [dataDic objectForKey:dataDicKey];
            }
            [self setValue:value forKey:dataDicKey];
        }
    }
}

/*!
 * get property names of object
 */
- (NSArray*)propertyNames
{
    NSMutableArray *propertyNames = [[NSMutableArray alloc] init];
    [[self class] enumerateCustomClass:^(__unsafe_unretained Class c, BOOL *stop) {
        unsigned int propertyCount = 0;
        objc_property_t *properties = class_copyPropertyList(c, &propertyCount);
        for (unsigned int i = 0; i < propertyCount; ++i) {
            objc_property_t property = properties[i];
            const char * name = property_getName(property);
            [propertyNames addObject:[NSString stringWithUTF8String:name]];
        }
        free(properties);
    }];
    return propertyNames;
}

+ (void)enumerateCustomClass:(GQEnumerateSuper)block
{
    if (block == nil) {
        return;
    }
    BOOL stop = NO;
    
    Class c = self;
    
    while (c &&!stop) {
        block(c, &stop);
        
        c = class_getSuperclass(c);
        
        if (![c isSubclassOfClass:[GQBaseImageVideoModel class]]) break;
    }
}

- (NSArray *)versionChangeProperties
{
    return nil;
}

/*!
 *	\returns a dictionary Key-Value pair by property and corresponding value.
 */
- (NSDictionary*)propertiesAndValuesDictionary
{
    NSMutableDictionary *propertiesValuesDic = [NSMutableDictionary dictionary];
    NSArray *properties = [self propertyNames];
    for (NSString *property in properties) {
        id object = [self getValue:property]?[self getValue:property]:@"";
        propertiesValuesDic[property] = object;
    }
    return propertiesValuesDic;
}

- (id)getValue:(NSString *)property
{
    SEL getSel = NSSelectorFromString(property);
    id valueObj = nil;
    if ([self respondsToSelector:getSel]) {
        valueObj =[self valueForKey:property];
    }
    return GQBoxValue(valueObj);
}

// default AttributeMapDictionary
- (NSDictionary*)propertiesAttributeMapDictionary
{
    NSMutableDictionary *attributeMapDictionary = [NSMutableDictionary dictionary];
    NSArray *properties = [self propertyNames];
    for (NSString *property in properties) {
        SEL getSel = NSSelectorFromString(property);
        if ([self respondsToSelector:getSel]) {
            attributeMapDictionary[property] = property;
        }
    }
    return attributeMapDictionary;
}

@end
