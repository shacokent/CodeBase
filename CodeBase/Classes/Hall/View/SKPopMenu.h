//
//  SKPopMenu.h
//  CodeBase
//
//  Created by hongchen li on 2021/12/9.
//  Copyright © 2021 shacokent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SKPopMenu;
@protocol SKSKPopMenuDelegate <NSObject>

-(void)popMenuDidCloseBtn:(SKPopMenu*)popMenu;

@end

@interface SKPopMenu : UIView
+(instancetype)showInCenter:(CGPoint)center;
@property (nonatomic, weak) id<SKSKPopMenuDelegate> delegate;

-(void)hideInCenter:(CGPoint)center completion:(void(^)(void))completion;
@end

NS_ASSUME_NONNULL_END
