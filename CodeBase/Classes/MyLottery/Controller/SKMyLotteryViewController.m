//
//  SKMyLotteryViewController.m
//  CodeBase
//
//  Created by hongchen li on 2021/12/8.
//  Copyright © 2021 shacokent. All rights reserved.
//

#import "SKMyLotteryViewController.h"
#import "SKSettingTableViewController.h"
#import "SKTool.h"
#import "SKTool2.h"
#import "SKNSOperation.h"
#import "SKNSThread.h"
#import "UIImageView+WebCache.h"//SDWebDownload1
#import "SDWebImageManager.h"//SDWebDownload2
#import "SDWebImageDownloader.h"//SDWebDownload3
#import "UIImage+GIF.h"//SDWebDownload4
#import "NSData+ImageContentType.h"//SDWebDownload5
#import "SVProgressHUD.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MJExtension.h"
#import "SKMJExtensionModel.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "SSZipArchive.h"
#import "AFNetworking.h"
#import <objc/message.h>
#import "UIImage+SKRuntime.h"
#import "SKPerson.h"
#import "NSObject+SKRuntime.h"
#import "NSDictionary+SKRuntimeKVC.h"
#import "NSObject+SKRuntimeModel.h"
#import "SKMytabbarController.h"
#import "SKWangYiViewController.h"

@interface SKMyLotteryViewController ()<NSCacheDelegate,NSURLConnectionDataDelegate,NSXMLParserDelegate,NSURLSessionDataDelegate,NSURLSessionDownloadDelegate>
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic,strong) NSCache *cache;
@property (nonatomic,strong) dispatch_source_t timer;
@property (nonatomic,strong) NSThread *thread;
@property (nonatomic,strong) NSMutableData *requestData;
@end

@implementation SKMyLotteryViewController

- (NSCache *)cache{
    if(_cache == nil){
        _cache = [[NSCache alloc] init];
//        _cache.countLimit = 5;//设置最多缓存个数
        _cache.totalCostLimit = 5;//总成本5
        _cache.delegate = self;
    }
    return _cache;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //拿到button的背景图片
    UIImage *image = self.loginBtn.currentBackgroundImage;
    //拉伸背景图片
    image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    [self.loginBtn setBackgroundImage:image forState:UIControlStateNormal];
    
    //设置导航条左侧按钮
    UIButton * button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:@"FBMM_Barbutton"] forState:UIControlStateNormal];
    [button setTitle:@"客服" forState:UIControlStateNormal];
    [button sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    //设置导航条右侧按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithRenderOriginalName:@"Mylottery_config"] style:UIBarButtonItemStylePlain target:self action:@selector(config)];
  
    
#pragma mark - NSThread
    //创建线程的方法
    //方法一
    NSThread * threadA = [[NSThread alloc] initWithTarget:self selector:@selector(run:) object:@"threadA"];
    threadA.name = @"threadA";//线程名
    threadA.threadPriority = 1.0;//线程优先级0.0～1.0
    [threadA start];
    
    //方法二，分离子线程
    [NSThread detachNewThreadSelector:@selector(run2:) toTarget:self withObject:@"threadB"];
    
    //方法三，后台子线程
    [self performSelectorInBackground:@selector(run3:) withObject:@"threadC"];
    
    //方法四,自定义重写main方法
    SKNSThread * threadD = [[SKNSThread alloc] init];
    [threadD start];
    
    
#pragma mark - ARC 和 MRC 环境下实现单例模式
    //一个类永远都只有一个实例,SKTool重写allocWithZone,如果是MRC环境下还需要重写release，retain
    //切换MRC，在Build Settings中object-c automatic reference counting改成NO
    SKTool *sk1 = [SKTool shareSKTool];
    NSLog(@"%p",sk1);
    
#pragma mark - 更好的单例模式实现方法
    //建立一个头文件（Single.h），只写可传串参数的宏
    SKTool2 *sk2 = [SKTool2 shareSKTool2];
    NSLog(@"%p",sk2);
}

-(void)config{
    SKSettingTableViewController * setting = [[SKSettingTableViewController alloc] init];
    setting.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:setting animated:YES];
}

-(void)run:(NSString*)str{
    NSLog(@"str===%@",str);
    if([NSThread isMainThread]){
        NSLog(@"是主线程---%@",[NSThread currentThread]);
    }
    if([NSThread currentThread] == 0){
        NSLog(@"也是主线程---%@",[NSThread currentThread]);
    }
    //阻塞线程
    //方法一
    [NSThread sleepForTimeInterval:2.0];//秒
    //方法二
    [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:2.0]];
    
    for(NSInteger i = 0 ;i<1000;i++){
        if(i==500){
            NSLog(@"退出当前线程");
            [NSThread exit];//退出当前线程
        }
    }
}

-(void)run2:(NSString*)str{
    //线程锁,锁全剧只能有一个,一般用self，几个线程同时操作同一个资源时才会用到线程锁
    //附加内容：原子属性atomic，线程安全为setter方法枷锁，非nonatomic
    @synchronized (self) {
        //要执行的操作代码
    }
}

-(void)run3:(NSString*)str{
    //线程通信
    //加载资源时，如下载图片加载进入imageview，最后必须返回主线程支持性UI刷新
    //附加内容计算代码执行耗时
    CFTimeInterval start = CFAbsoluteTimeGetCurrent();
    //加载图片代码
    NSLog(@"加载图片代码");
    CFTimeInterval end = CFAbsoluteTimeGetCurrent();
    NSLog(@"end-start---%f",end-start);
    
    //返回主线程刷新UI
    //方法一
//    [self performSelectorOnMainThread:@selector(run4:) withObject:image waitUntilDone:YES];
    //方法二，因为NSThread继承自NSObject的分类，所以任何对象都可以调用NSthread的方法,所以self.imageView,直接调用线程方法，selector设置setImage即可
    //waitUntilDone参数YES等待线程运行完毕继续执行之后的代码，NO不等待
//    [self.imageView  performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:YES];
    
    
}

//返回主线程刷新UI，方法一调用
-(void)run4:(UIImage*)image{
//    self.imageView.image = image;
}


#pragma mark - GCD
- (IBAction)loginOnClick:(UIButton *)sender {
    //GCD
    //同步方式.只能在当前线程中执行，不具备开启新线程的能力，
    //queue:队列，block：任务
//    dispatch_sync(queue, block);
    //异步方式.可以在新线程中执行，具备开启新线程的能力
    //queue:队列，block：任务
//    dispatch_async(queue, block);
    
//    队列的类型：
//    并发队列，多个任务并发执行，只有在异步dispatch_async函数下才有用
//    串行队列，只能一个接一个的执行
    
    //异步函数+并发队列：会开启多条线程，开启线程数不定，系统自动判断，队列中的任务并发执行
    [self asyncConcurrent];
    //异步函数+串行队列：会开启一条线程，队列中的任务串行队列执行
    [self asyncSerial];
    //同步函数+并发队列:不会开启线程，队列中的任务串行队列执行
    [self syncConcurrent];
    //同步函数+串行队列:不会开启线程，队列中的任务串行队列执行
    [self syncSerial];
    
    //主队列
    //异步函数+主队列:所有任务都在主线程执行，不会开启线程
    [self asyncMain];
    //同步函数+主队列:（在主线程中执行）死锁，程序会崩溃
    [self syncMain];
    //同步函数+主队列:（开启子线程执行）不会开启线程，队列中的任务串行队列执行
    [NSThread detachNewThreadSelector:@selector(syncMain) toTarget:self withObject:nil];
    
    //GCD线程通信，通知主线程刷新UI
    //直接从网址下载图片为例（附加：让程序允许使用http访问，需要在plist文件中设置App Transport Securfty Settings->Allow Arbitrary Loade设置为YES）
    [self downloadImage];
    
    //延迟函数
    [self delay];
    
    //一次函数,多用于单例模式，一个APP只执行一次（注意：不能在懒加载中使用）
    [self once];
    
    //栅栏函数,控制多线程异步函数的执行顺序
    [self barrier];
    
    //GCD快速迭代,开子线程和主线程一起并发执行
    [self apply];
    
    //队列组，方式二，队列组管理队列
    [self queueGroup1];
    
    //队列组，方式二，老方法，队列组管理队列
    [self queueGroup2];
    
    //组队列下载图片合并成一张的例子
    [self group3];
    
//    dispatch_async_f和dispatch_async区别
    [self test];
        
}

