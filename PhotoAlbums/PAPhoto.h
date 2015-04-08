//
//  PAPhoto.h
//  PhotoAlbums
//
//  Created by Pawar, Santosh-CW on 4/7/15.
//  Copyright (c) 2015 Pawar, Santosh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PAPhoto : NSObject

@property (nonatomic, strong, readonly) NSString *imagePath;
@property (nonatomic, strong, readonly)  UIImage *image;

+ (PAPhoto *)photoWithImagePath:(NSString *)imagePath;

- (id)initWithImagePath:(NSString *)imagePath;

@end
