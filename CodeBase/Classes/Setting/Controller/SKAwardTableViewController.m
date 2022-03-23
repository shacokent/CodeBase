//
//  SKAwardTableViewController.m
//  CodeBase
//
//  Created by hongchen li on 2021/12/20.
//  Copyright © 2021 shacokent. All rights reserved.
//

#import "SKAwardTableViewController.h"

@interface SKAwardTableViewController ()

@end

@implementation SKAwardTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGroup0];
    
}

-(void)setupGroup0{
    SKSettingSwitchItem *item = [SKSettingSwitchItem itemWithTitle:@"双色球1"];
    item.on = true;
    item.subTitle = @"每天开奖";
    SKSettingSwitchItem *item2 = [SKSettingSwitchItem itemWithTitle:@"双色球2"];
    item2.subTitle = @"每天开奖";
    item.on = false;
    NSArray * items = @[item, item2];
    SKSettingGroup * group = [SKSettingGroup groupWithItems:items];
    group.footTitle = @"0";
    [self.groups addObject:group];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //创建cell
    SKSettingTableViewCell * cell = [SKSettingTableViewCell cellWithTableView:tableView cellStyle:UITableViewCellStyleSubtitle];
    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
    //创建model搭建界面
    //取出行模型
    SKSettingGroup *group = self.groups[indexPath.section];
    SKSettingItem * item = group.items[indexPath.row];
    cell.item = item;
    return cell;
}

@end
