//
//  NSObject+SKRuntimeModel.h
//  CodeBase
//
//  Created by hongchen li on 2022/2/8.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//字典转模型
@interface NSObject (SKRuntimeModel)
+(instancetype)modelWithDict:(NSDictionary*)dict;
@end

NS_ASSUME_NONNULL_END
