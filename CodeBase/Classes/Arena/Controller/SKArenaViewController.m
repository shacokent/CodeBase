//
//  SKArenaViewController.m
//  CodeBase
//
//  Created by hongchen li on 2021/12/8.
//  Copyright © 2021 shacokent. All rights reserved.
//

#import "SKArenaViewController.h"

@interface SKArenaViewController ()

@end

@implementation SKArenaViewController

//第一次加载VIEW调用
//自定义View重写此方法
- (void)loadView{
    //在此方法不能调用self.view会造成死循环
//    UIImageView * imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image = [UIImage imageNamed:@"NLArenaBackground"];
    imageView.userInteractionEnabled = YES;
    self.view = imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UISegmentedControl *segMentContr = [[UISegmentedControl alloc] initWithItems:@[@"足球",@"篮球"]];
    [segMentContr setBackgroundImage:[UIImage imageNamed:@"CPArenaSegmentBG"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [segMentContr setBackgroundImage:[UIImage imageNamed:@"CPArenaSegmentSelectedBG"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    NSMutableDictionary * dictM = [NSMutableDictionary dictionary];
    //字体大小
    dictM[NSFontAttributeName] = [UIFont boldSystemFontOfSize:16];
    dictM[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [segMentContr setTitleTextAttributes:dictM forState:UIControlStateNormal];
    segMentContr.selectedSegmentIndex = 0;
    segMentContr.tintColor = [UIColor  colorWithRed:0 green:142/255.0 blue:143/255.0 alpha:1];
    self.navigationItem.titleView = segMentContr;
}

@end
