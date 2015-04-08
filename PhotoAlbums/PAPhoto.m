//
//  PAPhoto.m
//  PhotoAlbums
//
//  Created by Pawar, Santosh-CW on 4/7/15.
//  Copyright (c) 2015 Pawar, Santosh. All rights reserved.
//

#import "PAPhoto.h"

@interface PAPhoto ()

@property (nonatomic, strong, readwrite) NSString *imagePath;
@property (nonatomic, strong, readwrite) UIImage *image;

@end

@implementation PAPhoto

#pragma mark - Properties

- (UIImage *)image
{
    if (!_image && self.imagePath) {
//        NSData *imageData = [NSData dataWithContentsOfURL:self.imagePath];
        UIImage *image = [UIImage imageNamed:self.imagePath];
        
        _image = image;
    }
    
    return _image;
}

#pragma mark - Lifecycle

+ (PAPhoto *)photoWithImagePath:(NSString *)imagePath
{
    return [[self alloc] initWithImagePath:imagePath];
}

- (id)initWithImagePath:(NSString *)imagePath
{
    self = [super init];
    if (self) {
        self.imagePath = imagePath;
    }
    return self;
}

@end
