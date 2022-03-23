//
//  SKRootVC.m
//  CodeBase
//
//  Created by hongchen li on 2021/12/14.
//  Copyright © 2021 shacokent. All rights reserved.
//

#import "SKRootVC.h"
#import "SKTabBarViewController.h"
#import "SKNewFeatureCollectionViewController.h"

@implementation SKRootVC
+(UIViewController *) chooseWindowRootVC{
    //引导页，当版本更新或者第一次安装，需要显示新特性界面
        //获取当前版本号
#define SKVersion @"version"
    NSString * currVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    //存储上一个版本号,用偏好设置存储,封装存储工具类
    NSString *lastVersion = [SKSaveTool objectForKey:SKVersion];
    UIViewController *rootVc;
    if(![currVersion isEqualToString:lastVersion]){
        //有版本更新，进入新特性
        rootVc = [[SKNewFeatureCollectionViewController alloc] init];
        //存储当前版本号
        [SKSaveTool setObject:currVersion forKey:SKVersion];
    }else{
        //进入主框架
        //设置窗口控制器
            //创建窗口根控制器
        rootVc = [[SKTabBarViewController alloc] init];
    }
    return rootVc;
}
@end
