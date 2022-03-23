//
//  SKPerson.m
//  CodeBase
//
//  Created by hongchen li on 2022/2/8.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKPerson.h"
#import <objc/message.h>

@implementation SKPerson

//任何方法都有两个隐式参数id self,SEL _cmd
void aaa(id self,SEL _cmd){
//    _cmd:当前方法编号
    NSLog(@"吃");
}

void bbb(id self,SEL _cmd,NSNumber *m){
//    _cmd:当前方法编号
    NSLog(@"跑---%@",m);
}

//什么时候调用，只要一个对象调用了一个未实现的方法就会调用这个方法进行处理（如runtime动态添加方法时）
//作用:动态添加方法，处理未实现
+ (BOOL)resolveInstanceMethod:(SEL)sel{
    //动态添加方法
    if(sel == NSSelectorFromString(@"eat")){
        //参数一：给哪个类添加方法
        //参数二：添加什么方法
        //参数三：IMP 方法实现=>函数=>函数入口=>函数名
        //参数四：方法类型（返回值和参数类型）
        class_addMethod(self, sel, (IMP)aaa, "v@:");
    }
    if(sel == NSSelectorFromString(@"run:")){
        //参数一：给哪个类添加方法
        //参数二：添加什么方法
        //参数三：IMP 方法实现=>函数=>函数入口=>函数名
        //参数四：方法类型（返回值和参数类型）
        class_addMethod(self, sel, (IMP)bbb, "v@:@");
    }
    return [super resolveInstanceMethod:sel];
}

+(instancetype)itemWithDict:(NSDictionary*)dict{
    SKPerson *item = [[self alloc] init];
    [item setValuesForKeysWithDictionary:dict];
    return item;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    //字典转模型，重新系统方法阻止报错
}
@end
