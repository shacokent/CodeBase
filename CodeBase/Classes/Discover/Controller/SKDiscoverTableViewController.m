//
//  SKDiscoverTableViewController.m
//  CodeBase
//
//  Created by hongchen li on 2021/12/8.
//  Copyright © 2021 shacokent. All rights reserved.
//

#import "SKDiscoverTableViewController.h"

@interface SKDiscoverTableViewController ()

@end

@implementation SKDiscoverTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //cell将要现实的时候添加动画，从右向左的动画
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

//当Cell将要现实时候调用
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //1.cell平移到屏幕外
    cell.transform = CGAffineTransformMakeTranslation(self.view.width, 0);
    //2.cell复位
    [UIView animateWithDuration:0.5 animations:^{
        cell.transform = CGAffineTransformIdentity;
    }];
    
}
@end
