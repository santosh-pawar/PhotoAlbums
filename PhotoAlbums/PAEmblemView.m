//
//  PAEmblemView.m
//  PhotoAlbums
//
//  Created by Pawar, Santosh-CW on 4/8/15.
//  Copyright (c) 2015 Pawar, Santosh. All rights reserved.
//

#import "PAEmblemView.h"

static NSString * const PAEmblemViewImageName = @"emblem";

@implementation PAEmblemView

+ (CGSize)defaultSize
{
    return [UIImage imageNamed:PAEmblemViewImageName].size;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        UIImage *image = [UIImage imageNamed:PAEmblemViewImageName];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = self.bounds;
        [self addSubview:imageView];
    }
    return self;
}
@end
