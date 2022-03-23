//
//  UIImage+SK.h
//  CodeBase
//
//  Created by hongchen li on 2021/12/8.
//  Copyright © 2021 shacokent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (SK)
//返回不渲染的图片
+(UIImage*)imageWithRenderOriginalName:(NSString*)name;
@end

NS_ASSUME_NONNULL_END
