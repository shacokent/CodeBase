//
//  SKTwoVC.m
//  CodeBase
//
//  Created by hongchen li on 2022/2/9.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKTwoVC.h"

@interface SKTwoVC ()
/**
 补充：block快捷方式inlineBlock代码块自动生成
 
 定义属性方式一
 @property (nonatomic,strong) int(^myBlock)(int);
 
 定义属性方式二
 typedef int(^myBlockType)(int);
 @property (nonatomic,strong) myBlockType myBlock1;
 
 1.block声明:返回值类型(^变量名)(参数类型)     void(^block)(void);
 2.block定义:三种方式
 返回值类型(^变量名)(参数类型)=^返回值(参数类型 参数名){
    return 返回值;
 }
 int(^block2)(int)=^int(int a){
     return a;
 };
 3.block作用:保存一段代码
 4.block类型：int(^)(int)
 5.block调用 变量名(参数);1.在一个方法中定义，另一个方法中调用，2.在一个类中定义，另一个类中调用

 传值：只要能拿到对方就能传值
 1.顺传：给需要传值的对象，直接定义属性就能传值
 2.逆传：1.用代理，2.block去代替代理
viewController-----跳转（push/present等）----viewController2
 viewController2逆传值到viewController
 在viewController2中定义block
 @property (nonatomic,strong) void(^myBlock)(int);
 在传值得地方
 if(_myBlock){
    _myBlock(123);
 }
 
 在viewController中接收
 viewController2  *vc2 =[ [viewController2 alloc] init];
 vc2.myBlock = ^(int a){
    NSLog(@"a");
 };
 [self presentViewController:vc2 animated:YES completion:nil];
 
 block内存管理
 block是不是一个对象？是 , 苹果旧文档搜索Working with Blocks
 
 如何判断当前文件是MRC还是ARC
 1.delloc，能否调用super,只有MRC才能调用
 2.能否使用retain,release，如果能用就是MRC
 怎么设置MRC，build setting 搜索ARC ->Objective-c automatic reference counting->NO
 
 ARC管理原则：只要一个对象没有被强指针修饰就会被销毁，默认局部变量对象都是强指针，存放到堆
 MRC开发常识:1.没有strong和weak,局部变量对象就是相当于基本数据类型管理
 2.给成员属性赋值，一定要使用set方法，不能直接访问下划线成员属性赋值
 

 block没有引用外部的局部变量就会放在全局区
 MRC：管理block
 1.只要block代码块中引用了外部的局部变量block就放在 “ 栈 ” 里面
 2.MRC中block只能使用copy不能使用retain,使用retain，block还在栈里面，过了就会销毁
 
 ARC：
 1.只要block代码块中引用了外部的局部变量block就放在“ 堆 ”里面
 2.用strong修饰
 
 循环引用：我引用你，你引用我，双方都不会被销毁，造成内存泄漏
 block会对里面的所有强指针变量全部强引用一次
 
 block变量传递
 block是值传递，外面怎么改，block里面都不会变，如果想改，加static修饰,或者改成全局，或者__block修饰。
 加static修饰,或者改成全局，或者__block修饰，是指针传递
 
 block当成参数去使用；
 怎么区分参数是block，就看有没有^,只要有^，把block当作参数
 把block当参数，并不是马上调用block，什么时候调用，有内部方法决定
 什么时候需要block当作参数使用，做什么事情由外部决定，但是什么时候运行由内部决定
 使用：
 新建计算工具类CaultorManager
 在viewController中初始化一个CaultorManager
 CaultorManager *mgr =  [[CaultorManager alloc] init];
 在CaultorManager.h中定义一个计算方法,和属性
 @property(nonatomic,assign) NSInteger result;
 -(void)cacultor:(NSInteger(^)(NSInteger result))cacultorBlock;
 在viewController中调用
 [mgr cacultor:^(NSInteger result){
    result+=5;
    return result;
 }];
 在CaultorManager.m中实现方法
 -(void)cacultor:(NSInteger(^)(NSInteger))cacultorBlock{
    if(cacultorBlock){
        cacultorBlock(_result);
    }
 }
 
 block作为返回值
 新建计算工具类CaultorManager
 在CaultorManager.h中定义一个计算方法,和属性
 @property(nonatomic,assign) NSInteger result;
 -(CaultorManager*(^)(NSInteger))add;
 在viewController中调用
 CaultorManager *mgr =  [[CaultorManager alloc] init];
 mgr.add(5);
 在CaultorManager.m中实现方法
 -(CaultorManager *(^)(NSInteger))add{
    return ^(NSInteger value){
        _result += value;
        return self;
    };
 }
 
 
 */

@property (nonatomic,strong) void(^block4)(void);
@end

@implementation SKTwoVC
 
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greenColor];
//   block声明: 返回值(^变量名)(参数)
    void(^block)(void);
    block = ^(){
        NSLog(@"0");
    };
    
//block定义:三种方式
//    1.
    void(^block1)(void)=^(){
        NSLog(@"1");
    };
//    2.如果没有参数，参数可以隐藏,参数必须写,必须要写变量名
    int(^block2)(int)=^int(int a){
        return a;
    };
//    3.block返回值是可以省略的，不管有没有值，都可以省略
    int(^block3)(int)=^(int a){
        return a;
    };
    
    //调用
    block();
    block1();
    int a = block2(2);
    NSLog(@"a---%d",a);
    int b = block3(3);
    NSLog(@"b---%d",b);
    
    //block快捷方式inlineBlock代码块自动生成
//    returnType(^blockName)(parameterTypes) = ^(parameters) {
//        statements
//    };
    
    //循环引用
    //解决：转换弱指针
    __weak typeof(self) weakSelf = self;
    _block4 = ^(){
        NSLog(@"1---%@",weakSelf);
        //如果有延时操作，那么weakSelf会被提前销毁
        //解决：把weakSelf重新强引用
        __strong typeof(weakSelf) strongSelf = weakSelf;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"2---%@",weakSelf);//null会被释放
            NSLog(@"3---%@",strongSelf);//打印成功
        });
        
    };
    _block4();

    //block变量传递
    int c = 3;
    //block是值传递，外面怎么改，block里面都不会变，如果想改，加static修饰,或者改成全局，或者__block修饰。
    //加static修饰,或者改成全局，或者__block修饰，是指针传递
    static int d = 3;
    __block int e = 3;
    void(^block5)(void) = ^{
        NSLog(@"c---%d",c);
        NSLog(@"d---%d",d);
        NSLog(@"e---%d",e);
    };
    c = 5;
    d = 5;
    e = 5;
    block5();

//    block作为返回值
    self.test();
}

-(void(^)(void))test{
    return ^{
        NSLog(@"test");
    };
}

@end