//异步函数+并发队列：会开启多条线程，开启线程数不定，系统自动判断，队列中的任务并发执行
-(void)asyncConcurrent{
    //创建队列方法一
    //参数一：C语言字符串，标签
    //参数二：队列类型
//    dispatch_queue_t queue = dispatch_queue_create("com.speehocean.download", DISPATCH_QUEUE_CONCURRENT);
    
    //创建队列方法二，获取全局并发队列
    //参数一：优先级,DISPATCH_QUEUE_PRIORITY_DEFAULT
    //参数二：默认0
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //封装任务
    dispatch_async(queue, ^{
        NSLog(@"%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"%@",[NSThread currentThread]);
    });
    
    
}

//异步函数+串行队列：会开启一条线程，队列中的任务串行队列执行
-(void)asyncSerial{
    dispatch_queue_t queue = dispatch_queue_create("com.speehocean.download", DISPATCH_QUEUE_SERIAL);
    //封装任务
    dispatch_async(queue, ^{
        NSLog(@"%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"%@",[NSThread currentThread]);
    });
}

//同步函数+并发队列:不会开启线程，队列中的任务串行队列执行
-(void)syncConcurrent{
    dispatch_queue_t queue = dispatch_queue_create("com.speehocean.download", DISPATCH_QUEUE_CONCURRENT);
    //封装任务
    dispatch_sync(queue, ^{
        NSLog(@"%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"%@",[NSThread currentThread]);
    });
}

//同步函数+串行队列:不会开启线程，队列中的任务串行队列执行
-(void)syncSerial{
    dispatch_queue_t queue = dispatch_queue_create("com.speehocean.download", DISPATCH_QUEUE_SERIAL);
    //封装任务
    dispatch_sync(queue, ^{
        NSLog(@"%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"%@",[NSThread currentThread]);
    });
}
//异步函数+主队列:所有任务都在主线程执行，不会开启线程
-(void)asyncMain{
    dispatch_queue_t queue = dispatch_get_main_queue();
    //封装任务
    dispatch_async(queue, ^{
        NSLog(@"%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"%@",[NSThread currentThread]);
    });
}

//同步函数+主队列
-(void)syncMain{
    dispatch_queue_t queue = dispatch_get_main_queue();
    //封装任务
    dispatch_sync(queue, ^{
        NSLog(@"%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"%@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"%@",[NSThread currentThread]);
    });
}

//GCD线程通信
-(void)downloadImage{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //下载图片逻辑......
        
//       更新UI,
        //异步（dispatch_async）和同步（dispatch_sync）刷行都没问题，因为是在子线程中（dispatch_async）执行的
        dispatch_async(dispatch_get_main_queue(), ^{
            //刷新UI，self.imageView.image = image;
        });
        dispatch_sync(dispatch_get_main_queue(), ^{
            //刷新UI，self.imageView.image = image;
        });
    });
}

//延迟函数
-(void)delay{
    //1.延迟执行方法一
//    [self performSelector:@selector() withObject:nil afterDelay:1.0];
    //方法二：NSTimer
//    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector() userInfo:nil repeats:NO];
    //方法三：GCD
//    参数一：DISPATCH_TIME_NOW 从现在开始计时,延迟执行时间 2.0秒 GCD单位：纳秒
//    参数二：队列
//    参数三：操作函数
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)) ,queue,^{
        NSLog(@"%@",[NSThread currentThread]);
    });
}

//一次函数,多用于单例模式，一个APP只执行一次，（注意：不能在懒加载中使用）
-(void)once{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"%@",[NSThread currentThread]);
    });
}

//栅栏函数,控制多线程异步函数的执行顺序
-(void)barrier{
    //全局并发队列
    //栅栏函数不能使用全局并发队列
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_queue_t queue = dispatch_queue_create("", DISPATCH_QUEUE_CONCURRENT);
    
    //异步函数
    dispatch_async(queue, ^{
        NSLog(@"%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"%@",[NSThread currentThread]);
    });
    
    //栅栏函数不能使用全局并发队列，用异步dispatch_barrier_async,同步没必要用栅栏函数,栅栏函数之前的执行后才会继续向下执行

    dispatch_barrier_async(queue, ^{
        NSLog(@"++++++++++++++++++++++++++++++");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"%@",[NSThread currentThread]);
    });
}

//GCD快速迭代,开子线程和主线程一起并发执行
-(void)apply{
    //参数一：遍历次数
    //参数二：队列（并发队列）（注意：主队列会死锁，串行队列==for循环）
    //参数三：索引
    dispatch_apply(10, dispatch_get_global_queue(0, 0), ^(size_t iteration) {
        NSLog(@"iteration---%zd",iteration);
    });
}

//队列组，方式一，队列组管理队列
-(void)queueGroup1{
    //创建队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    //创建队列组
    dispatch_group_t group = dispatch_group_create();
    //异步函数
    /*
     封装任务
     把任务加入队列
    dispatch_async(queue, ^{
        
    });
    */
    /*
     封装任务
     把任务加入队列
     监听任务执行情况，通知group
     **/
    dispatch_group_async(group, queue, ^{
        NSLog(@"%@",[NSThread currentThread]);
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"%@",[NSThread currentThread]);
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"%@",[NSThread currentThread]);
    });
    //拦截通知，当组中所有任务执行完毕后，执行下面方法，内部本身异步的，不会阻塞此方法之后的代码执行
    dispatch_group_notify(group, queue, ^{
        NSLog(@"---dispatch_group_notify---");
    });
    
    //等待，当组中所有任务执行完毕后，才执行下面方法，DISPATCH_TIME_FOREVER死等,阻塞，执行完此方法后才能执行之后的代码
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
}

//队列组，方式二，老方法，队列组管理队列
-(void)queueGroup2{
    //创建队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    //创建队列组
    dispatch_group_t group = dispatch_group_create();
    //该方法后的异步任务将加入到队列组的监听范围,必须与dispatch_group_leave配对使用
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        NSLog(@"%@",[NSThread currentThread]);
        
        //通知队列组任务执行完毕,
        dispatch_group_leave(group);
    });
    //拦截通知，当组中所有任务执行完毕后，执行下面方法，内部本身异步的，不会阻塞之后的代码执行
    dispatch_group_notify(group, queue, ^{
        NSLog(@"---dispatch_group_notify---");
    });
}

//组队列下载图片合并成一张的例子
-(void)group3
{
    /*
     1.下载图片1 开子线程
     2.下载图片2 开子线程
     3.合成图片并显示图片 开子线程
     */
    
    //-1.获得队列组
    dispatch_group_t group = dispatch_group_create();
    
    //0.获得并发队列
    dispatch_queue_t queue =  dispatch_get_global_queue(0, 0);
    
    // 1.下载图片1 开子线程
    dispatch_group_async(group, queue,^{
        
        NSLog(@"download1---%@",[NSThread currentThread]);
        //1.1 确定url
        NSURL *url = [NSURL URLWithString:@"http://www.qbaobei.com/tuku/images/13.jpg"];
        
        //1.2 下载二进制数据
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        
        //1.3 转换图片
//        self.image1 = [UIImage imageWithData:imageData];
    });
    
    // 2.下载图片2 开子线程
     dispatch_group_async(group, queue,^{
         
         NSLog(@"download2---%@",[NSThread currentThread]);
         //2.1 确定url
        NSURL *url = [NSURL URLWithString:@"http://pic1a.nipic.com/2008-09-19/2008919134941443_2.jpg"];
        
        //2.2 下载二进制数据
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        
        //2.3 转换图片
//            self.image2 = [UIImage imageWithData:imageData];
    });

        //3.合并图片
        //主线程中执行
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
           
        NSLog(@"combie---%@",[NSThread currentThread]);
        //3.1 创建图形上下文
        UIGraphicsBeginImageContext(CGSizeMake(200, 200));
            
        //3.2 画图1
//       [self.image1 drawInRect:CGRectMake(0, 0, 200, 100)];
//       self.image1 = nil;
            
        //3.3 画图2
//       [self.image2 drawInRect:CGRectMake(0, 100, 200, 100)];
//       self.image2 = nil;
            
        //3.4 根据上下文得到一张图片
        UIImage *image =  UIGraphicsGetImageFromCurrentImageContext();
        //3.5 关闭上下文
        UIGraphicsEndImageContext();
                    
        //3.6 更新UI，如果dispatch_group_notify中传入的队列不是主队列则刷新UI操作需要放在主队列中执行
//        dispatch_async(dispatch_get_main_queue(), ^{
                    
                NSLog(@"UI----%@",[NSThread currentThread]);
//              self.imageView.image = image;
//        });
    });
//    6.0之前 GCD中使用了create或者retain都需要release操作
//    6.0之后已加入ARC管理不需要release
//    dispatch_release(group)
}

//dispatch_async和dispatch_async_f区别
-(void)test
{   //区别:封装任务的方法(一个是block，另一个是函数)
    // dispatch_async(dispatch_queue_t queue, ^{})
    //区别:封装任务的方法(block--函数)
    /*
     第一个参数:队列
     第二个参数:参数
     第三个参数:要调用的函数的名称
     */
    dispatch_async_f(dispatch_get_global_queue(0, 0), NULL, task);
    dispatch_async_f(dispatch_get_global_queue(0, 0), NULL, task);
    dispatch_async_f(dispatch_get_global_queue(0, 0), NULL, task);
}

void task(void *param)
{
    NSLog(@"%s---%@",__func__,[NSThread currentThread]);
}

#pragma mark - NSOperation
//NSOperation是一个抽象类，需要使用子类方法,开子线程需要和NSOperationQueue一起使用
//1.NSInvocationOperation
//2.NSBlockOperation
//3.自定义子类继承NSOperation,实现内部相应的方法
- (IBAction)signUp:(UIButton *)sender {
    //创建操作，封装任务
    //方法一NSInvocationOperation
    [self queue1];
    
    //方法二NSBlockOperation
    [self queue2];
    
    //方法三,简便操作
    [self queue3];
    
    //方法四，自定义子类继承NSOperation,实现内部相应的方法
    //重写main方法，自定义的好处，有利于代码隐蔽，有利于代码复用性
    [self queue4];
    
    //默认并发队列，控制队列变成串行，设置最大并发数为1，暂停以及取消
    [self queue5];
    
    //NSOperation添加依赖和监听
    [self queue6_7];
    
    //NSOperation线程通信
    [self queue8];
    
    //NSOperation下载图片合并成一张的例子
    [self queue9];
    
    
}

