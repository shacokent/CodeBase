//
//  SKTabBar.m
//  CodeBase
//
//  Created by hongchen li on 2021/12/8.
//  Copyright © 2021 shacokent. All rights reserved.
//

#import "SKTabBar.h"
#import "SKTabBarButton.h"

@interface SKTabBar()

//记住选中的按钮
@property (nonatomic, weak) UIButton * selButton;

@end

@implementation SKTabBar

-(void)setBarItems:(NSArray *)barItems{
    _barItems = barItems;
    for(int i = 0; i<self.barItems.count; i++){
        SKTabBarButton *button = [[SKTabBarButton alloc] init];
        [self addSubview:button];
        UITabBarItem *tabBarItem = self.barItems[i];
        
        [button setBackgroundImage:tabBarItem.image forState:UIControlStateNormal];
        [button setBackgroundImage:tabBarItem.selectedImage forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonOnClick:) forControlEvents:UIControlEventTouchDown];
    }
}

-(void)buttonOnClick:(UIButton *)button{
    //取消上次选中
    self.selButton.selected = NO;
    //选中当前
    button.selected = YES;
    //记住选中按钮
    self.selButton = button;
    //通知外界切换自控制器
    if([self.delegate respondsToSelector:@selector(tabBar:index:)]){
        [self.delegate tabBar:self index:button.tag];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat buttonX = 0;
    CGFloat buttonY = 0;
    CGFloat buttonW = self.frame.size.width/self.barItems.count;
    CGFloat buttonH = self.frame.size.height;
    int i = 0;
    for(UIButton * button in self.subviews){
        if([button isKindOfClass:[UIButton class]]){
            button.tag = i;
            buttonX = buttonW * i;
            if(i == 0){
                [self buttonOnClick:button];
            }
            button.frame = CGRectMake(buttonX,buttonY, buttonW, buttonH);
            i++;
        }
    }
}
@end
