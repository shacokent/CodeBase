//
//  SKBuyViewController.m
//  CodeBase
//
//  Created by hongchen li on 2021/12/13.
//  Copyright © 2021 shacokent. All rights reserved.
//

#import "SKBuyViewController.h"
#import "SKTitleViewButton.h"
@interface SKBuyViewController ()

@end

@implementation SKBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置title View
    UIButton * button = [[SKTitleViewButton alloc] init];
    [button setImage:[UIImage imageNamed:@"YellowDownArrow"] forState:UIControlStateNormal];
    [button setTitle:@"全部采种" forState:UIControlStateNormal];
    [button sizeToFit];
    self.navigationItem.titleView = button;
    
    //避免每次都写所以在自定义的SKNavigationController中重写pushViewController
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithRenderOriginalName:@"NavBack"] style:0 target:self action:@selector(back)];
}

//-(void)back{
//    [self.navigationController popViewControllerAnimated:YES];
//}

@end