-(void)queue1{
    //参数一：目标对象，self
    //参数二：调用方法名称
    //参数三：方法接受的参数
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(download1) object:nil];
    //创建队列，与NSOperationQueue一起使用时才会开启子线程
    //与GCD不同 分两种，主队列和非主队列
    //主队列：[NSOperationQueue mainQueue] 和GCD的主队列一样，串行队列
    //非主队列：[[NSOperationQueue alloc] init] 非常特殊（同时具备并发和串行的功能），默认情况下，非主队列是并发队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    //添加操作到队列中
    [queue addOperation:op1];//内部已经调用了[op1 start]
    //启动操作
//    [op1 start];
}

-(void)download1{
    NSLog(@"%@",[NSThread currentThread]);
}

-(void)queue2{
    NSBlockOperation * op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"%@",[NSThread currentThread]);
    }];
    
    //追加任务
    //如果一个 （op2）操作的的任务数量大于1 ，则会开启子线程
    [op2 addExecutionBlock:^{
        NSLog(@"%@",[NSThread currentThread]);
    }];
    
    //创建队列
    NSOperationQueue *queue2 = [[NSOperationQueue alloc] init];
    //添加操作到队列中
    [queue2 addOperation:op2];//内部已经调用了[op2 start]
    //启动操作
//    [op2 start];
}

-(void)queue3{
    NSOperationQueue *queue3 = [[NSOperationQueue alloc] init];
    [queue3 addOperationWithBlock:^{
        NSLog(@"%@",[NSThread currentThread]);
    }];
}

-(void)queue4{
    SKNSOperation *op3 = [[SKNSOperation alloc] init];
    NSOperationQueue *queue4 = [[NSOperationQueue alloc] init];
    //添加操作到队列中
    [queue4 addOperation:op3];//内部已经调用了[op3 start]，start内部调用了main
}

-(void)queue5{
    //    串行执行任务 != 只开一条线程，（是因为同步执行）
        NSOperationQueue *queue5 = [[NSOperationQueue alloc] init];
        //最大并发数，同一时间最多有多少个任务可以执行，开启线程数=最大并发数+1
    //    maxConcurrentOperationCount>1 //并发队列
    //    maxConcurrentOperationCount==1 //串行队列
    //    maxConcurrentOperationCount==0 //不执行任务
        //maxConcurrentOperationCount==-1//默认，通常-1指的是最大值，不受限制
        queue5.maxConcurrentOperationCount = 1;
        
        //暂停执行，可以恢复 注意：不能暂停当前处于执行状态的任务
        /**
         队列中的任务也是有状态的：已经执行完毕｜正在执行｜排队等待执行
         暂停和取消只能影响排队等待执行的任务
         */
        /**
         如果是自定义的NSOperation
         暂停无效
         取消操作需要在main中处理，苹果官方建议，在耗时循环操作后添加取消
         if(self.isCancelled) return;
         */
        [queue5 setSuspended:YES];
        //继续执行
        [queue5 setSuspended:NO];
    //    取消执行,不可以恢复,该方法内部调用了所有操作的cancel方法
        [queue5 cancelAllOperations];
}

-(void)queue6_7{
    NSOperationQueue *queue6 = [[NSOperationQueue alloc] init];
    NSOperationQueue *queue7 = [[NSOperationQueue alloc] init];
    NSBlockOperation * op4 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"%@",[NSThread currentThread]);
    }];
    
    NSBlockOperation * op5 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"%@",[NSThread currentThread]);
    }];
    
    //操作监听
    //op5执行完成后执行
    op5.completionBlock = ^{
        NSLog(@"op5.completionBlock---%@",[NSThread currentThread]);
    };
    
    //添加依赖op4依赖op5,先执行op5后执行op4，可以夸队列以来
    //注意：不能循环依赖，互相依赖
    [op4 addDependency:op5];
    [queue6 addOperation:op4];
    [queue7 addOperation:op5];
}

-(void)queue8{
    //例：下载图片
    //开启子线程下载图片
    //1.非主队列
    NSOperationQueue *queue8 = [[NSOperationQueue alloc] init];
    //2.封装操作
    NSBlockOperation * download = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"%@",[NSThread currentThread]);
        //下载图片代码
        NSURL *url = [NSURL URLWithString:@"http://xxx/xxx/xxx.jpg"];
        NSData * imageData = [NSData dataWithContentsOfURL:url];
        UIImage*image = [UIImage imageWithData:imageData];
        
        //更新UI
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSLog(@"%@",[NSThread currentThread]);
//            self.imageView.image = image;
        }];
        
    }];
    [queue8 addOperation:download];
}

-(void)queue9{
    NSOperationQueue *queue9 = [[NSOperationQueue alloc] init];
    
    __block UIImage *image1;
    __block UIImage *image2;
    NSBlockOperation * download1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"%@",[NSThread currentThread]);
        //下载图片代码
        NSURL *url = [NSURL URLWithString:@"http://xxx/xxx/xxx.jpg"];
        NSData * imageData = [NSData dataWithContentsOfURL:url];
        image1 = [UIImage imageWithData:imageData];
    }];

    NSOperationQueue *queue10 = [[NSOperationQueue alloc] init];
    NSBlockOperation * download2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"%@",[NSThread currentThread]);
        //下载图片代码
        NSURL *url = [NSURL URLWithString:@"http://xxx/xxx/xxx.jpg"];
        NSData * imageData = [NSData dataWithContentsOfURL:url];
        image2 = [UIImage imageWithData:imageData];
    }];
    
    NSBlockOperation * combie = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"%@",[NSThread currentThread]);
        //3.1 创建图形上下文
        UIGraphicsBeginImageContext(CGSizeMake(200, 200));
            
        //3.2 画图1
//       [image1 drawInRect:CGRectMake(0, 0, 100, 200)];
//       image1 = nil;
            
        //3.3 画图2
//       [image2 drawInRect:CGRectMake(100, 0, 100, 200)];
//       image2 = nil;
            
        //3.4 根据上下文得到一张图片
        UIImage *image =  UIGraphicsGetImageFromCurrentImageContext();
        //3.5 关闭上下文
        UIGraphicsEndImageContext();
        
        //更新UI
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSLog(@"%@",[NSThread currentThread]);
//            self.imageView.image = image;
        }];
        
    }];
    //添加以来执行完download1和download2才能合成图片
    [combie addDependency:download1];
    [combie addDependency:download2];
    
    //添加到队列中
    [queue9 addOperation:download1];
    [queue9 addOperation:download2];
    [queue9 addOperation:combie];
}

#pragma mark - SDWebImage第三方框架
//使用SDWebImage也需要内存清理操作，内存警告等处理,需要在AppDelegate中的applicationDidReceiveMemoryWarning函数中处理
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //下载图片且要下载进度，内存缓存&磁盘缓存
//    [self SDWebDownload];
    
    //没有imageView时下载图片用SDWebImageManager,内存缓存&磁盘缓存
//    [self SDWebDownload2];
    
    //不需要做任何缓存操作，没有做任何缓存处理并且这个方法的completed是在子线程处理的，不能直接做UI刷新操作
//    [self SDWebDownload3];
    
    //播放gif
    [self SDWebDownload4];
    
    //判断图片类型
    [self SDWebDownload5];
}

-(void)SDWebDownload{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:@"https://t7.baidu.com/it/u=2621658848,3952322712&fm=193&f=GIF"] placeholderImage:[UIImage imageNamed:@"LoginScreen"] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        //下载进度
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        switch (cacheType) {
            case SDImageCacheTypeNone:
                NSLog(@"直接下载");
                break;
            case SDImageCacheTypeDisk:
                NSLog(@"磁盘缓存");
                break;
            case SDImageCacheTypeMemory:
                NSLog(@"内存缓存");
                break;
            default:
                break;
        }
    }];
}

-(void)SDWebDownload2{
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:@"https://t7.baidu.com/it/u=2621658848,3952322712&fm=193&f=GIF"] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        self.imageView.image = image;
    }];
}

-(void)SDWebDownload3{
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:@"https://t7.baidu.com/it/u=2621658848,3952322712&fm=193&f=GIF"] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            //data,图片的二进制数据
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                self.imageView.image = image;
            }];
        }];
}

-(void)SDWebDownload4{
    UIImage * image = [UIImage sd_animatedGIFNamed:@"sheep"];//gif图不要加.git扩展名
    self.imageView.image = image;
}

-(void)SDWebDownload5{
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://t7.baidu.com/it/u=2621658848,3952322712&fm=193&f=GIF"]];
    NSString * typeStr = [NSData sd_contentTypeForImageData:imageData];
    NSLog(@"%@",typeStr);
}


#pragma mark - NSCache
- (IBAction)NSCacheOnClick:(UIButton *)sender {
//    添加缓存
    [self addData];
//    检查缓存
//    [self checkData];
//    清除缓存
//    [self removeData];
}

