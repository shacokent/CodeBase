//
//  SKTitleViewButton.m
//  CodeBase
//
//  Created by hongchen li on 2021/12/13.
//  Copyright © 2021 shacokent. All rights reserved.
//

#import "SKTitleViewButton.h"

@implementation SKTitleViewButton


//方法一：调整子控件位置
//调整image View位置
//- (CGRect)imageRectForContentRect:(CGRect)contentRect{
//
//}

//调整titlelable位置
//- (CGRect)titleRectForContentRect:(CGRect)contentRect{
//
//}

//方法二：调整子控件位置
- (void)layoutSubviews{
    [super layoutSubviews];
    if(self.imageView.x < self.titleLabel.x){
        self.titleLabel.x = self.imageView.x;
        self.imageView.x = CGRectGetMaxX(self.titleLabel.frame);
    }
}

-(void)setTitle:(NSString *)title forState:(UIControlState)state{
    [super setTitle:title forState:state];
    [self sizeToFit];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state{
    [super setImage:image forState:state];
    [self sizeToFit];
}

@end
