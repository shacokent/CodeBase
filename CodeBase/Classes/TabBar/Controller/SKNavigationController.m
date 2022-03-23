//
//  SKNavigationController.m
//  CodeBase
//
//  Created by hongchen li on 2021/12/8.
//  Copyright © 2021 shacokent. All rights reserved.
//
#import <objc/runtime.h>
#import "SKNavigationController.h"
//@interface SKNavigationController ()<UINavigationControllerDelegate>
@interface SKNavigationController ()<UIGestureRecognizerDelegate>
//@property (nonatomic, strong) id popGesture;//系统手势代理
@end

@implementation SKNavigationController
//程序启动时调用，将当前类加载进内存，放在代码区，在main之前调用，ARC不起作用需要手动管理内存
+ (void)load{}
//第一次初始化类调用，只调用一次，如果这个类有子类会调用多次，先初始化父类在初始化子类
+ (void)initialize{
    //屏蔽子类，只加载一次
    if(self == [SKNavigationController class]){
        //获取导航条标志,APP的导航条标识，appearance是一个协议，遵守此协议都有此方法，如果启用有重大BUG，无法定制某个控制器
    //    UINavigationBar * bar = [UINavigationBar appearance];
        
        UINavigationBar * bar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[self]];
    //    UINavigationBar * bar = [UINavigationBar appearanceWhenContainedIn:self, nil];//过时
        NSMutableDictionary * dictM = [NSMutableDictionary dictionary];
        //字体大小
        dictM[NSFontAttributeName] = [UIFont boldSystemFontOfSize:22];
        dictM[NSForegroundColorAttributeName] = [UIColor whiteColor];
        //导航条设置背景图片必须用默认模式
        if (@available(iOS 15.0, *)) {
            UINavigationBarAppearance *navBar = [[UINavigationBarAppearance alloc] init];
            navBar.backgroundImage = [UIImage imageNamed:@"NavBar64"];
            [navBar setTitleTextAttributes:dictM];
            //设置左侧返回按钮方法二
            [bar setTintColor:[UIColor whiteColor]];
            //修改返回按钮的文字位置,只能修改X，修改Y超过范围会约束报错
    //        navBar.backButtonAppearance.normal.titlePositionAdjustment = UIOffsetMake(0, -100);
            navBar.backButtonAppearance.normal.titlePositionAdjustment = UIOffsetMake(-200, 0);
            navBar.backgroundEffect = nil;
            bar.scrollEdgeAppearance = navBar;
            bar.standardAppearance = navBar;
        } else {
            // 常规配置方式
            [bar setBackgroundImage:[UIImage imageNamed:@"NavBar64"] forBarMetrics:UIBarMetricsDefault];
            [bar setTitleTextAttributes:dictM];
            
            //设置左侧返回按钮方法二
            [bar setTintColor:[UIColor whiteColor]];
            UIBarButtonItem * item = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[self]];
            //修改返回按钮的文字位置
            [item setBackButtonTitlePositionAdjustment:UIOffsetMake(-200, 0) forBarMetrics:UIBarMetricsDefault];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //修改系统手势，滑动屏幕中间也可以返回,系统没有提供属性，所以只能自己添加手势
    UIScreenEdgePanGestureRecognizer *gest = self.interactivePopGestureRecognizer;
//    NSLog(@"%@",gest);
    //<_UIParallaxTransitionPanGestureRecognizer: 0x7fdf4f227160; state = Possible; delaysTouchesBegan = YES; view = <UILayoutContainerView 0x7fdf4f2225a0>; target= <(action=handleNavigationTransition:, target=<_UINavigationInteractiveTransition 0x7fdf4f227020>)>>
    //自己添加手势，需要先禁止系统手势，当跟控制器的时候不移除，否则会卡死，用代理UIGestureRecognizerDelegate的
    
    self.interactivePopGestureRecognizer.enabled = NO;
    //需要写selecter东西太多,上方打印可以看出系统action方法，所以直接用，但是缺少target,系统的私有属性，通过KVC获取，不知道Target的真实类型，用OC的runtime机制，只能动态获取某个当前类的成员属性，不能获取子类或者父类，先导入#import <objc/runtime.h>,__unsafe_unretained cls要获取哪个类的成员属性，outCount获取该类所有成员属性的个数，然后确定类通过UIScreenEdgePanGestureRecognizer类逐层向父类找应该存在Target的类UIGestureRecognizer
    //通过下面代码 获取_targets
//        unsigned int outCount = 0;
//        Ivar * ivars = class_copyIvarList([UIGestureRecognizer class], &outCount);
//        for(int i =0 ;i<outCount;i++){
//            NSLog(@"%s",ivar_getName(ivars[i]));
//        }
    
    //先设为id类型，打印确认类型
//    id targets = [gest valueForKeyPath:@"_targets"];
//    NSLog(@"%@",targets);
//    (
//        "(action=handleNavigationTransition:, target=<_UINavigationInteractiveTransition 0x7f92a4a0fb40>)"
//    )
    //发现类型是数组，用数组接收打印
    NSArray * targets = [gest valueForKeyPath:@"_targets"];
//    NSLog(@"%@",targets[0]);
    //此处打断点，通过查看断点信息查看类型，其中只有一个数组，数组其中成员_target是_UINavigationInteractiveTransition类型
    //再次用KVC取出_target
    id target = [targets[0] valueForKeyPath:@"_target"];
    //另一种获取target的方法
    //发现正常设置手势的时候，initWithTarget:self的self和pan1.delegate = self的self是一样的
//    UIPanGestureRecognizer *pan1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan)];
//    pan1.delegate = self;
    //所以直接传当前手势代理就可以了 self.interactivePopGestureRecognizer.delegate
//    id target = self.interactivePopGestureRecognizer.delegate;
    
    //设置initWithTarget:target
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    pan.delegate = self;//启用代理，防止根控制器滑动时候卡死
    [self.view addGestureRecognizer:pan];
    
    
    //设置左侧返回按钮方法一，UINavigationControllerDelegate，didShowViewController
//    self.popGesture = self.interactivePopGestureRecognizer.delegate;
    //当是根控制器需要还原代理，非根控制器，清空代理
//    self.delegate = self;
}

#pragma mark - UIGestureRecognizerDelegate
//当开始滑动的时候调用，YES可以滑动，NO禁止手势,当根控制器禁止，非根控制器允许
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if(self.viewControllers.count > 1){
        return YES;
    }
    else{
        return NO;
    }
}

//#pragma mark - UINavigationControllerDelegate
//当控制器显示完时候调用
//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    if(self.viewControllers[0] == viewController){
//        //想统一设置滑动移除控制器
//        //清空手势代理就能实现滑动返回。IOS6不支持
//        self.interactivePopGestureRecognizer.delegate =  self.popGesture;
//    }
//    else{
//        self.interactivePopGestureRecognizer.delegate = nil;
//    }
//}

//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    [super pushViewController:viewController animated:animated];
//    //当非根控制器设置导航条左侧返回按钮
//    if(self.viewControllers.count > 1){
//        //如果在导航控制控制器统一设置返回按钮，就没滑动一处控制器的功能
//        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithRenderOriginalName:@"NavBack"] style:0 target:self action:@selector(back)];
//    }
    
//}

//-(void)back{
//    [self popViewControllerAnimated:YES];
//}


//为了隐藏tabbar,拦截pushViewController
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    //在super pushViewController之前隐藏tabbar才可以，并且在没有push时控制器没有+1，所以count>0 是根控制器
    if(self.viewControllers.count > 0){
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
@end
