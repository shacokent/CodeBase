//
//  SKNewFeatureCollectionViewCell.h
//  CodeBase
//
//  Created by hongchen li on 2021/12/14.
//  Copyright © 2021 shacokent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SKNewFeatureCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImage * image;
-(void)setIndexPath:(NSIndexPath*)indexPath count:(NSUInteger)SKPage;
@end

NS_ASSUME_NONNULL_END
