//
//  Single.h
//  CodeBase
//
//  Created by hongchen li on 2021/12/30.
//  Copyright © 2021 shacokent. All rights reserved.
//
#define SingleH(name) +(instancetype)share##name;

#if __has_feature(objec_mrc)
//MRC
#define SingleM(name)  static id _instance;\
+ (instancetype)allocWithZone:(struct _NSZone *)zone{\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        _instance = [super allocWithZone:zone];\
    });\
    return _instance;\
}\
+(instancetype)share##name{\
    return [[self alloc] init];\
}\
-(id)copyWithZone:(NSZone *)zone{\
    return _instance;\
}\
-(id)mutableCopyWithZone:(NSZone *)zone{\
    return _instance;\
}\
-(oneway)release{\
}\
-(instancetype)retain{\
    return _instance;\
}\
-(NSInteger)retainCount{\
    return MAXFLOAT;\
}

#else
//ARC
#define SingleM(name)  static id _instance;\
+ (instancetype)allocWithZone:(struct _NSZone *)zone{\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        _instance = [super allocWithZone:zone];\
    });\
    return _instance;\
}\
+(instancetype)share##name{\
    return [[self alloc] init];\
}\
-(id)copyWithZone:(NSZone *)zone{\
    return _instance;\
}\
-(id)mutableCopyWithZone:(NSZone *)zone{\
    return _instance;\
}

#endif
