//
//  SKBaseTableViewController.h
//  CodeBase
//
//  Created by hongchen li on 2021/12/20.
//  Copyright © 2021 shacokent. All rights reserved.
//抽取的基类

#import <UIKit/UIKit.h>
#import "SKSettingTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SKBaseTableViewController : UITableViewController
//数组总数
@property (nonatomic,strong) NSMutableArray *groups;
@end

NS_ASSUME_NONNULL_END
