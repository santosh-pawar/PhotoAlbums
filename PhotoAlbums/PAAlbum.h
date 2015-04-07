//
//  PAAlbum.h
//  PhotoAlbums
//
//  Created by Pawar, Santosh-CW on 4/7/15.
//  Copyright (c) 2015 Pawar, Santosh. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PAPhoto;

@interface PAAlbum : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong, readonly) NSArray *photos;

- (void)addPhoto:(PAPhoto *)photo;
- (BOOL)removePhoto:(PAPhoto *)photo;


@end
