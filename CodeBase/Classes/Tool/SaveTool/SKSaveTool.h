//
//  SKSaveTool.h
//  CodeBase
//
//  Created by hongchen li on 2021/12/14.
//  Copyright © 2021 shacokent. All rights reserved.
//  存储工具类

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SKSaveTool : NSObject
+ (nullable id)objectForKey:(NSString*)defaulName;
+ (void)setObject:(nullable id)value forKey:(NSString *)defaultName;
@end

NS_ASSUME_NONNULL_END
