//
//  NSObject+SKRuntime.m
//  CodeBase
//
//  Created by hongchen li on 2022/2/8.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "NSObject+SKRuntime.h"
#import <objc/message.h>

@implementation NSObject (SKRuntime)


- (void)setName:(NSString *)name{
    //让字符串与当前对象产生关系
    //参数一：给哪个对象添加属性
    //参数二：属性名称
    //参数三：属性值
    //参数四：保存策略
    objc_setAssociatedObject(self, @"name", name,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)name{
    return objc_getAssociatedObject(self, @"name");
}


@end
