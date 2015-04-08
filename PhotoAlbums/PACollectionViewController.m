//
//  PACollectionViewController.m
//  PhotoAlbums
//
//  Created by Pawar, Santosh-CW on 4/7/15.
//  Copyright (c) 2015 Pawar, Santosh. All rights reserved.
//

#import "PACollectionViewController.h"
#import "PACollectionViewLayout.h"
#import "PAAlbumPhotoCell.h"
#import "PAAlbum.h"
#import "PAPhoto.h"
#import "PAAlbumTitleReusableView.h"

static NSString * const AlbumTitleIdentifier = @"AlbumTitle";

@interface PACollectionViewController ()

@property(nonatomic,weak) IBOutlet PACollectionViewLayout *photoAlbumLayout;
@property (nonatomic, strong) NSMutableArray *albums;
@property (nonatomic, strong) NSOperationQueue *photoQueue;

@end

@implementation PACollectionViewController

#pragma mark -
#pragma mark Datasource & Delegate Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.albums.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    PAAlbum *album = self.albums[section];
    
    return album.photos.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PAAlbumPhotoCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:PhotoCellIdentifier forIndexPath:indexPath];
    PAAlbum *album = self.albums[indexPath.section];
    PAPhoto *photo = album.photos[indexPath.item];
    
    //Load the images in the background
    __weak PACollectionViewController *weakSelf = self;
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        UIImage *image = [photo image];
        dispatch_async(dispatch_get_main_queue(), ^{
            //Then set them via the main queue if the cell is still visible
            if([weakSelf.collectionView.indexPathsForVisibleItems containsObject:indexPath]){
                PAAlbumPhotoCell *cell = (PAAlbumPhotoCell*)[weakSelf.collectionView cellForItemAtIndexPath:indexPath];
                cell.imageView.image = image;
            }
        });
    }];

    operation.queuePriority = (indexPath.item == 0)?NSOperationQueuePriorityHigh:NSOperationQueuePriorityNormal;
    [self.photoQueue addOperation:operation];

    return photoCell;
}


- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    PAAlbumTitleReusableView *titleView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:AlbumTitleIdentifier forIndexPath:indexPath];
    PAAlbum *album = self.albums[indexPath.section];
    titleView.titleLabel.text = album.name;

    return titleView;
}
#pragma mark -
#pragma mark View Rotation

/*- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        self.photoAlbumLayout.numberOfColumns = 3;
        
        // handle insets for iPhone 4 or 5
        CGFloat sideInset = [UIScreen mainScreen].preferredMode.size.width == 1136.0f ?
        45.0f : 25.0f;
        
        self.photoAlbumLayout.itemInsets = UIEdgeInsetsMake(22.0f, sideInset, 13.0f, sideInset);
        
    } else {
        self.photoAlbumLayout.numberOfColumns = 2;
        self.photoAlbumLayout.itemInsets = UIEdgeInsetsMake(22.0f, 22.0f, 13.0f, 22.0f);
    }
}*/

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
         if (UIInterfaceOrientationIsLandscape(orientation)) {
             self.photoAlbumLayout.numberOfColumns = 3;
             
             // handle insets for iPhone 4 or 5
             CGFloat sideInset = [UIScreen mainScreen].preferredMode.size.width;
             
             self.photoAlbumLayout.itemInsets = UIEdgeInsetsMake(22.0f, sideInset, 13.0f, sideInset);
             
         } else {
             self.photoAlbumLayout.numberOfColumns = 2;
             self.photoAlbumLayout.itemInsets = UIEdgeInsetsMake(22.0f, 22.0f, 13.0f, 22.0f);
         }
     } completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         
     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

#pragma mark -
#pragma mark Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.photoQueue = [[NSOperationQueue alloc] init];
    self.photoQueue.maxConcurrentOperationCount = 3;
    
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.25f alpha:1.0f];
    
    [self.collectionView registerClass:[PAAlbumPhotoCell class] forCellWithReuseIdentifier:PhotoCellIdentifier];
    
    self.albums = [NSMutableArray array];
    
    NSInteger photoIndex = 1;
    
    //There are 46 photos in this app bundle
    for (NSInteger index = 0; index < 46; index++) {
        PAAlbum *album = [[PAAlbum alloc] init];
        album.name = [NSString stringWithFormat:@"Photo Album %ld",index + 1];
        
        NSUInteger photoCount = arc4random()%4 + 2;
        for (NSInteger p = 0; p < photoCount; p++) {
            NSString *photoFilename = [NSString stringWithFormat:@"photo%ld.jpg",photoIndex % 47];
            PAPhoto *photo = [PAPhoto photoWithImagePath:photoFilename];
            [album addPhoto:photo];
            
            photoIndex++;
        }
        
        [self.albums addObject:album];
    }
    
    [self.collectionView registerClass:[PAAlbumTitleReusableView class]
            forSupplementaryViewOfKind:PACollectionViewLayoutTitleKind
                   withReuseIdentifier:AlbumTitleIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
@end
