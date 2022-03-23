//
//  SKWangYiViewController.m
//  CodeBase
//
//  Created by hongchen li on 2022/2/9.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKWangYiViewController.h"
#import "SKOneVC.h"
#import "SKTwoVC.h"
#import "SKThreeVC.h"
#import "SKFourVC.h"
#import "SKFiveVC.h"
#import "SKSixVC.h"

/*
 补充：
 UIScrollView做自动布局，首先确定scrollView滚动范围=>如何在stroboard对scrollView确定滚动范围 => scrollView添加一个View去确定scrollView的滚动范围 => 如何确定：水平和垂直方向 => 水平能否滚动：view的宽度+左右两边间距，才能确定scrollview水平滚动区域 => 垂直同理：View高度+上下两边间距
 
 frame和bounds区别
 frame从左上角放大，以父控件的左上角为原点
 bounds从中心点放大，以自己的左上角为原点
 如果用frame取大小，先设置center在设置size，有问题，需要先设置size在设置center
     CGRect frame = view.frame;
     frame.size = CGSizeMake(200,200);
     view.frame = frame;
     view.center = self.view.center;
 如果使用bounds取大小，就不用考虑center和size的区别
     CGRect bounds = view.bounds;
     bounds.size = CGSizeMake(200,200);
     view.bounds = bounds;
     view.center = self.view.center;
 
 frame和bounds共同点：都是用来描述一块区域的
 frame：可视范围
 bounds：描述可视范围在内容的区域
 所有的子控件都是相对于内容的
 bounds：本质是修改内容的原点
 
 相对性：可是范围相对于父控件是不变的，相对于内容是变化的
 
 
 */
#define SCwidth [UIScreen mainScreen].bounds.size.width
#define SCheight [UIScreen mainScreen].bounds.size.height

@interface SKWangYiViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIButton *selectBtn;
@property (nonatomic,strong) UIScrollView *titleScrollView;
@property (nonatomic,strong) UIScrollView *contentScrollView;

@property (nonatomic,strong) NSMutableArray *titleBtnArray;
@end


@implementation SKWangYiViewController

- (NSMutableArray *)titleBtnArray{
    if(_titleBtnArray == nil){
        _titleBtnArray = [NSMutableArray array];
    }
    return _titleBtnArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"网易新闻";
    //添加标题滚动视图
    [self setupTitleScrollView];
    //添加内容滚动视图
    [self setupContentScrollView];
    //添加所有自控制器
    [self setupAllChildController];
    //添加所有标题
    [self setupAllTitle];
//   bug:scrollview标题显示不出来,   内容往下移动，莫名其妙，ios7以后ScrollView默认设置了64的额外缓冲区
    if (@available(iOS 7.0, *)) {
        if(@available(iOS 11.0, *)){}
        else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
}

-(void)setupTitleScrollView{
    //创建UIScrollView
    UIScrollView *titleScrollView = [[UIScrollView alloc]init];
    titleScrollView.backgroundColor = [UIColor yellowColor];
    CGFloat y = self.navigationController.navigationBarHidden?20:90;
    titleScrollView.frame = CGRectMake(0, y, SCwidth, 44);
    [self.view addSubview:titleScrollView];
    _titleScrollView = titleScrollView;
}

-(void)setupContentScrollView{
    UIScrollView *contentScrollView = [[UIScrollView alloc]init];
    contentScrollView.backgroundColor = [UIColor whiteColor];
    CGFloat y =CGRectGetMaxY(self.titleScrollView.frame);
    contentScrollView.frame = CGRectMake(0, y, SCwidth, SCheight-y);
    [self.view addSubview:contentScrollView];
    _contentScrollView = contentScrollView;
    //添加分页,滑动还原效果
    self.contentScrollView.pagingEnabled = YES;
    //关闭弹簧效果
    self.contentScrollView.bounces = NO;
    //指示器
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    //设置代理
    contentScrollView.delegate = self;
}
//滚动完成
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //获取按钮的角标
    NSInteger i = scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
//    1、选中标题
    UIButton *btn = self.titleBtnArray[i];
    [self selectBtn:btn];
//    2、对应子控制器添加
    [self setupOneViewController:i];
}

