//
//  SKSettingSwitchItem.h
//  CodeBase
//
//  Created by hongchen li on 2021/12/20.
//  Copyright © 2021 shacokent. All rights reserved.
//

#import "SKSettingItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface SKSettingSwitchItem : SKSettingItem

@property (nonatomic,assign,getter=isOn) BOOL on;

@end

NS_ASSUME_NONNULL_END
