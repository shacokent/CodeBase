//
//  SKScoreTableViewController.m
//  CodeBase
//
//  Created by hongchen li on 2021/12/20.
//  Copyright © 2021 shacokent. All rights reserved.
//

#import "SKScoreTableViewController.h"

@interface SKScoreTableViewController ()

@end

@implementation SKScoreTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGroup0];
    [self setupGroup1];
    [self setupGroup2];
}
-(void)setupGroup0{
    SKSettingSwitchItem *item = [SKSettingSwitchItem itemWithTitle:@"关注比赛"];
    item.on = true;
    NSArray * items = @[item];
    SKSettingGroup * group = [SKSettingGroup groupWithItems:items];
    group.footTitle = @"0";
    [self.groups addObject:group];
}

-(void)setupGroup1{
    SKSettingItem *item = [SKSettingItem itemWithTitle:@"启始时间"];
    item.subTitle = @"00:00";
    NSArray * items = @[item];
    SKSettingGroup * group = [SKSettingGroup groupWithItems:items];
    [self.groups addObject:group];
}

-(void)setupGroup2{
    SKSettingItem *item = [SKSettingItem itemWithTitle:@"结束时间"];
    item.subTitle = @"23:59";
    __weak typeof(self) weakSelf = self;
    //ios7以后只要textfield添加到cell上，键盘处理操作系统帮我们做好，如显示键盘自动把显示不出来的field向上推到可视位置
    item.operationBlock = ^(NSIndexPath * indexPath){
        //利用cellForRowAtIndexPath获取cell
        UITableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
        UITextField *textField = [[UITextField alloc] init];
        [cell addSubview:textField];
        [textField becomeFirstResponder];
    };
    NSArray * items = @[item];
    SKSettingGroup * group = [SKSettingGroup groupWithItems:items];
    [self.groups addObject:group];
}

//当scrollView开始滑动的时候调用
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

@end
