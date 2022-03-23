//
//  SKMytabbarController.m
//  CodeBase
//
//  Created by hongchen li on 2022/2/9.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKMytabbarController.h"
#import "SKOneVC.h"
#import "SKTwoVC.h"
#import "SKThreeVC.h"

@interface SKMytabbarController ()
@property (weak, nonatomic) IBOutlet UIView *buttonsView;
@property (weak, nonatomic) IBOutlet UIView *childContentView;

/**
 weak和assign，什么时候使用
 weak：__weak修饰，弱指针，不会让引用计数器+1，如果指向的对象被销毁，指针会自动清空
 assign: __unsafe_unretained修饰，不会让引用计数器+1，指针会不会清空
 */

@end

@implementation SKMytabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupChildView];
    [self setupButtons];
    [self selectView:self.buttonsView.subviews[0]];
}

-(void)setupButtons{
    for(int i =0; i<self.buttonsView.subviews.count;i++){
        UIButton *btn = self.buttonsView.subviews[i];
        btn.tag = i;
        [btn setTitle:self.childViewControllers[i].title forState:UIControlStateNormal];
    }
}

-(void)setupChildView{
    SKOneVC *one = [[SKOneVC alloc] init];
    one.title = @"通知";
    [self addChildViewController:one];
    SKTwoVC *two = [[SKTwoVC alloc] init];
    two.title = @"block";
    [self addChildViewController:two];
    SKThreeVC *three = [[SKThreeVC alloc] init];
    three.title = @"three";
    [self addChildViewController:three];
}

-(void)selectView:(UIButton *)sender {
    [self.childContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIViewController *vc = self.childViewControllers[sender.tag];
    vc.view.backgroundColor = sender.backgroundColor;
    vc.view.frame = self.childContentView.bounds;
    [self.childContentView addSubview:vc.view];
}

- (IBAction)showChildView:(UIButton *)sender {
    [self selectView:sender];
}

@end
