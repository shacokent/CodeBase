//
//  SKBaseTableViewController.m
//  CodeBase
//
//  Created by hongchen li on 2021/12/20.
//  Copyright © 2021 shacokent. All rights reserved.
//

#import "SKBaseTableViewController.h"

@interface SKBaseTableViewController ()

@end

@implementation SKBaseTableViewController
- (NSMutableArray *)groups{
    if(!_groups){
        _groups = [[NSMutableArray alloc] init];
    }
    return _groups;
}

- (instancetype)init{
    return [super initWithStyle:UITableViewStyleGrouped];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SKSettingGroup *group = self.groups[section];
    return group.items.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //取出组模型
    SKSettingGroup * group =self.groups[indexPath.section];
    SKSettingItem * item = group.items[indexPath.row];
    //block封装弹框代码，放在item父类
    //有block就弹框，否则跳转
    if(item.operationBlock){
        item.operationBlock(indexPath);
    }
    else{
        if([item isKindOfClass:[SKSettingArrowItem class]]){
            SKSettingArrowItem *arrowItem = (SKSettingArrowItem*)item;
            //设置了目标控制器才会跳转
            if(arrowItem.desVC){
                UIViewController *vc = [[arrowItem.desVC alloc] init];
                vc.title = item.title;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //创建cell
    SKSettingTableViewCell * cell = [SKSettingTableViewCell cellWithTableView:tableView];
    
    //创建model搭建界面
    //取出行模型
    SKSettingGroup *group = self.groups[indexPath.section];
    SKSettingItem * item = group.items[indexPath.row];
    cell.item = item;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    SKSettingGroup *group = self.groups[section];
    return group.headerTitle;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    SKSettingGroup *group = self.groups[section];
    return group.footTitle;
}
@end