-(void)addData{
    for(NSInteger i = 0;i < 10 ;i++){
        NSData * data =[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://t7.baidu.com/it/u=2621658848,3952322712&fm=193&f=GIF"]];
        //NSCache的setObject采用的是引用Strong，而NSDictionary采用的是拷贝copy
        //所以NSData放在for循环外面和里面是不同的，当在外面想当于对一个对象引用了10次，成本是1
//        放在for里面成本是10
//        方法一
//        [self.cache setObject:data forKey:@(i)];
//        方法二：cost:成本，需要提前设置总成本,当前设置总成本时10，所以存到地5个时，第0个会被释放.
        [self.cache setObject:data forKey:@(i) cost:1];
        NSLog(@"%zd",i);
    }
}

-(void)checkData{
    for(NSInteger i = 0;i < 10 ;i++){
        NSData * data = [self.cache objectForKey:@(i)];
        if(data){
            NSLog(@"%zd",i);
        }
    }
}

-(void)removeData{
    [self.cache removeAllObjects];
}

#pragma mark - NSCacheDelegate
//即将回收对象的时候调用的代理方法
- (void)cache:(NSCache *)cache willEvictObject:(id)obj{
    NSLog(@"%zd",[obj length]);
}

#pragma mark - RunLoop
//Foundation->NSRunLoop
//Core Foundation->CFRunLoopRef
- (IBAction)RunLoopOnClick:(UIButton *)sender {
    //Foundation->NSRunLoop
    //获得主线程的runloop
    NSRunLoop * mainRunLoop = [NSRunLoop mainRunLoop];
    //获得当前线程的runloop
    NSRunLoop * currentRunLoop = [NSRunLoop currentRunLoop];
    
    //Core Foundation->CFRunLoopRef
    //获得主线程的runloop
    CFRunLoopGetMain();
    //获得当前线程的runloop
    CFRunLoopGetCurrent();
    
//    NSRunLoop,CFRunLoopRef相互转换
    NSLog(@"mainRunLoop.getCFRunLoop---%p",mainRunLoop.getCFRunLoop);
    
    //runloop与线程的关系
    //一一对应，主线程的runloop已经创建，子线程的需要手动创建
    [[[NSThread alloc] initWithTarget:self selector:@selector(runLoopDemo) object:nil] start];
    
    //在runloop有多个运行模式mode，但是只能选择一种模式运行
    //模式mode里至少有一个timer或者是source
    [self timerRunLoopDemo2];
    
    //GCD定时器，绝对精准无法被模式影响
    [self runLoopDemo4];
    
    //CFRunLoopObserver
    [self runLoopDemo5];
    
    //常驻线程
    [self runLoopDemo6];
    
}

//子线程创建runloop,用currentRunLoop创建，是懒加载的，当前子线程没有runloop所以会创建
-(void)runLoopDemo{
    NSLog(@"runLoopDemo---%@",[NSThread currentThread]);
    [NSRunLoop currentRunLoop];
}

-(void)timerRunLoopDemo2{
    //创建定时器，方法一
    NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(runLoopDemo2) userInfo:nil repeats:YES];
//    添加定时器到Runloop中
    //参数一：定时器
    //参数二：运行模式,NSDefaultRunLoopMode默认,UITrackingRunLoopMode界面追踪,NSRunLoopCommonModes通用
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
//    创建定时器，方法二
//    如果该方法在子线程中创建，则不会工作，因为子线程默认是没有runloopd的，必须在子线程中手动先创建runloop
    //该方法会自动添加runloop，并且模式为默认
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self  selector:@selector(runLoopDemo2) userInfo:nil repeats:YES];
//    在子线程中创建
    [NSThread detachNewThreadSelector:@selector(runLoopDemo3) toTarget:self withObject:nil];
}

-(void)runLoopDemo2{
    NSLog(@"runLoopDemo---%@",[NSThread currentThread]);
    NSLog(@"runLoopDemo---%@",[NSRunLoop currentRunLoop].currentMode);
}

-(void)runLoopDemo3{
    NSRunLoop *currentRunloop = [NSRunLoop currentRunLoop];
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self  selector:@selector(runLoopDemo2) userInfo:nil repeats:YES];
    [currentRunloop run];
}


-(void)runLoopDemo4{
    //创建定时器，定时器需要设置强引用，不然无法启动
    //参数一：source的类型,DISPATCH_SOURCE_TYPE_TIMER,表示定时器
//    参数二：描述信息，线程ID
//    参数三：更详细的描述信息
//    参数四：队列，决定GCD中的任务在哪个线程中执行
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    //设置定时器
//    参数一：定时器
//    参数二：起始时间，DISPATCH_TIME_NOW现在开始
//    参数三：间隔时间,2.0，GCD中单位纳秒
//    参数四：精准度,绝对精准0
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 2.0*NSEC_PER_SEC, 0*NSEC_PER_SEC);
    //设置定时器执行的任务
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"runLoopDemo---%@",[NSThread currentThread]);
    });
    //启动执行
    dispatch_resume(timer);
    //设置强引用，不然无法启动
    self.timer = timer;
}


-(void)runLoopDemo5{
    //创建监听者
//    参数一：怎么分配存储空间，默认
//    参数二：要监听的状态
    //    kCFRunLoopEntry = (1UL << 0),即将进入runloop
    //    kCFRunLoopBeforeTimers = (1UL << 1),即将处理timer事件
    //    kCFRunLoopBeforeSources = (1UL << 2),即将处理source事件
    //    kCFRunLoopBeforeWaiting = (1UL << 5),即将进入睡眠
    //    kCFRunLoopAfterWaiting = (1UL << 6),被唤醒
    //    kCFRunLoopExit = (1UL << 7),退出runloop
    //    kCFRunLoopAllActivities = 0x0FFFFFFFU,所有状态
//    参数三：是否持续监听
//    参数四：优先级，总是传0
//    参数五：当状态改变时候的回调
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        switch (activity) {
            case kCFRunLoopEntry:
                NSLog(@"kCFRunLoopEntry");
                break;
            case kCFRunLoopBeforeTimers:
                NSLog(@"kCFRunLoopBeforeTimers");
                break;
            case kCFRunLoopBeforeSources:
                NSLog(@"kCFRunLoopBeforeSources");
                break;
            case kCFRunLoopBeforeWaiting:
                NSLog(@"kCFRunLoopBeforeWaiting");
                break;
            case kCFRunLoopAfterWaiting:
                NSLog(@"kCFRunLoopAfterWaiting");
                break;
            case kCFRunLoopExit:
                NSLog(@"kCFRunLoopExit");
                break;
            default:
                break;
        }
    });
    
    //添加监听者
    //参数一：要添加的Runloop
    //参数二:监听者
    //参数三：运行模式,kCFRunLoopDefaultMode,kCFRunLoopCommonModes
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopCommonModes);
    
}

-(void)runLoopDemo6{
    self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(taskRunLoop) object:nil];
    [self.thread start];
}

