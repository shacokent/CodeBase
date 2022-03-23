//
//  SKCover.m
//  CodeBase
//
//  Created by hongchen li on 2021/12/8.
//  Copyright © 2021 shacokent. All rights reserved.
//
#import "SKCover.h"
@implementation SKCover

+(void)show{
    SKCover *cover = [[self alloc] init];
    //蒙版添加到window上
    [SKKeyWindow addSubview:cover];
    cover.frame = [UIScreen mainScreen].bounds;
    cover.backgroundColor = [UIColor blackColor];
    cover.alpha = 0.7f;
}

+(void)hide{
    for(UIView * view in SKKeyWindow.subviews){
        if([view isKindOfClass:[SKCover class]]){
            [view removeFromSuperview];
            break;
        }
    }
}
@end
