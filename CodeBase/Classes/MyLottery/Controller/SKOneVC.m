//
//  SKOneVC.m
//  CodeBase
//
//  Created by hongchen li on 2022/2/9.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKOneVC.h"

@interface SKOneVC ()
@property (nonatomic,weak) id observer;//方法二的观察者通知，系统创建的观察者系统管理，所以用weak
@end

@implementation SKOneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    
    //发出通知方法一
    [self sendNof];
    //发出通知方法二
    [self sendNof2];
    //通知再多线程中的用法一
    [self sendNof3];
    //通知再多线程中的用法二
    [self sendNof4];
}

-(void)sendNof{
    //注意，通知是有顺序的，需要先监听，后发出，使用后必须移除
    
    //监听通知
    //参数一：观察者
    //参数二：只要监听到通知就调用观察者的方法
//    参数三：通知名称
//    参数四：谁发的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveOne:) name:@"one" object:@"one"];
    
    //发出通知
    //参数一：通知名称
    //参数二：谁发通知，nil匿名发送
//    参数三：传参数
    [[NSNotificationCenter defaultCenter] postNotificationName:@"one" object:@"one" userInfo:@{@"one":@123}];
    
}

-(void)dealloc{
    //移除通知
    //方法一的移除
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //方法二的移除
    [[NSNotificationCenter defaultCenter] removeObserver:_observer];
}
-(void)reciveOne:(NSDictionary*)dict{
    NSLog(@"reciveOne---%@",dict);
}


-(void)sendNof2{
    //参数一：通知名称
//    参数二：谁发出的通知
//    参数三：队列,决定block在哪个线程中执行，nil:在发布线程中执行,一般使用[NSOperationQueue mainQueue]方便刷新UI
//    参数四：block只要监听到通知，就会执行这个block
//
    _observer = [[NSNotificationCenter defaultCenter] addObserverForName:@"one2" object:@"one2" queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSLog(@"reciveOne2---%@",note.userInfo);
    }];
    
    //发出通知
    //参数一：通知名称
    //参数二：谁发通知，nil匿名发送
//    参数三：传参数
    [[NSNotificationCenter defaultCenter] postNotificationName:@"one2" object:@"one2" userInfo:@{@"one2":@123}];
}

-(void)sendNof3{
    //异步监听
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveThree:) name:@"one3" object:@"one3"];
    });
    //！！注意：接收通知的方法reciveThree在哪个线程中执行，由发出通知的线程决定
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(NSEC_PER_SEC*1.0)), dispatch_get_global_queue(0, 0), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"one3" object:@"one3" userInfo:@{@"one3":@123}];
    });
}

-(void)reciveThree:(NSDictionary*)dict{
    NSLog(@"reciveThree---%@",dict);
    NSLog(@",[NSThread currentThread]---%@",[NSThread currentThread]);
    //！！注意：同步在住线程更新UI，因为又可能reciveThree在子线程中执行
    dispatch_sync(dispatch_get_main_queue(), ^{
        //更新UI
    });
}

-(void)sendNof4{
    //queue:控制在哪个线程中执行Block
    _observer = [[NSNotificationCenter defaultCenter] addObserverForName:@"one4" object:@"one4" queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        NSLog(@"reciveOne4---%@",note.userInfo);
        NSLog(@",[NSThread currentThread]---%@",[NSThread currentThread]);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(NSEC_PER_SEC*1.0)), dispatch_get_global_queue(0, 0), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"one4" object:@"one4" userInfo:@{@"one4":@123}];
    });
    
}

@end
