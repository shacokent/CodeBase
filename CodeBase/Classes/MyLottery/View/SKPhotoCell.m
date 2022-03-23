//
//  SKPhotoCell.m
//  CodeBase
//
//  Created by hongchen li on 2022/2/16.
//  Copyright © 2022 shacokent. All rights reserved.
//

#import "SKPhotoCell.h"
@interface SKPhotoCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
@implementation SKPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setImage:(UIImage *)image{
    _image = image;
    _imageView.image = image;
}

@end
