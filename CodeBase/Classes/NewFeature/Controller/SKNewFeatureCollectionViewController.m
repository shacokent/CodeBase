//
//  SKNewFeatureCollectionViewController.m
//  CodeBase
//
//  Created by hongchen li on 2021/12/14.
//  Copyright © 2021 shacokent. All rights reserved.
//

#import "SKNewFeatureCollectionViewController.h"
#import "SKNewFeatureCollectionViewCell.h"
@interface SKNewFeatureCollectionViewController ()

@property (nonatomic,assign) CGFloat lastOffsetX;

@property (nonatomic,weak) UIImageView *guide;
@property (nonatomic,weak) UIImageView *guideLargeTitle;
@property (nonatomic,weak) UIImageView *guideSmallTitle;

@end

@implementation SKNewFeatureCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

//必须添加layout否则报错
- (instancetype)init{
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    //修改item大小
    flowLayout.itemSize = [UIScreen mainScreen].bounds.size;
    //修改行间距
    flowLayout.minimumLineSpacing = 0;
    //修改item间距
    flowLayout.minimumInteritemSpacing = 0;
    //修改滚动方向改为水平
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //修改每组边距 上左下右
//    flowLayout.sectionInset = UIEdgeInsetsMake(100, 20, 30, 40);
    return [super initWithCollectionViewLayout:flowLayout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.collectionView不等于self.view
//    self.collectionView是添加到self.view的
//    self.view.backgroundColor = [UIColor yellowColor];
//    self.collectionView.backgroundColor = [UIColor redColor];
//    self.collectionView.height = 100;
//    self.collectionView.width = 100;
    
    //注册cell
    [self.collectionView registerClass:[SKNewFeatureCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
   // 设置分页
    self.collectionView.pagingEnabled = YES;
    //禁止弹簧效果
    self.collectionView.bounces = NO;
    //隐藏滚动条
    self.collectionView.showsHorizontalScrollIndicator = NO;
    //添加内容
    //添加图片
    //添加到collectionView
    [self setupAddChildImageView];
    //平移一个屏幕宽度，监听scrollView代理
}

//滑动减速调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //总偏移量
    CGFloat offsetX = scrollView.contentOffset.x;
    //计算一个的偏移量
    CGFloat del = offsetX - self.lastOffsetX;
    
    //切换图片
    NSInteger page = fabs(offsetX/del);
    NSString *guideName = [NSString stringWithFormat:@"guide%ld",page + 1];
    self.guide.image = [UIImage imageNamed:guideName];
    NSString *largeName = [NSString stringWithFormat:@"guideLargeText%ld",page + 1];
    self.guideLargeTitle.image = [UIImage imageNamed:largeName];
    NSString *smallName = [NSString stringWithFormat:@"guideSmallText%ld",page + 1];
    self.guideSmallTitle.image = [UIImage imageNamed:smallName];
    
    //让图片从右侧移动进屏幕的动画
    self.guide.x += del * 2;
    self.guideLargeTitle.x += del * 2;
    self.guideSmallTitle.x += del * 2;
    [UIView animateWithDuration:0.25 animations:^{
        self.guide.x -= del;
        self.guideLargeTitle.x -= del;
        self.guideSmallTitle.x -= del;
    }];
    self.lastOffsetX = offsetX;
}

-(void)setupAddChildImageView{
    //添加线图片
    UIImageView * guideLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guideLine"]];
    [self.collectionView addSubview: guideLine];
    guideLine.x -= 170;
    //球
    UIImageView * guide = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide1"]];
    [self.collectionView addSubview: guide];
    guide.x += 30;
    self.guide = guide;
    //大标题
    UIImageView * guideLargeTitle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guideLargeText1"]];
    [self.collectionView addSubview: guideLargeTitle];
    guideLargeTitle.center = CGPointMake(self.view.width/2, self.view.height*0.7f);
    self.guideLargeTitle = guideLargeTitle;
    
    //小标题
    UIImageView * guideSmallTitle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guideSmallText1"]];
    [self.collectionView addSubview: guideSmallTitle];
    guideSmallTitle.center = CGPointMake(self.view.width/2, self.view.height*0.8f);
    self.guideSmallTitle = guideSmallTitle;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

#define SKPage 4
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return SKPage;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SKNewFeatureCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
//    if(cell == nil){
//        cell = [[UICollectionViewCell alloc] init];
//    }
    //自定义cell添加imageview
    //创建image
    NSString *name = [NSString stringWithFormat:@"guide%ldBackground",indexPath.item+1];
    UIImage * image = [UIImage imageNamed:name];
    cell.image = image;
    //当最后一个cell添加立即体验按钮，在SKNewFeatureCollectionViewCell中封装方法
    [cell setIndexPath:indexPath count:SKPage];
    return cell;
}

#pragma mark - UICollectionViewDelegate


@end
