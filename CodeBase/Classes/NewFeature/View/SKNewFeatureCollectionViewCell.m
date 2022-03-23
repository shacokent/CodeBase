//
//  SKNewFeatureCollectionViewCell.m
//  CodeBase
//
//  Created by hongchen li on 2021/12/14.
//  Copyright © 2021 shacokent. All rights reserved.
//

#import "SKNewFeatureCollectionViewCell.h"
#import "SKTabBarViewController.h"

@interface SKNewFeatureCollectionViewCell()

@property (nonatomic, weak) UIImageView * bgImageView;

@property (nonatomic, weak) UIButton *startBtn;
@end

@implementation SKNewFeatureCollectionViewCell

- (UIButton *)startBtn{
    if(!_startBtn){
        UIButton * btn = [[UIButton alloc] init];
        [btn setBackgroundImage:[UIImage imageNamed:@"guideStart"] forState:UIControlStateNormal];
        [btn sizeToFit];
        btn.center = CGPointMake(self.width/2, self.height * 0.9f);
        [btn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        _startBtn = btn;
    }
    return _startBtn;
}

//当点击立即体验时候调用
-(void)btnOnClick:(UIButton*)btn{
    //切换主界面：切换界面方式：Push(必须有导航控制器)，TabBar(必须有tabbar)，modale(需要控制器，并且会占用内存，新特性界面只更新才会显示一次，需要销毁)，切换更控制器（采用）
    //想让新特性销毁，清除新特性的强引用（window）
//    SKTabBarViewController * tabBarVc = [[SKTabBarViewController alloc] init];
//    SKKeyWindow.rootViewController = tabBarVc;
    SKKeyWindow.rootViewController = [SKRootVC chooseWindowRootVC];
    
}

- (UIImageView *)bgImageView{
    if(!_bgImageView){
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:imageView];
        _bgImageView = imageView;
    }
    return _bgImageView;
}

- (void)setImage:(UIImage *)image{
    _image = image;
    self.bgImageView.image = image;
}

-(void)setIndexPath:(NSIndexPath*)indexPath count:(NSUInteger)count{
    if(indexPath.item == count-1){
        self.startBtn.hidden =NO;
    }else{
        self.startBtn.hidden =YES;
    }
}

@end
