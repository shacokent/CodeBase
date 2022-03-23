//
//  UIView+SKframe.h
//  CodeBase
//
//  Created by hongchen li on 2021/12/10.
//  Copyright © 2021 shacokent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (SKframe)

//分类中property只会生成set/get并不会生成下划线成员属性
@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

@end

NS_ASSUME_NONNULL_END
