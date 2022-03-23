//
//  SKTabBar.h
//  CodeBase
//
//  Created by hongchen li on 2021/12/8.
//  Copyright © 2021 shacokent. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SKTabBar;
NS_ASSUME_NONNULL_BEGIN
@protocol SKTabBarDelegate <NSObject>

-(void)tabBar:(SKTabBar *)tabBar index:(NSInteger)index;

@end

@interface SKTabBar : UIView

@property (nonatomic, strong) NSArray * barItems;
@property (nonatomic, weak) id<SKTabBarDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
