//
//  SKFlowLayout.m
//  CodeBase
//
//  Created by hongchen li on 2022/2/17.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKFlowLayout.h"
/*
 自定义布局：只要了解5个方法
 - (CGSize)collectionViewContentSize;
 - (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds;
 - (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity;
 - (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect;
 - (void)prepareLayout;
 */
@implementation SKFlowLayout
//重写方法，扩展功能

//计算collectionView滚动范围
//- (CGSize)collectionViewContentSize{
//    return [super collectionViewContentSize];
//}

//在滚动collectionView的时候是否允许刷新布局
//Invalidate：刷新
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{

    return YES;
}


//确定最终的偏移量
//什么时候调用：用户手指一松开就会调用
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    //最终偏移量 不一定等于 手指离开时偏移量（因为有缓存（拖动快的时候有惯性），只有拖动慢的时候才可能会相等）
    
    //最终偏移量
    CGPoint targetP = [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
    
    //手指离开的偏移量 == collectionView的偏移量
//    CGPoint targetFP = self.collectionView.contentOffset;
    
    //距离中心点越近，这个cell最终展示到中心点
//    1.获取最终显示区域
    CGRect targetRect = CGRectMake(targetP.x, targetP.y, self.collectionView.bounds.size.width, MAXFLOAT);
    
//    2.获取最终显示的cell
    NSArray *attrs = [super layoutAttributesForElementsInRect:targetRect];
    
    //找出距离中心点最近的cell的距离
    CGFloat mindelta = MAXFLOAT;
    for(UICollectionViewLayoutAttributes *attr in attrs){
        //求cell与中心点距离
        CGFloat delta = fabs(attr.center.x-self.collectionView.contentOffset.x-self.collectionView.bounds.size.width*0.5);
        //计算比例
        if(fabs(delta) < fabs(mindelta)){
            mindelta = delta;
        }
    }
    
    targetP.x += mindelta;
    if(targetP.x < 0 ){
        targetP.x = 0;
    }
    return targetP;

}

//UICollectionViewLayoutAttributes:确定cell淂尺寸
//一个UICollectionViewLayoutAttributes对象对应一个cell
//拿到UICollectionViewLayoutAttributes相当于拿到cell
//作用：返回很多cell的尺寸，指定一块区域就会，给你这段区域内的cell的尺寸
- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
//    NSArray *attrs = [super layoutAttributesForElementsInRect:rect];//只能获取这段区域的cell
//    NSArray *attrs = [super layoutAttributesForElementsInRect:CGRectMake(0, 0, MAXFLOAT, MAXFLOAT)];//拿到所有cell的尺寸，传一个无限大的rect，可以获取所有的cell
    
    //获取当前显示区域
    NSArray *attrs = [super layoutAttributesForElementsInRect:self.collectionView.bounds];
    //越靠近中心点越大
    for(UICollectionViewLayoutAttributes *attr in attrs){
        //求cell与中心点距离
        CGFloat delta = fabs(attr.center.x-self.collectionView.contentOffset.x-self.collectionView.bounds.size.width*0.5);
        //计算比例
        CGFloat scale = 1 - delta/(self.collectionView.bounds.size.width*0.5)*0.3;
        attr.transform = CGAffineTransformMakeScale(scale, scale);
    }

    return attrs;
}

//作用：计算cell布局,条件:cell的位置固定不变
//什么时候调用：collectionView第一次布局，collectionView刷新时候也会调用
//必须调用super
//- (void)prepareLayout{
//    [super prepareLayout];
//}

@end
