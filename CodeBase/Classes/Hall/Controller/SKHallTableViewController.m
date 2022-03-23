//
//  SKHallTableViewController.m
//  CodeBase
//
//  Created by hongchen li on 2021/12/8.
//  Copyright © 2021 shacokent. All rights reserved.
//

//typedef void(^MyBlock)();//创建block方法2

#import "SKHallTableViewController.h"
#import "SKCover.h"
#import "SKPopMenu.h"

@interface SKHallTableViewController ()<SKSKPopMenuDelegate>

@end

@implementation SKHallTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航条左侧按钮
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithRenderOriginalName:@"CS50_activity_image"] style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonClick)];
}

-(void)leftButtonClick{
    //弹出蒙版，占据整屏幕，不允许用户交互，自定义蒙版
    [SKCover show];
    //弹出菜单
    SKPopMenu *popMenu = [SKPopMenu showInCenter:self.view.center];
    popMenu.delegate = self;
    
    //为UIView写分类，方便设置frame
//    popMenu.width = 10;
//    popMenu.height = 10;
//    popMenu.x = 10;
//    popMenu.y = 10;
}

#pragma mark - SKSKPopMenuDelegate
- (void)popMenuDidCloseBtn:(SKPopMenu *)popMenu{
    
    //移除蒙版
    void(^completion)(void) = ^(){
        [SKCover hide];
    };
    
    //移除menu
    [popMenu hideInCenter:CGPointMake(44, 44) completion:completion];
        //创建block方法1，block封装代码，在必要时调用,block创建快捷键inlineBlock
        //    void(^block)(void)= ^(){
        //        NSLog(@"block创建方法1");
        //    };
        //    block();//调用block
    
        //创建block方法2
        //    MyBlock block1 = ^(){
        //        NSLog(@"block创建方法2");
        //    };
        //    block1();//调用block
    
    
}
@end
