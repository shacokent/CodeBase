//
//  SKPushTableViewController.m
//  CodeBase
//
//  Created by hongchen li on 2021/12/20.
//  Copyright © 2021 shacokent. All rights reserved.
//

#import "SKPushTableViewController.h"
#import "SKScoreTableViewController.h"
#import "SKAwardTableViewController.h"

@interface SKPushTableViewController ()
@end

@implementation SKPushTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGroup0];
    
}

-(void)setupGroup0{
    SKSettingArrowItem *item = [SKSettingArrowItem itemWithTitle:@"开奖推送"];
    item.desVC = [SKAwardTableViewController class];
    SKSettingArrowItem *item1 = [SKSettingArrowItem itemWithTitle:@"比分直播"];
    item1.desVC = [SKScoreTableViewController class];
    NSArray * items = @[item, item1];
    SKSettingGroup * group = [SKSettingGroup groupWithItems:items];
    [self.groups addObject:group];
}

@end
