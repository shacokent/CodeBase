//
//  UIImage+SKRuntime.m
//  CodeBase
//
//  Created by hongchen li on 2022/2/8.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "UIImage+SKRuntime.h"
#import <objc/message.h>

@implementation UIImage (SKRuntime)
//把类加载进内存的时候调用，只回调用一次
+ (void)load{
    //交换方法runtime
//    获取方法imageNamed
//    获取sk_imageNamed
    //获取类方法： class_getClassMethod,补充:获取对象方法class_getInstanceMethod

    Method imageNamedM = class_getClassMethod(self, @selector(imageNamed:));
    Method sk_imageNamedM = class_getClassMethod(self, @selector(sk_imageNamed:));
    method_exchangeImplementations(imageNamedM,sk_imageNamedM);
    //交换完成
//    调用imageNamed等于调用sk_imageNamed
//    调用sk_imageNamed等于调用imageNamed
//    sk_imageNamed中得用sk_imageNamed，避免交换后造成循环调用方法
}
//或者用initialize与dispatch_once_t连用，因为initialize可能会调用多次
//+ (void)initialize{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//
//    });
//}

//1.加载图片
//2.是否加载成功
+ (UIImage *)sk_imageNamed:(NSString *)name{
//    UIImage *image = [UIImage imageNamed:name];
//    这里得用sk_imageNamed，避免交换后造成循环调用方法
    UIImage *image = [UIImage sk_imageNamed:name];
    if(image){
        NSLog(@"sk_imageNamed success");
    }
    else{
        NSLog(@"sk_imageNamed fail");
    }
    return image;
}
@end
