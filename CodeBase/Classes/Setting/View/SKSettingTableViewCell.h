//
//  SKSettingTableViewCell.h
//  CodeBase
//
//  Created by hongchen li on 2021/12/20.
//  Copyright © 2021 shacokent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSettingItem.h"
#import "SKSettingGroup.h"
#import "SKSettingArrowItem.h"
#import "SKSettingSwitchItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface SKSettingTableViewCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView*)tableView;
+(instancetype)cellWithTableView:(UITableView*)tableView cellStyle:(UITableViewCellStyle)cellStyle;
@property (nonatomic,strong) SKSettingItem *item;

@end

NS_ASSUME_NONNULL_END
