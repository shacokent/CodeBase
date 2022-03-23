//
//  SKSettingItem.m
//  CodeBase
//
//  Created by hongchen li on 2021/12/16.
//  Copyright © 2021 shacokent. All rights reserved.
//行模型

#import "SKSettingItem.h"

@implementation SKSettingItem

+(instancetype)itemWithIcon:(UIImage *)icon title:(NSString *)title{
    SKSettingItem * item = [[self alloc] init];
    item.icon = icon;
    item.title = title;
    return item;
}

+(instancetype)itemWithTitle:(NSString *)title{
    return [self itemWithIcon:nil title:title];
}

@end
