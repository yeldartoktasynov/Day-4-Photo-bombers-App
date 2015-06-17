//
//  PhotoCollectionViewCell.m
//  Day 4 Photo Bombers App
//
//  Created by yeldar.toktasynov on 17.06.15.
//  Copyright (c) 2015 yeldar.toktasynov. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame: frame];
    if (self){
        self.imageView = [UIImageView new];
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = self.contentView.bounds;
}



@end