//让self.thread在执行过程中，点击otherBtnClick后让self.thread去执行taskRunLoop2后在回来执行taskRunLoop
- (IBAction)otherBtnClick:(UIButton *)sender {
    [self performSelector:@selector(taskRunLoop2) onThread:self.thread withObject:nil waitUntilDone:YES];
}
//让任务一直进行,开启一个runloop,让runloop不退出，所以runloop的中必须有source或者timer
-(void)taskRunLoop{
    NSLog(@"taskRunLoop---%@",[NSThread currentThread]);
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    //添加timer
//    NSTimer * timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(taskRunLoop2) userInfo:nil repeats:YES];
//    [runloop addTimer:timer forMode:NSDefaultRunLoopMode];
    //添加source
    [runloop addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
    [runloop run];
    NSLog(@"taskRunLoop---end---%@",[NSThread currentThread]);
}
-(void)taskRunLoop2{
    NSLog(@"taskRunLoop2---%@",[NSThread currentThread]);
}

#pragma mark - 网络编程
//NSURLConnection,古老
//NSURLSession，推荐
//CFNetwork，纯C，底层
//第三方AFNetworking(推荐),MKNetworkKit
- (IBAction)netWorkOnClick:(UIButton *)sender {
    //NSURLConnection->GET，以及URL的中文转码
    [self netWork1];
    
    //NSURLConnection->POST，请求体，无需中文转码
    [self netWork2];
    
    //框架提示框SVProgressHUD，以及截取字符串,
//    解析json（4种方式，NSJSONSerialization第三方框架：JSONKit(推荐),SBJson,TouchJSON）
//  解析xml
    [self netWork3];
    
    //文件下载，大文件下载，文件句柄，输出流
    [self netWork4];
    
    //文件上传，MIMEType,//压缩推荐第三方框架SSZipArchive，https://github.com/ZipArchive/ZipArchive/blob/master/Example/ObjectiveCExample/ViewController.m
    [self netWork5];
    
    //NSURLSession，用完释放,可以在dealloc中释放[session invalidateAndCancel]或者[session finishTasksAndInvalidate]
    [self netWork6];
    //NSURLSession下载，断点下载， 离线断点下载（退出后重新打开后的断点下载）
    [self netWork7];
    //NSURLSession上传，NSURLSessionConfiguration介绍,参考other/NSURLConfiguration.txt
    [self netWork8];
    
    //AFN第三方框架的使用；序列化；监测网络状态AFNetworkReachabilityManager；小技巧：写一个工具类，封装AFN来调用；
    [self netWork9];
    //数据安全，青花瓷（charles）设计代理，可以拦截手机请求数据,手机和电脑在同一局域网，手机网络代理设置成电脑IP
    //导入Tool/SecretTool
    //base64编码，RSA加密，哈希(散列)函数MD5,SHA1,SHA256,对称加密DES,3DES,AES(高级加密).HMAC
    //MD5防破解,1.加盐,2.加密乱序之后在MD5，3，加盐加密乱序MD5（可以进行多重复杂操作）
    //HMAC，需要先给定一个密钥
    [self netWork10];
    
    //URLSession 发送 https请求
    [self netWork11];
    
    //AFN发送https请求
    [self netWork12];

}

-(void)netWork1{
    //请求路径,中文需转码
    NSURL *url = [NSURL URLWithString:[@"http://123.com?user=中文转码&pass=123" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] ;
    //创建请求对象
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
//    NSURLResponse真实类型是NSHTTPURLResponse,替换后可以获取状态码
//    NSURLResponse *response = nil;
    NSHTTPURLResponse *response = nil;
    //    get请求没有请求体，设置请求头，不设置会自动生成默认的
    
    //1.发送同步的网络请求
    //参数一：请求对象
//    参数二：响应头信息
//    参数三：错误信息
    NSData *data =[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    //解析data
    NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    NSLog(@"%zd",response.statusCode);
    
    //2.发送异步的网络请求
    //参数一：请求对象
//    参数二：队列，决定completionHandler代码块的调用线程,而不是sendAsynchronousRequest在哪调用
//    参数三：请求完成回调{response响应头，data响应体，connectionError错误信息}
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        //容错处理
        if(connectionError){
            //错误
            return;
        }
        NSHTTPURLResponse *res = (NSHTTPURLResponse*)response;
        NSLog(@"%zd",res.statusCode);
    }];
    
    //3.设置代理发送请求,遵守NSURLConnectionDataDelegate协议
//    方法一,设置代理并发送请求
    [NSURLConnection connectionWithRequest:request delegate:self];
//    方法二，设置代理并发送请求
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    方法三，设置代理，如果startImmediately是YES会发送请求，如果是NO不发送，需要手动发送请求start
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [conn start];
}
#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    //接收到服务器响应时候调用
    //获取本次请求文件的总大小，断点下载时每次请求不一样，需放在if判断self.currentSize之后,如果放在前面可以response.expectedContentLength+self.currentSize
//    if(self.currentSize>0){
//        return;
//    }
    NSLog(@"%lld",response.expectedContentLength);
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
//    接收到服务器返回的数据时候调用，如果返回数据过大，一次请求可能会相应多次
    //如果返回多次，拼接返回数据
    [self.requestData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
//    请求失败时调用
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
//    请求结束时调用,解析数据
    //解析data
    NSLog(@"%@",[[NSString alloc] initWithData:self.requestData encoding:NSUTF8StringEncoding]);
}

-(void)netWork2{
    NSURL *url = [NSURL URLWithString:@""];
//    设置请求方法，默认是GET，需要设置POST，需定义可变请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";//必须大写，否则无效
    request.timeoutInterval = 10;//请求超时
//    设置请求头
    [request setValue:@"ios 10.1" forHTTPHeaderField:@"User-Agent"];
    //设置请求体，无需中文转码
    request.HTTPBody = [@"user=无需转码&pass=123" dataUsingEncoding:NSUTF8StringEncoding];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSHTTPURLResponse *res = (NSHTTPURLResponse*)response;
        NSLog(@"%zd",res.statusCode);
        
        //如果DATA是中文，控制台输出是乱码，可以重写系统方法，给NSDictory写分类NSDictionary+Log.m和给NSArray写分类NSArray+Log.m,注意：重写系统方法，不需要在应用的地方引入头文件，并且不需要.h文件，但是需要引入Foundation.h,所以直接写Foundation的分类Foundation+Log.m
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"%@",dict);
    }];
}

-(void)netWork3{

    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];//黑色遮罩
//截取字符串
    NSInteger loc =[@"abc:sd#" rangeOfString:@":"].location+1;
    NSInteger len =[@"abc:sd#" rangeOfString:@"#"].location-loc;
    NSString *str = [@"abc:sd#" substringWithRange:NSMakeRange(loc,len)];
    NSLog(@"%@",str);
    if([@"abc:sd#" containsString:@"sd"]){
        NSLog(@"abc:sd#中存在sd");
    }
    [SVProgressHUD showErrorWithStatus:str];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
    
    //解析JSON
//    JSON->OC 反序列化
//    NSJSONReadingMutableContainers = (1UL << 0),可变字典和数组
//    NSJSONReadingMutableLeaves = (1UL << 1),忽略不用，IOS7之后有问题，内部所有字符串都是可变的
//    NSJSONReadingFragmentsAllowed = (1UL << 2),既不是字典也不是数组
    
    NSData *data =  [@"\{\"error\":\"错误\"}" dataUsingEncoding:NSUTF8StringEncoding];
    id obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"%@---%@",[obj class],obj);
//    OC->JSON 序列化
    NSDictionary *dictM = @{
        @"name":@"abc",
        @"age":@3
    };
//    判断字符串能不能转换json
    if([NSJSONSerialization isValidJSONObject:dictM]){
       NSData * data = [NSJSONSerialization dataWithJSONObject:dictM options:NSJSONWritingPrettyPrinted error:nil];
        [data writeToFile:@"xxx.json" atomically:YES];
    }
    //播放视频//引入MediaPlayer.h
    MPMoviePlayerViewController *movvc = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:@"xxx"]];
    [self presentViewController:movvc animated:YES completion:nil];
    
    //MJExtension使用
    //字典转模型
    //当属性名与字典中Key不一致时，设置对应关系
    [SKMJExtensionModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
            @"NAME":@"name",
        };
    }];
    [SKMJExtensionModel mj_objectArrayWithKeyValuesArray:dictM];
    
    //解析XML，解析方式：DOM（一次性读取占内存），SAX（按行解析，适合大文件）
    //原生NSXMLParser(SAX方式)
    NSData *dataXML =  [@"<A><b name=\"b\" age=\"1\">b</b></A>" dataUsingEncoding:NSUTF8StringEncoding];
    //创建XML解析器
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataXML];
    //设置代理
    parser.delegate = self;
    //开始解析,此方法是阻塞的，执行完才会向下执行
    [parser parse];
    
    //第三方框架推荐：GDataXML(DOM方式)https://github.com/neonichu/GDataXML
        //libxml2:纯C支持DOM，SAX
}

#pragma mark - NSXMLParserDelegate
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{
    //开始解析XML中的每个元素就会调用一次
    //单个字典转淡个模型
    if([elementName isEqualToString:@"A"]){
        return;//根元素就不进行操作
    }
    [SKMJExtensionModel mj_objectWithKeyValues:attributeDict];
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    //结束解析XML中的每个元素就会调用一次
}
- (void)parserDidStartDocument:(NSXMLParser *)parser{
    //开始解析XML
}
- (void)parserDidEndDocument:(NSXMLParser *)parser{
    //结束解析XML
}

-(void)netWork4{
    NSURL *url = [NSURL URLWithString:@""];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    //无进度
    
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
//        //图片
//        UIImage *image = [UIImage imageWithData:data];
//        //视频
//        NSString * fullpath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"123.mp4"];
//        [data writeToFile:fullpath atomically:YES];
//
//    }];
    
    //查看进度，使用代理,NSURLConnectionDataDelegate
//    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    //大文件下载，在代理方法didReceiveData中直接写入沙盒，追加数据到文件中
    
    //方法一：用文件句柄
    //创建空文件，追加数据,在代理方法didReceiveResponse中操作
    [[NSFileManager defaultManager] createFileAtPath:@"路径/xx.txt" contents:nil attributes:nil];
    
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:@"路径/xx.txt"];
    //写文件，在代理方法didReceiveData中写，追加
    [handle seekToEndOfFile];//句柄移动到文件最后
//    [handle seekToFileOffset:1];//句柄移动到某个位置
//    [handle writeData:data];//写文件
    //写完需要释放关闭句柄，在代理方法connectionDidFinishLoading中操作
    [handle closeFile];
    handle = nil;
    
    //方法二：用输出流
    //创建输出流,如果没文件，会自动创建
    //参数一：文件路径
    //参数二：是否追加，YES追加,NO覆盖
    NSOutputStream *steam = [[NSOutputStream alloc] initToFileAtPath:@"路径/xx.txt" append:YES];
//    打开输出流
    [steam open];
    //写数据
//    [steam write:data.bytes maxLength:data.length];
    //关闭流
    [steam close];
    //文件断点下载,设置请求头
    //开始下载
    NSMutableURLRequest *muRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    //Range:bytes=0-499,表示下载0到499个字节
    //Range:bytes=500-,表示下载500字节以后的
//    [muRequest setValue:[NSString stringWithFormat:@"bytes=%zd-",当前大小] forHTTPHeaderField:@"Range"];
    NSURLConnection * connection = [NSURLConnection connectionWithRequest:muRequest delegate:self];
    
    //取消下载
    [connection cancel];
}

