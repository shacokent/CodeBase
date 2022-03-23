//
//  SKTabBarViewController.m
//  CodeBase
//
//  Created by hongchen li on 2021/12/8.
//  Copyright © 2021 shacokent. All rights reserved.
//

#import "SKTabBarViewController.h"
#import "SKDiscoverTableViewController.h"
#import "SKMyLotteryViewController.h"
#import "SKHistoryTableViewController.h"
#import "SKArenaViewController.h"
#import "SKHallTableViewController.h"
#import "SKTabBar.h"
#import "SKNavigationController.h"
#import "SKArenaNavViewController.h"

@interface SKTabBarViewController ()<SKTabBarDelegate>
@property (nonatomic, strong) NSMutableArray * items;
@end

@implementation SKTabBarViewController

-(NSMutableArray*)items{
    if(!_items){
        _items = [NSMutableArray array];
    }
    return _items;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //添加自控制器
    [self setupAllChildViewController];
    //自定义TabBar
    [self setupTabBar];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //移除系统tabbar子控件,UITabBarButton
    //UITabBarButton是私有属性
    for(UIView * view in self.tabBar.subviews){
        if(![view isKindOfClass:[SKTabBar class]]){
            [view removeFromSuperview];
        }
    }
}

-(void)setupTabBar{
    //直接移除系统tabbar，会影响之后的隐藏tabbar的需求
//    [self.tabBar removeFromSuperview];
    
    //移除tabbar的成员,在viewWillAppear中移除
    SKTabBar *tabBar = [[SKTabBar alloc] init];
    tabBar.barItems = self.items;
    [self.tabBar addSubview:tabBar];
    tabBar.frame = self.tabBar.bounds;
    tabBar.backgroundColor = [UIColor grayColor];
    tabBar.delegate = self;
    
    
    NSLog(@"%@",NSStringFromCGRect(self.tabBar.frame));
    
}

#pragma mark - SKTabBarDelegate
- (void)tabBar:(SKTabBar *)tabBar index:(NSInteger)index{
    self.selectedIndex = index;
}

-(void)setupAllChildViewController{
    //购彩大厅
    SKHallTableViewController * hall = [[SKHallTableViewController alloc] init];
    [self addChildViewController:hall];
    [self setupOneViewController:hall image:[UIImage imageNamed:@"TabBar_Hall_new"] selectImage:[UIImage imageNamed:@"TabBar_Hall_selected_new"] title:@"购彩大厅"];
    
    //竞技场
    SKArenaViewController * arena = [[SKArenaViewController alloc] init];
    [self addChildViewController:arena];
    [self setupOneViewController:arena image:[UIImage imageNamed:@"TabBar_Arena_new"] selectImage:[UIImage imageNamed:@"TabBar_Arena_selected_new"] title:@""];
    
    //发现
    //加载storyboard
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"SKDiscoverTableViewController" bundle:nil];
    //初始化箭头指向控制器
    SKDiscoverTableViewController * discover = [storyboard instantiateInitialViewController];
//    SKDiscoverTableViewController * discover = [[SKDiscoverTableViewController alloc] init];
    [self addChildViewController:discover];
    [self setupOneViewController:discover image:[UIImage imageNamed:@"TabBar_Discovery_new"] selectImage:[UIImage imageNamed:@"TabBar_Discovery_selected_new"] title:@"发现"];
    
    //开奖信息
    SKHistoryTableViewController * history = [[SKHistoryTableViewController alloc] init];
    [self addChildViewController:history];
    [self setupOneViewController:history image:[UIImage imageNamed:@"TabBar_History_new"] selectImage:[UIImage imageNamed:@"TabBar_History_selected_new"] title:@"开奖信息"];
    
    //我的彩票
    SKMyLotteryViewController * myLottery = [[SKMyLotteryViewController alloc] init];
    [self addChildViewController:myLottery];
    [self setupOneViewController:myLottery image:[UIImage imageNamed:@"TabBar_MyLottery_new"] selectImage:[UIImage imageNamed:@"TabBar_MyLottery_selected_new"] title:@"我的彩票"];
    
}

-(void)setupOneViewController:(UIViewController*)vc image:(UIImage *)image selectImage:(UIImage *)selectImage title:(NSString *)title{
    //创建导航控制器
    SKNavigationController *nav = [[SKNavigationController alloc] initWithRootViewController:vc];
    if([vc isKindOfClass:[SKArenaViewController class]]){
        nav = [[SKArenaNavViewController alloc] initWithRootViewController:vc];
    }
    [self addChildViewController:nav];
    vc.navigationItem.title = title;
    
    
    vc.tabBarItem.image = image;
    vc.tabBarItem.selectedImage = selectImage;
    [self.items addObject:vc.tabBarItem];
    
}
@end
