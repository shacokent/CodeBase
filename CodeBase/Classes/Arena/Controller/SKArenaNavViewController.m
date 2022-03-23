//
//  SKArenaNavViewController.m
//  CodeBase
//
//  Created by hongchen li on 2021/12/13.
//  Copyright © 2021 shacokent. All rights reserved.
//

#import "SKArenaNavViewController.h"

@interface SKArenaNavViewController ()

@end

@implementation SKArenaNavViewController
+ (void)initialize{
    UINavigationBar * bar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[self]];
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *navBar = [[UINavigationBarAppearance alloc] init];
        UIImage *image = [UIImage imageNamed:@"NLArenaNavBar64"];
        navBar.backgroundImage = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
        navBar.backgroundEffect = nil;
        bar.scrollEdgeAppearance = navBar;
        bar.standardAppearance = navBar;
    } else {
        // 常规配置方式
        [bar setBackgroundImage:[UIImage imageNamed:@"NLArenaNavBar64"] forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


@end