-(void)netWork5{
// 设置请求头
//    Content-Type:mutipart/form-data; boundary=----WebKitFormBoundary....
//按着固定格式拼接请求体数据
//    ------WebKitFormBoundary....
//    Content-Dispostion:form-data; name="file"; filename="xxx.png"
//    Content-Type:image/png
//    ------WebKitFormBoundary....
//    Content-Dispostion:form-data; name="username"
//
//    123456
//    ------WebKitFormBoundary....--
    
    
    NSURL *url = [NSURL URLWithString:@""];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";//必须大写，否则无效
//    设置请求头
    [request setValue:@"mutipart/form-data; boundary=----WebKitFormBoundary...." forHTTPHeaderField:@"Content-Type"];
    NSMutableData *fileData = [NSMutableData data];
/**   拼接请求体
 分隔符：----WebKitFormBoundary....
   1）文件参数
    --分隔符
    Content-Dispostion:form-data; name="file"; filename="xxx.png"
    Content-Type:image/png（MIMEType:大类型/小类型）
    空行
    文件参数
 */
    
    [fileData appendData:[@"------WebKitFormBoundary...." dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:[@"Content-Dispostion:form-data; name=\"file\"; filename=\"xxx.png\"" dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:[@"Content-Type:image/png" dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];//空行
    UIImage *image = [UIImage imageNamed:@"xx.png"];
    NSData *imageData = UIImagePNGRepresentation(image);
    [fileData appendData:imageData];
    [fileData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
/**
 2）非文件参数
    --分隔符
    Content-Dispostion:form-data; name="username"
    空行
    123456
 */
    [fileData appendData:[@"------WebKitFormBoundary...." dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:[@"Content-Dispostion:form-data; name=\"username\"" dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];//空行
    [fileData appendData:[@"123456" dataUsingEncoding:NSUTF8StringEncoding]];
    [fileData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
 /**
 3)结尾标识
    --分隔符--
*/
    [fileData appendData:[@"------WebKitFormBoundary....--" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置请求体
    request.HTTPBody = fileData;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            //解析数据
        NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    
    //补充：如何获得文件的MIMEType
    //1.对要文件发送请求，响应头内部有MIMEType
    NSURL * fileurl= [NSURL fileURLWithPath:@""];
    NSURLRequest* requestfile = [NSURLRequest requestWithURL:fileurl];
    [NSURLConnection sendAsynchronousRequest:requestfile queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
       //获得文件类型
        NSLog(@"%@",response.MIMEType);
    }];
//    2.百度
//    3.调用C语言API,#import <MobileCoreServices/MobileCoreServices.h>
    NSString * mimeType = [self mimeTypeForFileAtPath:@"path"];
    NSLog(@"%@",mimeType);
}

-(NSString *) mimeTypeForFileAtPath:(NSString*)path{
    if(![[[NSFileManager alloc] init] fileExistsAtPath:path]){
        return nil;
    }
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[@"path"  pathExtension], NULL);
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    if(!MIMEType){
        return @"application/octet-stream";//表示任意的二进制类型，通用类型
    }
    return (__bridge NSString*)(MIMEType);
    
    //压缩文件
    //参数一：压缩文件完成的存放位置
//    参数二：要压缩哪些文件的路径数组
//    参数三：密码
//    参数四：进度
    [SSZipArchive createZipFileAtPath:@"finishPath" withFilesAtPaths:@[@"path1",@"path2",@"path3"] withPassword:@"密码" progressHandler:^(NSUInteger entryNumber, NSUInteger total) {
        NSLog(@"%zd---%zd",entryNumber,total);
    }];
    //压缩文件夹
    //参数一：压缩文件完成的存放位置
//    参数二：要压缩哪些文件夹的路径
//    参数三：是否保存父文件夹
//    参数四：压缩等级
//    参数五：密码
//    参数六：是否AES加密
//    参数七：进度
//    参数八：是否保留符号连接
    [SSZipArchive createZipFileAtPath:@"finishPath" withContentsOfDirectory:@"directoryPath" keepParentDirectory:NO compressionLevel:-1 password:@"密码" AES:YES progressHandler:^(NSUInteger entryNumber, NSUInteger total) {
        NSLog(@"%zd---%zd",entryNumber,total);
    } keepSymlinks:NO];
    
//    解压缩
    //参数一：要解压的文件路径
//    参数二：解压到哪的文件路径
//    参数三：保留属性
//    参数四：覆盖
//    参数五：嵌套压缩级别
//    参数六：密码
//    参数七：错误信息
//    参数八：代理SSZipArchiveDelegate
//    参数九：解压进度
//    参数十：解压完成回调
    [SSZipArchive unzipFileAtPath:@"path" toDestination:@"finishPath" preserveAttributes:YES overwrite:YES nestedZipLevel:0 password:@"密码" error:nil delegate:NO progressHandler:^(NSString * _Nonnull entry, unz_file_info zipInfo, long entryNumber, long total) {
            //进度
            NSLog(@"%zd---%zd",entryNumber,total);
        } completionHandler:^(NSString * _Nonnull path, BOOL succeeded, NSError * _Nullable error) {
            //完成
        }];
    
    //设置代理方法在指定线程调用
    NSURLRequest *requestdelegate = [NSURLRequest requestWithURL:[NSURL URLWithString:@""]];
//    方法一
    NSURLConnection *connectiondelegate =  [NSURLConnection connectionWithRequest:requestdelegate delegate:self];
    [connectiondelegate setDelegateQueue:[[NSOperationQueue alloc] init]];
    //方法二
    NSURLConnection *connectiondelegate2 = [[NSURLConnection alloc] initWithRequest:requestdelegate delegate:self startImmediately:NO];//startImmediately是否马上发送请求yes马上，NO调用start开始
    [connectiondelegate2 setDelegateQueue:[[NSOperationQueue alloc] init]];
    [connectiondelegate2 start];
    
    //补充，注意
    //在子线程中直接调用[NSURLConnection connectionWithRequest]，代理方法失效
//    但是initWithRequestcai采用start启动,就没问题，应为start方法会自动创建runloop
    //原理：该方法内部会将NSURLConnection作为source添加到runloop中，指定运行模式为默认，当所有代理方法执行完毕会释放掉。
// 解决方法：   因为他是依赖runloop的，子线程默认runloop不开启,所以需要手动开启runloop[[NSRunLoop currentRunLoop] run];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSURLConnection *connectiondelegate3 =  [NSURLConnection connectionWithRequest:requestdelegate delegate:self];
        [connectiondelegate3 setDelegateQueue:[[NSOperationQueue alloc] init]];
        [[NSRunLoop currentRunLoop] run];
    });
    
}

-(void)netWork6{
    //NSURLSessionTask
    //1.NSURLSessionDataTask,普通请求
    //2.NSURLSessionDownloadTask,下载请求
    //3.NSURLSessionUploadTask,上传请求
    
    //get请求
//    1.确定url
    NSURL *url = [NSURL URLWithString:@""];
//    2.创建亲求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //3.创建会话对象
    NSURLSession *session = [NSURLSession sharedSession];
//    4.创建task
    NSURLSessionDataTask *datatask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //请求完成后调用
        //completionHandler是子线程调用！！！
        //解析数据
    }];
    //5.执行task
    [datatask resume];
    
    //get请求简便方法,直接调用dataTaskWithURL，不用创建request
    //dataTaskWithURL内部会自动将请求路径作为参数创建一个请求对象request
    NSURLSessionDataTask *datatask2 = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //请求完成后调用
        //completionHandler是子线程调用！！！
        //解析数据
    }];
    [datatask2 resume];
    
    //post请求
    NSMutableURLRequest *request2 = [NSMutableURLRequest requestWithURL:url];
    request2.HTTPMethod=@"POST";
    request2.HTTPBody = [@"" dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *datatask3 = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //请求完成后调用
        //completionHandler是子线程调用！！！
        //解析数据
        
    }];
    [datatask3 resume];
    
    //NSURLSessionDataDelegate
    //参数一：配置
//    参数二：代理
//    参数三：代理方法在哪个线程中调用
    NSURLSession *session2 = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *datatask4 = [session2 dataTaskWithRequest:request];
    [datatask4 resume];
    
}

#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
 //接收到服务器的响应,默认会取消该请求，需要把completionHandler传回系统，告诉系统不要取消请求
    //session会话对象
    //datatask请求对象
    //response相应头
    //completionHandler回调，要求我们传给系统的
    NSLog(@"%s",__func__);
//    NSURLSessionResponseCancel//取消
//    NSURLSessionResponseAllow//接收
//    NSURLSessionResponseBecomeDownload//编程下载任务
//    NSURLSessionResponseBecomeStream//变成下载任务
    
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    //接收数据，会调用多次
//   定义属性 NSMutableData * filedata，懒加载，在这里拼接数据
//    [filedata appendData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
//    请求结束，成功或失败
}

-(void)netWork7{
    NSURL *url = [NSURL URLWithString:@""];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    //内部已经实现了边接收数据写入沙盒（tmp的操作）
    NSURLSessionDownloadTask *downTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //location,下载临时文件路径，下载完就会被删除，所以需要进行文件移动操作保存文件
        //response,响应头
        //error,错误
        NSString * filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];//suggestedFilename响应头中推荐的名称
        [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:filePath] error:nil];
    }];
    [downTask resume];
    
    //大文件下载，监听文件下载进度,代理NSURLSessionDownloadDelegate
    NSURLSession *session2 = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDownloadTask *downtask2 = [session2 downloadTaskWithRequest:request];
    //开始
    [downtask2 resume];
    
    //断点下载
    //暂停，可以恢复
    [downtask2 suspend];
    //取消，不能恢复,调用resume无效
    [downtask2 cancel];
    //取消，可以恢复
    [downtask2 cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        //恢复下载的数据 != 文件数据 ；而是下载信息数据，需要保存resumData，并且重启downtask，
//        定义一个属性NSData * resumData
//        self.resumData = resumeData;
    }];
    //恢复下载或者开始下载,先判断是否被取消
