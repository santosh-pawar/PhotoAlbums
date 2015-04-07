//
//  PAAlbumPhotoCell.h
//  PhotoAlbums
//
//  Created by Pawar, Santosh-CW on 4/7/15.
//  Copyright (c) 2015 Pawar, Santosh. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const PhotoCellIdentifier = @"PhotoCell";

@interface PAAlbumPhotoCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UIImageView *imageView;

@end
