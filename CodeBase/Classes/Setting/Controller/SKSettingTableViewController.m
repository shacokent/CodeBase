//
//  SKSettingTableViewController.m
//  CodeBase
//
//  Created by hongchen li on 2021/12/16.
//  Copyright © 2021 shacokent. All rights reserved.
//

#import "SKSettingTableViewController.h"
#import "SKPushTableViewController.h"
#import "MBProgressHUD+XMG.h"

@interface SKSettingTableViewController ()

@end

@implementation SKSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
//    创建行模型
    [self setupGroup0];
    [self setupGroup1];
    [self setupGroup2];
    
}

-(void)setupGroup0{
    SKSettingArrowItem *item = [SKSettingArrowItem itemWithIcon:[UIImage imageNamed:@"RedeemCode"] title:@"使用兑换码"];
    item.desVC = [SKPushTableViewController class];
    NSArray * items = @[item];
    SKSettingGroup * group = [SKSettingGroup groupWithItems:items];
    
    group.headerTitle = @"0";
    group.footTitle = @"0";
    [self.groups addObject:group];
}

-(void)setupGroup1{
    SKSettingArrowItem *item11= [SKSettingArrowItem itemWithIcon:[UIImage imageNamed:@"RedeemCode"] title:@"使用兑换码"];
//    item11.desVC = [SKPushTableViewController class];
    //如果需要传参数，采用block方法,注意：防止循环引用,block会对代码块里面的强指针强引用，如self，
    //方法一，在之前用weakSelf转换成弱引用，但是SKSettingTableViewController在每个需要写的地放都要写上类型，所以采用方法二
//    __weak SKSettingTableViewController *weakSelf = self;
    //方法二 typeof(x) 动态根据x判断X的真实类型
    __weak typeof(self) weakSelf = self;
    //方法三
//    __unsafe_unretained typeof(self) weakSelf = self;
    item11.operationBlock=^(NSIndexPath * indexPath){
        UIViewController *vc = [[UIViewController alloc] init];
        vc.title = @"传参";
        vc.view.backgroundColor = [UIColor redColor];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    SKSettingSwitchItem *item12 = [SKSettingSwitchItem itemWithIcon:[UIImage imageNamed:@"RedeemCode"] title:@"使用兑换码"];
    item12.on = YES;
    SKSettingItem *item13 = [SKSettingSwitchItem itemWithIcon:[UIImage imageNamed:@"RedeemCode"] title:@"使用兑换码"];
    SKSettingItem *item14 = [SKSettingItem itemWithIcon:[UIImage imageNamed:@"RedeemCode"] title:@"使用兑换码"];
    NSArray * items = @[item11,item12,item13,item14];
    SKSettingGroup * group = [SKSettingGroup groupWithItems:items];
    group.headerTitle = @"1";
    group.footTitle = @"1";
    [self.groups addObject:group];
}

-(void)setupGroup2{
    SKSettingItem *item21 = [SKSettingItem itemWithIcon:[UIImage imageNamed:@"RedeemCode"] title:@"使用兑换码"];
    item21.operationBlock = ^(NSIndexPath * indexPath){
        [MBProgressHUD showSuccess:@"NOTICE"];
    };
    NSArray * items = @[item21];
    SKSettingGroup * group = [SKSettingGroup groupWithItems:items];
    group.headerTitle = @"2";
    group.footTitle = @"2";
    [self.groups addObject:group];
}


@end