//滚动时
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //字体缩放：缩放比例，缩放那两个按钮
    NSInteger lefti = scrollView.contentOffset.x/SCwidth;
    NSInteger righti = lefti+1;
    //获取左边按钮
    UIButton *leftbtn = self.titleBtnArray[lefti];
    NSInteger count = self.titleBtnArray.count;
    //获取右边按钮
    UIButton *rightbtn;
    if(righti < count){
        rightbtn = self.titleBtnArray[righti];
    }
    //计算缩放比例 0～1 转换成 1~1.3
    CGFloat scaleR = scrollView.contentOffset.x/SCwidth;
    scaleR -=lefti;
    CGFloat scaleL = 1-scaleR;
    leftbtn.transform = CGAffineTransformMakeScale(scaleL*0.3+1, scaleL*0.3+1);
    rightbtn.transform = CGAffineTransformMakeScale(scaleR*0.3+1, scaleR*0.3+1);
    
    //颜色渐变
//R:红，G：绿，B L：蓝
//    白色：1，1，1
//    黑色：0，0，0
//    红色：1，0，0
    UIColor *colorR = [UIColor colorWithRed:scaleR green:0 blue:0 alpha:1];
    UIColor *colorL = [UIColor colorWithRed:scaleL green:0 blue:0 alpha:1];
    [leftbtn setTitleColor:colorL forState:UIControlStateNormal];
    [rightbtn setTitleColor:colorR forState:UIControlStateNormal];
}

-(void)setupAllChildController{
    SKOneVC *one = [[SKOneVC alloc] init];
    one.title = @"one";
    //注意不要在这里加载背景颜色，会一起把所有控制器都加载，没必要，所以在对应的控制器类中设置颜色
//    one.view.backgroundColor = [UIColor redColor];
    [self addChildViewController:one];
    SKTwoVC *two = [[SKTwoVC alloc] init];
    two.title = @"two";
    [self addChildViewController:two];
    SKThreeVC *three = [[SKThreeVC alloc] init];
    three.title = @"three";
    [self addChildViewController:three];
    SKFourVC *four = [[SKFourVC alloc] init];
    four.title = @"four";
    [self addChildViewController:four];
    SKFiveVC *five = [[SKFiveVC alloc] init];
    five.title = @"five";
    [self addChildViewController:five];
    SKSixVC *six = [[SKSixVC alloc] init];
    six.title = @"six";
    [self addChildViewController:six];
}

-(void)setupAllTitle{
    //添加所有标题按钮
    NSUInteger count = self.childViewControllers.count;
    for(NSUInteger i =0 ;i<count;i++){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        UIViewController *vc = self.childViewControllers[i];
        [btn setTitle:vc.title forState:UIControlStateNormal];
        btn.tag = i;
        btn.frame = CGRectMake(i*100, 0, 100, self.titleScrollView.bounds.size.height);
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        //标题按钮保存在数组中
        [self.titleBtnArray addObject:btn];
        if(i==0){
            [self titleClick:btn];
        }
        [self.titleScrollView addSubview:btn];
        
    }
    
    //设置标题滚动范围
    self.titleScrollView.contentSize = CGSizeMake(count*100, 0);
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
    
    //设置内容滚动区域
    self.contentScrollView.contentSize = CGSizeMake(SCwidth * count,0);
}

-(void)setupOneViewController:(NSInteger)i{
    UIViewController *vc = self.childViewControllers[i];
//    方法一，需要9.0以上才可以
//    if (@available(iOS 9.0, *)) {
//        if(vc.viewIfLoaded){
//            return;
//        }
//    }
    //方法二，判断有没有父窗口就好了
    if(vc.view.superview){
        return;
    }
    
    vc.view.frame = CGRectMake(i * SCwidth, 0, SCwidth, SCheight);
    [self.contentScrollView addSubview:vc.view];
}

-(void)titleClick:(UIButton*)btn{
    //选中按钮标题变红
    [self selectBtn:btn];
    //添加子制器
    NSInteger i = btn.tag;
    [self setupOneViewController:i];
    //内容滚动到对应位置
    self.contentScrollView.contentOffset = CGPointMake(i*SCwidth, 0);
}

-(void)selectBtn:(UIButton*)btn{
    _selectBtn.transform = CGAffineTransformIdentity;
    [_selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    //标题居中
    [self setTitleCenter:btn];
    //字体缩放，更改按钮形变
    btn.transform = CGAffineTransformMakeScale(1.3, 1.3);
    _selectBtn = btn;
}

//标题居中
-(void)setTitleCenter:(UIButton *)btn{
    CGFloat offsetx = btn.center.x - SCwidth*0.5;
    if(offsetx<0){
        offsetx=0;
    }
    
    else if(offsetx > self.titleScrollView.contentSize.width-SCwidth){
        offsetx=self.titleScrollView.contentSize.width-SCwidth;
    }
    [self.titleScrollView setContentOffset:CGPointMake(offsetx, 0) animated:YES];
}

@end
