//
//  SKSettingGroup.m
//  CodeBase
//
//  Created by hongchen li on 2021/12/16.
//  Copyright © 2021 shacokent. All rights reserved.
//

#import "SKSettingGroup.h"

@implementation SKSettingGroup

+(instancetype)groupWithItems:(NSArray *)items{
    SKSettingGroup *group = [[SKSettingGroup alloc] init];
    group.items =items;
    return group;
}
@end
