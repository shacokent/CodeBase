//
//  UIImage+SKRuntime.h
//  CodeBase
//
//  Created by hongchen li on 2022/2/8.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (SKRuntime)
+ (UIImage *)sk_imageNamed:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
