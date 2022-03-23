//
//  UIWindow+SK.m
//  CodeBase
//
//  Created by hongchen li on 2021/12/8.
//  Copyright © 2021 shacokent. All rights reserved.
//

@implementation UIWindow (SK)
+ (UIWindow *)getKeyWindow
{
    if (@available(iOS 13.0, *))
    {
        for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive)
            {
                for (UIWindow *window in windowScene.windows)
                {
                    if (window.isKeyWindow)
                    {
                        return window;
                        break;
                    }
                }
            }
        }
    }
    else
    {
        return [UIApplication sharedApplication].keyWindow;
    }
    return nil;
}
@end
