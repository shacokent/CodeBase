//
//  NSObject+SKRuntimeModel.m
//  CodeBase
//
//  Created by hongchen li on 2022/2/8.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "NSObject+SKRuntimeModel.h"
#import <objc/message.h>

@implementation NSObject (SKRuntimeModel)
+(instancetype)modelWithDict:(NSDictionary*)dict{
    id model = [[self alloc]init];
//    ivar：成员变量：下划线开头
    //Property：属性
    //runtime 根据模型中的属性去字典中取出对应的VALUE给模型赋值
    //获取模型的成员变量key
    //参数一：获取那个类的成员变量
//    参数二：成员变量个数
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList(self, &count);
//    遍历//    根据属性名去字典中查找VALUE
    for(int i=0;i<count;i++){
        Ivar ivar= ivars[i];
        NSString *ivarName= [NSString stringWithUTF8String:ivar_getName(ivar)];
        //成员变量名转换成属性名
        NSString *keyName = [ivarName substringFromIndex:1];
        id value = dict[keyName];
        
        //如果模型中包含模型,如果存在一个User模型，key:user,value:NSDictionary
        //二级转换，递归调用modelWithDict
        //判断是字典并且是自定义类型才做二级转换
//            获取成员变量的类型
        NSString *ivarType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
//                        获取的 ivarType是@\"User\"需要转换成User
        ivarType = [ivarType stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        ivarType = [ivarType stringByReplacingOccurrencesOfString:@"\"" withString:@"@"];
        
        if([value isKindOfClass:[NSDictionary class]] && ![ivarType hasPrefix:@"NS"]){
//            字典转模型NSDictionary => User模型
//            转换哪个模型
//            获取类
            Class modelClass = NSClassFromString(ivarType);
            value = [modelClass modelWithDict:value];//递归调用
        }
        if(value){
            //    给模型中属性赋值 KVC
            [model setValue:value forKey:keyName];
        }
    }
    return model;
}
@end
