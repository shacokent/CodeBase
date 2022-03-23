//
//  SKSettingItem.h
//  CodeBase
//
//  Created by hongchen li on 2021/12/16.
//  Copyright © 2021 shacokent. All rights reserved.
//行模型
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SKSettingItem : NSObject
//图片
@property (nonatomic,strong) UIImage *icon;
//标题
@property (nonatomic,copy) NSString *title;
//子标题
@property (nonatomic,copy) NSString *subTitle;
//点击这一行要做的事情
@property (copy, nonatomic) void(^operationBlock)(NSIndexPath * indexPath);

+(instancetype)itemWithIcon:(UIImage *)icon title:(NSString *)title;

+(instancetype)itemWithTitle:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
