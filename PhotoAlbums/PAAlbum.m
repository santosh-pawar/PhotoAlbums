//
//  PAAlbum.m
//  PhotoAlbums
//
//  Created by Pawar, Santosh-CW on 4/7/15.
//  Copyright (c) 2015 Pawar, Santosh. All rights reserved.
//

#import "PAAlbum.h"
#import "PAPhoto.h"

@interface PAAlbum ()

@property (nonatomic, strong) NSMutableArray *mutablePhotos;

@end

@implementation PAAlbum

#pragma mark - Properties

- (NSArray *)photos
{
    return [self.mutablePhotos copy];
}


#pragma mark - Lifecycle

- (id)init
{
    self = [super init];
    if (self) {
        self.mutablePhotos = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Photos

- (void)addPhoto:(PAPhoto *)photo
{
    [self.mutablePhotos addObject:photo];
}

- (BOOL)removePhoto:(PAPhoto *)photo
{
    if ([self.mutablePhotos indexOfObject:photo] == NSNotFound) {
        return NO;
    }
    
    [self.mutablePhotos removeObject:photo];
    
    return YES;
}
@end