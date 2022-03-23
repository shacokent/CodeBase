//
//  SKPopMenu.m
//  CodeBase
//
//  Created by hongchen li on 2021/12/9.
//  Copyright © 2021 shacokent. All rights reserved.
//
#import "SKPopMenu.h"

@implementation SKPopMenu

- (IBAction)close:(id)sender {
    //代理通知外界惦记了X按钮
    if([self.delegate respondsToSelector:@selector(popMenuDidCloseBtn:)]){
        [self.delegate popMenuDidCloseBtn:self];
    }
}

+(instancetype)showInCenter:(CGPoint)center{
    UIView * popMenu = [[[NSBundle mainBundle] loadNibNamed:@"SKPopMenu" owner:nil options:nil] lastObject];
    popMenu.center = center;
    //非自动布局时，超出父控件剪切，关闭时避免图片显示
//    popMenu.layer.masksToBounds = YES;//方法一
//    popMenu.clipsToBounds = YES;//方法二
    [SKKeyWindow addSubview:popMenu];
    return popMenu;
}

-(void)hideInCenter:(CGPoint)center completion:(void(^)(void))completion{
    [UIView animateWithDuration:0.5f animations:^{
//        self.frame = CGRectMake(0, 0, 0, 0);
        //最终方案
        self.center = CGPointMake(44, 44);
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        //block当作参数传递，如果值为空，调用会直接崩溃
        if(completion){
            completion();
        }
    }];
}

@end
