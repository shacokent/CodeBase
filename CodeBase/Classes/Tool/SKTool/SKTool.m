//
//  SKTool.m
//  CodeBase
//
//  Created by hongchen li on 2021/12/30.
//  Copyright © 2021 shacokent. All rights reserved.
//

#import "SKTool.h"

@implementation SKTool

//提供全局变量
static SKTool * _instance;

//alloc会调用allocWithZone，所以重写allocWithZone,存在线程安全问题，需要加入互斥锁，或者使用GCD一次性函数
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    //方法一，互斥锁
//    @synchronized (self) {
//        if(_instance== nil){
//            _instance = [super allocWithZone:zone];
//        }
//    }
    //方法二，一次性函数
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}


//提供类方法，1.方便访问，2.表明身份，3注意命名：share｜default+类名
+(instancetype)shareSKTool{
    return [[self alloc] init];
}

//严谨一点, 重写对象方法copyWithZone,mutableCopyWithZone，先遵守NSCopying,NSMutableCopying两个协议，方便写出方法名，之后可以删除
-(id)copyWithZone:(NSZone *)zone{
    return _instance;
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    return _instance;
}

//利用宏来判断当前模式是否是ARC 还是MRC
#if __has_feature(objec_mrc)
//MRC
-(oneway)release{

}

-(instancetype)retain{
    return _instance;
}

//习惯重写retainCount
-(NSInteger)retainCount{
    return MAXFLOAT;
}
#else
//条件满足 ARC
#endif

@end
