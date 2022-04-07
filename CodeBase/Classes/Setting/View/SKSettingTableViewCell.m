//
//  SKSettingTableViewCell.m
//  CodeBase
//
//  Created by hongchen li on 2021/12/20.
//  Copyright © 2021 shacokent. All rights reserved.
//

#import "SKSettingTableViewCell.h"
#import "SKSettingArrowItem.h"
#import "SKSettingSwitchItem.h"

@implementation SKSettingTableViewCell
+(instancetype)cellWithTableView:(UITableView*)tableView{
    return [self cellWithTableView:tableView cellStyle:UITableViewCellStyleValue1];
}


+(instancetype)cellWithTableView:(UITableView*)tableView cellStyle:(UITableViewCellStyle)cellStyle{
    static NSString *cid=@"cell";
    SKSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cid];
    if(cell==nil){
        cell=[[SKSettingTableViewCell alloc] initWithStyle:cellStyle      reuseIdentifier:cid];
        
    }
    return  cell;
}

- (void)setItem:(SKSettingItem *)item{
    _item = item;
    self.imageView.image = item.icon;
    self.textLabel.text = item.title;
    self.detailTextLabel.text = item.subTitle;
    [self setupRightView];
}

-(void)setupRightView{
    if([_item isKindOfClass:[SKSettingArrowItem class]]){
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
    }
    else if([_item isKindOfClass:[SKSettingSwitchItem class]]){
        SKSettingSwitchItem *swItem = (SKSettingSwitchItem*)_item;
        UISwitch *sw = [[UISwitch alloc] init];
        sw.on = swItem.isOn;
        self.accessoryView = sw;
    }
    else{
        self.accessoryView = nil;
    }
}
@end
