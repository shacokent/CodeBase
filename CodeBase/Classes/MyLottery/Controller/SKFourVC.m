//
//  SKFourVC.m
//  CodeBase
//
//  Created by hongchen li on 2022/2/9.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKFourVC.h"
#import "SKPhotoCell.h"
#import "SKFlowLayout.h"

@interface SKFourVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation SKFourVC

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
static NSString * const cid=@"cell";



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor purpleColor];
    
    //函数式编程思想抽取方法：
    //把很多功能放在一个函数块（block）去处理
    //编程思想：低耦合，高聚合物（代码聚合，方便管理）
    //普通思想
    int a = 2;
    int b = 3;
    int c1 = a+b;
    
    //函数式编程思想，一目了然，代码的目的是为了C得值
    int c=({
        int a = 2;
        int b = 3;
        a+b;
    });
    
    //创建流水布局
    //UICollectionView使用注意点
//    1.创建UICollectionView必须有布局参数
//    2.cell必须注册
//    3.cell必须自定义，系统cell没有任何子控件
    //流水布局,调整cell尺寸
    //利用布局做效果->如何让cell的尺寸不一样->自定义流水布局，重写系统的流水布局SKFlowLayout
    SKFlowLayout *layout =({
        SKFlowLayout *layout = [[SKFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(160, 160);//cell尺寸
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//滚动方向
    //    滚动方向改变，行会变成竖着的
        layout.minimumLineSpacing = 50;//最小行间距
    //    layout.minimumInteritemSpacing = 0;//最小列间距
        
    //    设置内边距让cell居中，不会滑动到边界
        CGFloat margin = (ScreenW-160)*0.5;
        layout.sectionInset  = UIEdgeInsetsMake(0, margin, 0, margin);
        layout;
    });
    
    
    //创建UICollectionView
    UICollectionView *collectionView =({
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor brownColor];
        collectionView.center =self.view.center;
        collectionView.bounds = CGRectMake(0, 0, self.view.bounds.size.width, 200);
        collectionView.showsHorizontalScrollIndicator = NO;//隐藏水平滚动条
        [self.view addSubview:collectionView];
        
        //设置数据源
        collectionView.dataSource =self;
        collectionView.delegate = self;
        //注册Cell
        collectionView;
    });
    
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SKPhotoCell class]) bundle:nil] forCellWithReuseIdentifier:cid];
}


//UICollectionViewDataSource
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //创建cell
    SKPhotoCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:cid forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    NSString *imageName = [NSString stringWithFormat:@"%ld",indexPath.row +1];
    cell.image = [UIImage imageNamed:imageName];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",(long)indexPath.item);
}

@end
