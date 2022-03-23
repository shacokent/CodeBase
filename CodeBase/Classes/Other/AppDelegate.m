//
//  AppDelegate.m
//  CodeBase
//
//  Created by hongchen li on 2021/12/7.
//

#import "AppDelegate.h"
#import "SDWebImageManager.h"
#import <UMCommon/UMCommon.h>
#import <UMCommonLog/UMCommonLogHeaders.h>
#import <UMAPM/UMCrashConfigure.h>
#import <UMCommon/MobClick.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    //    2.设置控制器
    self.window.rootViewController = [SKRootVC chooseWindowRootVC];
    
    //    3.显示窗口
    [self.window makeKeyAndVisible];
    
    // Override point for customization after application launch.
    //友盟统计集成
    //开发者需要显式的调用此函数，日志系统才能工作
    [UMCommonLogManager setUpUMCommonLogManager];
    [UMConfigure setLogEnabled:YES];
    [UMConfigure initWithAppkey:@"61f0c344e014255fcb07ddba" channel:@"CodeBase"];
    NSLog(@"UMAPM version:%@",[UMCrashConfigure getVersion]);
    [MobClick profileSignInWithPUID:@"85"];
    NSArray* stackTrace = [NSArray arrayWithObjects:
                            @"msg: Exception: Exception, Attempted to divide by zero.",
                            @"UnityDemo+ExceptionProbe.NormalException () (at <unknown>:0)",
                            @"UnityDemo.TrigException (System.Int32 selGridInt) (at <unknown>:0)",
                            @"UnityDemo.OnGUI () (at <unknown>:0)",
                            nil];
    [UMCrashConfigure reportExceptionWithName:@"my test except" reason:@"csharp exception" stackTrace:stackTrace];
    return YES;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    //1.清空缓存
    //cleanDisk清除过期缓存，计算当前缓存大小，和设置的最大缓存比较，如果超出那么会继续删除（按照文件的创建时间删除）
    //过期时间：7天，在SDImageCache中有对应属性
    [[SDWebImageManager sharedManager].imageCache cleanDisk];
    //clearMemory直接删除，重新创建
//    [[SDWebImageManager sharedManager].imageCache clearMemory];
    //2.取消当前所有操作
    [[SDWebImageManager sharedManager] cancelAll];
    //3.最大并发数量 == 6
    //4.缓存文件的保存名称如何处理? 拿到图片的URL路径,对该路径进行MD5加密，可以通过MAC终端验证，对字符串MD5加密，MAC终端可以输入 echo -n "字符串" |md5
    //5.该框架内部对内存警告的处理方式? 内部通过监听通知的方式请理缓存
    //6.该框架进行缓存处理的方式:可变字典--->NSCache
    //7.如何判断图片的类型: 在判断图片类型的时候，只匹配第一个字节
    //8.队列中任务的处理方式:FIFO先进先出，可设置
    //9.如何下载图片的? 发送网络请求下载图片,NSURLConnection
    //10.请求超时的时间 15秒    
}

@end