//    if(self.resumeData){
//        [self.session downloadTaskWithResumeData:self.resumeData];
//    }
//    [downtask2 resume];
    
    
    
//    离线断点下载（退出后重新打开后的断点下载）需要使用NSURLSessionDataTask
//    需要给datatask3创建懒加载，并且设置请求头，可以实现恢复下载逻辑
    //----start---1
        NSURLSession *session3 = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];//session可采懒加载
        NSMutableURLRequest *requestM = [NSMutableURLRequest requestWithURL:url];
        NSURLSessionDataTask *datatask3 = [session3 dataTaskWithRequest:requestM];
        //获得指定文件大小，赋值给self.currentSize
        NSDictionary *fileinfodict = [[NSFileManager defaultManager] attributesOfItemAtPath:@"获取已经下载的文件路径self.fullpath" error:nil];
        if(fileinfodict){
            //    self.currentSize = [fileinfodict[@"NSFileSize"] intrgerValue];
        }
        else{
//            self.currentSize = 0;
        }
        NSString * range = [NSString stringWithFormat:@"bytes=%zd-",@"已经下载的下载数self.currentSize"];
        [requestM setValue:range forHTTPHeaderField:@"Range"];
        //开始/恢复
        [datatask3 resume];
    //--end---1

    //----start---2
        //代理方法中实现
        //1.创建句柄，和空文件，在代理方法didReceiveResponse中写
        NSString * fullpath =@"路径/xx.txt";//写懒加载创建路径self.fullpath
    //    if(@"已经下载的下载数self.currentSize" == 0){//防止暂停或取消后重复创建文件覆盖原文件
            [[NSFileManager defaultManager] createFileAtPath:fullpath contents:nil attributes:nil];
    //    }
        
        NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:@"路径/xx.txt"];
        [handle seekToEndOfFile];//句柄移动到文件最后
    
        //2.写文件，在代理方法didReceiveData中写，追加
    //写文件，writeData就是自动追加的，所以不用每次都seekToEndOfFile一次，只需要创建handle时移动动一次
    //    [handle writeData:data];
        //3.写完需要释放关闭句柄，在代理方法connectionDidFinishLoading中操作
        [handle closeFile];
        handle = nil;
    //--end---2
    //暂停
    [datatask3 suspend];
    //取消,只有不可恢复的取消
    [datatask3 cancel];
    datatask3 = nil;
    //恢复，取消时设置为nil,这样重新调用会执行懒加载逻辑，重新创建session就可以恢复下载
    [datatask3 resume];
    
}

#pragma mark - NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    //bytesWritten,本次写入的数据大小
    //totalBytesWritten,已经下载的大小
    //totalBytesExpectedToWrite,文件总大小
    NSLog(@"%f",1.0*totalBytesWritten/totalBytesExpectedToWrite);
    
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes{
    //恢复下载时调用
    //fileOffset，从什么地方开始下载
    //expectedTotalBytes，文件总大小
}
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    //完成下载
    //location，临时下载文件路径
    NSString * filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:downloadTask.response.suggestedFilename];//suggestedFilename响应头中推荐的名称
    [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:filePath] error:nil];
}
//- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
////    请求结束，成功或失败
//}

-(void)netWork8{
    NSURL *url = [NSURL URLWithString:@""];
    //post请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod=@"POST";
    //请求头
    [request setValue:@"mutipart/form-data; boundary=----WebKitFormBoundary...." forHTTPHeaderField:@"Content-Type"];
    //拼接请求体。省略同上
    NSMutableData *data = [NSMutableData data];
    [data appendData:[@"" dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    //遵守NSURLSessionDataDelegate
    //参数一：请求
    //参数二：请求体
//    参数三：回调
   NSURLSessionUploadTask * uploadTask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
           //解析数据
    }];
    [uploadTask resume];
    
}
#pragma mark - 上传也遵守NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend{
    //bytesSent,本次上传的数据
    //totalBytesSent，总共上传完成的数据
//    totalBytesExpectedToSend，文件总大小
}

-(void)netWork9{
//    1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //    序列化
    //    默认接口是JSON方式解析的
    //    修改解析方法，XML
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    //注意返回的数据既不是XML也不是JSON,而是httpdata
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //修改AFN能否接收某个类型数据（例如：text/html）修改acceptableContentTypes，或者在源码里搜索acceptableContentTypes，直接修改源码
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
//    2.发送GET请求，自动启动resume
    NSDictionary *paradict =@{
        @"user":@"abc",
        @"pwd":@"123"
    };
    NSDictionary *headerdict =@{
        @"User-Agent":@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/97.0.4692.99 Safari/537.36",
    };
//    参数一：请求路径不包含参数
//    参数二：参数（字典）
//    参数三：头信息
//    参数四：进度回调
//    参数五：成功回调
//    参数六：失败回调
    [manager GET:@"" parameters:paradict headers:headerdict progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%f",1.0*downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //task，请求任务
            //responseObject，响应体（已经进行了JSON->OC对象）
            NSLog(@"%@---%@",[responseObject class],responseObject);
            
//            如果返回时httpdata,如果是图片
//            UIImage *image = [UIImage imageWithData:responseObject];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error---%@",error);
        }];
    
//    2.发送PSOT请求，自动启动resume，可上传文件//推荐
    //    参数一：请求路径不包含参数
    //    参数二：非文件参数（字典）
    //    参数三：头信息
    //    参数四：追加formdata 上传数据
    //    参数五：进度回调
    //    参数六：成功回调
    //    参数七：失败回调
    [manager POST:@"" parameters:paradict headers:headerdict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileData:[@"文件数据" dataUsingEncoding:NSUTF8StringEncoding] name:@"file" fileName:@"文件名" mimeType:@"multipart/form-data"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"%f",1.0*uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //task，请求任务
            //responseObject，响应体（已经进行了JSON->OC对象）
            NSLog(@"%@---%@",[responseObject class],responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error---%@",error);
        }];
    
    //下载,需要手动启动resume
    NSURL *url = [NSURL URLWithString:@""];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //    参数一：请求对象
    //    参数二：进度
    //    参数三：回调（目标位置），有返回值
    //    参数四：完成回调
    NSURLSessionDownloadTask *downtask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%f",1.0*downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //需要返回值NSURL
//        targetPath：临时文件路径
        //response：响应头
        return [NSURL fileURLWithPath:@"filepath"];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
//        filePath：最终文件路径
        NSLog(@"error---%@",error);
    }];
    
    [downtask resume];
    
    
    //上传,需要手动启动resume，//不推荐
    //需要先拼接request的请求头和请求体信息
    NSURLSessionDataTask *uploadtask = [manager uploadTaskWithRequest:request fromData:[@"文件数据" dataUsingEncoding:NSUTF8StringEncoding] progress:^(NSProgress * _Nonnull uploadProgress) {
            NSLog(@"%f",1.0*uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
        } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            NSLog(@"error---%@",error);
        }];
    [uploadtask resume];
    
    //监测网络状态
    AFNetworkReachabilityManager * netManager = [AFNetworkReachabilityManager sharedManager];
    //监测
    [netManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
    //        status,网络状态
//        AFNetworkReachabilityStatusUnknown,未知
//        AFNetworkReachabilityStatusNotReachable，没有
//        AFNetworkReachabilityStatusReachableViaWWAN ，蜂窝
//        AFNetworkReachabilityStatusReachableViaWiFi ，wifi
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"窝");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"wifi");
                break;
            default:
                break;
        }
    }];
    //开始监听
    [netManager startMonitoring];
}

-(void)netWork10{
//    MAC控制台：base编码命令 echo - n A |base64
    //对文件编码base64 123.png -o 123.txt
//    base解码命令 echo - n QQ== |base64 -D
    //对文件解码base64 123.txt -o 123.png -D
//    base64编码
//    先转换二进制数据
    NSData *data = [@"string" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64str = [data base64EncodedStringWithOptions:0];
    NSLog(@"bast64===%@",base64str);
//    base64解码
    NSData *base64data = [[NSData alloc] initWithBase64EncodedString:base64str options:0];
    NSString *str = [[NSString alloc] initWithData:base64data encoding:NSUTF8StringEncoding];
    NSLog(@"str===%@",str);
    
    //加盐足够长，足够复杂
#define salt @"aisuhfiuashod"
    //MD5加盐
   NSString * saltMd5 = [[@"str" stringByAppendingString:salt] md5String];
    NSLog(@"加盐saltMd5---%@",saltMd5);
    
    //HMAC,例如给定密钥(123)可以有服务器传过来，不像盐一样写死在程序中
    NSString * hmacStr = [@"str" hmacMD5StringWithKey:@"123"];
    NSLog(@"HMAC---%@",hmacStr);
}

-(void)netWork11{
    NSURL *url = [NSURL URLWithString:@"https://"];
//    2.创建亲求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //3.创建会话对象
    //设置代理
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
//    4.创建task
    NSURLSessionDataTask *datatask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //请求完成后调用
        //completionHandler是子线程调用！！！
        //解析数据
    }];
    //5.执行task
    [datatask resume];
}

