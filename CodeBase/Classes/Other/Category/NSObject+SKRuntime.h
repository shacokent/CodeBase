//
//  NSObject+SKRuntime.h
//  CodeBase
//
//  Created by hongchen li on 2022/2/8.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (SKRuntime)
//@@property在分类中的作用，只会生成get，set方法声明，不会生成实现，也不会生成下划线成员属性
@property NSString *name;
@end

NS_ASSUME_NONNULL_END
