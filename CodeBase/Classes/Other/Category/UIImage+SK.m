//
//  UIImage+SK.m
//  CodeBase
//
//  Created by hongchen li on 2021/12/8.
//  Copyright © 2021 shacokent. All rights reserved.
//

@implementation UIImage (SK)


+(UIImage*)imageWithRenderOriginalName:(NSString*)name{
    //代码多次调用，防止重复书写，可实现分类
    UIImage *image = [UIImage imageNamed:name];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];//取消渲染，保持原始图片样式
}
@end