#pragma mark - https请求时候用到的代理
//https时候用到的代理，challenge，弹出质询框
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler{
    NSLog(@"challenge---%@",challenge.protectionSpace);//受保护空间
    //判断是否受信任,不受信任直接返回
    if(![challenge.protectionSpace.authenticationMethod isEqualToString:@"NSURLAuthenticationMethodServerTrust"]){
        return;
    }
//    参数一：如何处理证书
//    NSURLSessionAuthChallengeUseCredential = 0,使用并安装该证书
//    NSURLSessionAuthChallengePerformDefaultHandling = 1,默认方式，该证书被忽略
//    NSURLSessionAuthChallengeCancelAuthenticationChallenge = 2,取消请求，忽略证书
//    NSURLSessionAuthChallengeRejectProtectionSpace = 3,拒绝
//    参数二：授权信息
    NSURLCredential *credential = [[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust];//创建信任证书
    completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
}
             
-(void)netWork12{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置证书的处理方式
    manager.securityPolicy.allowInvalidCertificates = YES;//设置是否接受无效的证书：是，因为有可能证书是自签名的
    manager.securityPolicy.validatesDomainName = NO;//关闭域名验证
    
//    请求网页源码需要更改解析方式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:@"https://kyfw.12306.cn/otn" parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //解析
        NSLog(@"%@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error---%@", error);
        }];
}

#pragma mark - runtime(消息机制),泛型，协变(__covariant)(父变子)逆变(__contravariant)(子变父),__kindof（返回值可以返回子类）
- (IBAction)runtimeOnClick:(UIButton *)sender{
    //生成C++代码：clang -rewrite-objc main.m
//    runtime 消息机制
    //引入头文件#import <objc/message.h>
   //id objc = [NSObject alloc]; 等同于 ( (NSObject *(*)(id,SEL))(void *) objc_msgSend )([NSObject class],@selector(alloc));
    //简写,需要在build settings中搜索msg,改成NO
//    分配内存
    id objc = objc_msgSend(objc_getClass("NSObject"),sel_registerName("alloc"));//(发送消息第一种写法)
//    id objc = objc_msgSend([NSObject class],@selector(alloc));//(发送消息第二种写法)
    
//    初始化
    //objc = [objc init]; 等同于 ( (NSObject *(*)(id,SEL))(void *) objc_msgSend )([NSObject class],@selector(init));
    objc = objc_msgSend(objc,sel_registerName("init"));//(发送消息第一种写法)
//    objc = objc_msgSend(objc,@selector(init));//(发送消息第二种写法)
    
    
    //什么时候需要用到runtime
    //1.装逼
    //2.不得不用：当.h文件注释掉方法声明，但是.m文件中有私有方法时（多用在系统方法）
    
//    补充：:方法都是有前缀的，谁的事情谁开头
//    如：objc调用run，第一个参数就是objc
    //    objc_msgSend(objc, @selector(run:),20);
    //带参数
//    如果objc中有方法-(void)run:(NSInteger)metre{}
//    objc_msgSend(objc, @selector(run:),20);
    
    //方法调用流程
    //对象方法：类对象的方法列表
    //类方法：元类中的方法列表
//    1.通过isa去对应的类中查找
//    2.注册方法编号
//    3.根据方法编号去查找对应方法
//    4.找到只是最终函数实现地址，根据地址去方法区调用对应函数
    //补充：5大区
//    1.栈 2.堆 3.静态去 4.常量区 5.方法区
//    1.栈：不需要手动管理内存，自动管理
//    2.堆：需要手动管理内存，自己去释放
    
    //一、runtime交换方法(只要想修改系统方法实现的时候)
//    如：每次UIImage加载图片时，都告诉我是否成功
//    给imageNamed添加功能，只能使用tuntime
//    1.自定义UIImage:弊端，1：每次使用都需要导入自己的类，2:项目大的时候如果改需求，没办法把所有原来的Image类的都替换，代价太大
//    2.添加分类：1:最好不要重写系统的方法，不然会把系统方法替换掉
//    3.runtime（交换方法）,1.添加分类(#import "UIImage+SKRuntime.h")，2自己实现一个带有扩展功能的方法(sk_imageNamed)给系统方法加一个前缀，区分系统方法
//    3.交换sk_imageNamed和imageNamed的方法实现，只需要交换一次，在分类的load中实现
    UIImage *image = [UIImage imageNamed:@"1.png"];
    
    //二、runtime动态添加方法，OC都是懒加载机制，只要方法实现了就会添加进入方法列表中
//    [self performSelector:SEL],动态添加方法时调用（代理）
//    什么时候动态添加方法，（如QQ的会员机制）
    SKPerson *p = [[SKPerson alloc] init];
    [p performSelector:@selector(eat)];
    [p performSelector:@selector(run:) withObject:@10];
    
    
    //三、runtime动态添加属性，runtime一般都是针对系统的类
    //什么时候动态添加属性,KVC字典转模型时
    //本质：动态添加属性，就是让属性与对象产生关联
    //需求：让一个NSObject类，其中的name属性，保存一个字符串（NSObject中是没有name属性的）
    //给NSObject添加分类,在分类中@property创建属性，同时实现set,get方法，在其中用runtime动态添加属性
    NSObject *objc2 = [[NSObject alloc] init];
    objc2.name = @"123";
    NSLog(@"objc2.name---%@",objc2.name);
    
    //KVC字典转模型，自动生成属性=》根据字典的key,给NSDictionary添加分类,#import "NSDictionary+SKRuntimeKVC.h"
    NSString * filepath = [[NSBundle mainBundle] pathForResource:@".plist" ofType:nil];
    NSDictionary * dict = [NSDictionary dictionaryWithContentsOfFile:filepath];
    //设计模型，自动生成创建属性代码打印在控制台，复制到模型类的头文件中，避免属性名字出错，或者是重复写此类代码浪费时间
    [dict creatPropertyCode];//运行后将控制台输出拷贝到模型类的头文件中
    //字典转模型：KVC，MJExtension
    SKPerson *item = [SKPerson itemWithDict:dict];
    
    //如果字典和模型属性不对应，KVC会报错
//    KVC原理，遍历字典去模型中找对应的属性，找不到会报错
//    防止系统报错方法
    //1.一个一个取出赋值
    //拿到每一个模型属性，去字典中取出对应的值，给模型赋值
    //从字典中取出值，不一定要全部取出
    //2.学习MJExtension思想，遍历模型，去字典中取出
    //MJExtension：字典转模型，runtime:可以把模型中的所有属性遍历出来
    //3.重新系统方法阻止报错setValue:forUndefinedKey:
    //补充：重写系统方法：1.想给系统方法添加额外功能。2.不想要系统方法实现
    
//    使用runtime字典转模型
    //写一个NSObject的分类#import "NSObject+SKRuntimeModel.h"
    SKPerson * model = [SKPerson modelWithDict:dict];
}

#pragma mark - const,宏，static,extern，父子控制器
- (IBAction)constOnClick:(UIButton *)sender {
//    宏：常用字符串，常见基本变量，定义宏
//    const:苹果一直推荐使用const，并在swift中取消了宏
//    const与宏的区别
//    1.编译时刻 宏：预编译，const：编译
//    2.编译检查 宏：没有编译检查，const：有编译检查
//    3.宏的好处 定义函数方法，const:不可以
//    4.宏的坏处 大量使用宏，会导致预编译时间过长
//    const作用：
//    1.修饰右边的基本变量或者指针变量
//    2.修饰全局变量，修饰方法中的参数
//    被const修饰变量只读，不能改
    //修饰基本变量
//    int const a = 3;
    //修饰指针变量
//    int a = 3;
//    int const *p = &a;//    *p不可以改
//    int * const p =&a;//    P不可以改

//    static：
//    1.修饰局部变量，被Static修饰局部变量，延长生命周期，跟整个应用程序有关
//    *被static修饰局部变量，只会分配一次内存
//    *被static修饰局部变量什么时候分配内存？程序一运行就分配
//    2.修饰全局变量，被Static修饰全局变量，作用域会修改，只能在当前文件下使用
    
//    extern:声明外部的局部变量，注意，只能用于声明，不能用于定义
//    extern int a;//只能这样
//    extern int a = 3;//这样是不行的；
//    extern工作原理：先回去当前文件下查找有没有对应的全局变量，如果没有，才会去其他文件查找
    
//    static和const联合使用
//    const修饰全局变量，static修饰全局变量，修改作用域
//    如：static NSString * const a = @"a";
    
//    const和extern联合使用，常见
    //行业规定：全局变量不能定义在自己的类中，可以自己定义一个全局类
//    extern NSString * const discover_name;
    
//   父子控制器
//    开发规范：如果A控制器要添加到B控制器的view上，那么A控制器必须成为B控制器的子控制器。
    //补充：让数组中的所有元素执行同一个方法
//    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];//移除所有自控制器
    //等同于
//    for(UIView *view in self.view.subviews){
//        [view removeFromSuperview];
//    }
}

#pragma mark - 仿TabbarView
- (IBAction)tabbarViewOnClick:(UIButton *)sender {
    SKMytabbarController *mytabbar =[ [SKMytabbarController alloc] init];
    [self.navigationController pushViewController:mytabbar animated:YES];
}

#pragma mark - 网易新闻界面搭建
- (IBAction)wangYiOnClick:(UIButton *)sender {
    SKWangYiViewController *wangyi =[ [SKWangYiViewController alloc] init];
    [self.navigationController pushViewController:wangyi animated:YES];
}

@end
