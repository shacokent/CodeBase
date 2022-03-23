//
//  SKSettingGroup.h
//  CodeBase
//
//  Created by hongchen li on 2021/12/16.
//  Copyright © 2021 shacokent. All rights reserved.
//组模型

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SKSettingGroup : NSObject
//头标题
@property (nonatomic,copy) NSString *headerTitle;
//尾标题
@property (nonatomic,copy) NSString *footTitle;
//行模型数组
@property (nonatomic,strong) NSArray *items;

+(instancetype)groupWithItems:(NSArray *)items;
@end

NS_ASSUME_NONNULL_END
