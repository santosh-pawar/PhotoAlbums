//
//  PACollectionViewLayout.m
//  PhotoAlbums
//
//  Created by Pawar, Santosh-CW on 4/7/15.
//  Copyright (c) 2015 Pawar, Santosh. All rights reserved.
//

#import "PACollectionViewLayout.h"

static NSString * const PAPhotoAlbumLayoutPhotoCellKind = @"PhotoCell";
static NSUInteger const RotationCount = 32;
static NSUInteger const RotationStride = 3;
static NSUInteger const PhotoCellBaseZIndex = 100;
NSString * const PACollectionViewLayoutTitleKind = @"AlbumTitle";

@interface PACollectionViewLayout ()

@property (nonatomic,strong) NSDictionary *layoutInfo;
@property (nonatomic, strong) NSArray *rotations;

@end

@implementation PACollectionViewLayout
#pragma mark -
#pragma mark - Properties

- (void)setItemInsets:(UIEdgeInsets)itemInsets
{
    if (UIEdgeInsetsEqualToEdgeInsets(_itemInsets, itemInsets)) return;
    
    _itemInsets = itemInsets;
    
    [self invalidateLayout];
}

- (void)setItemSize:(CGSize)itemSize
{
    if (CGSizeEqualToSize(_itemSize, itemSize)) return;
    
    _itemSize = itemSize;
    
    [self invalidateLayout];
}

- (void)setInterItemSpacingY:(CGFloat)interItemSpacingY
{
    if (_interItemSpacingY == interItemSpacingY) return;
    
    _interItemSpacingY = interItemSpacingY;
    
    [self invalidateLayout];
}

- (void)setNumberOfColumns:(NSInteger)numberOfColumns
{
    if (_numberOfColumns == numberOfColumns) return;
    
    _numberOfColumns = numberOfColumns;
    
    [self invalidateLayout];
}

- (void)setTitleHeight:(CGFloat)titleHeight
{
    if (_titleHeight == titleHeight) return;
    
    _titleHeight = titleHeight;
    
    [self invalidateLayout];
}

#pragma mark -
#pragma mark Prepare Layouts

- (void)prepareLayout{
    NSMutableDictionary *newLayoutInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *cellLayoutInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *titleLayoutInfo = [NSMutableDictionary dictionary];

    NSInteger sectionCount = [self.collectionView numberOfSections];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    
    for(NSInteger section = 0; section < sectionCount; section++){
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        for (NSInteger item = 0; item < itemCount; item++) {
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            itemAttributes.frame = [self frameForAlbumPhotoAtIndexPath:indexPath];
            itemAttributes.transform3D = [self transformForAlbumPhotoAtIndex:indexPath];
            itemAttributes.zIndex = PhotoCellBaseZIndex + itemCount - item;

            cellLayoutInfo[indexPath] = itemAttributes;
            if (indexPath.item == 0) {
                UICollectionViewLayoutAttributes *titleAttributes = [UICollectionViewLayoutAttributes
                                                                     layoutAttributesForSupplementaryViewOfKind:PACollectionViewLayoutTitleKind
                                                                     withIndexPath:indexPath];
                titleAttributes.frame = [self frameForAlbumTitleAtIndexPath:indexPath];
                
                titleLayoutInfo[indexPath] = titleAttributes;
            }
        }
    }
    
    newLayoutInfo[PAPhotoAlbumLayoutPhotoCellKind] = cellLayoutInfo;
    newLayoutInfo[PACollectionViewLayoutTitleKind] = titleLayoutInfo;

    self.layoutInfo = newLayoutInfo;
}


- (CGRect)frameForAlbumTitleAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect frame = [self frameForAlbumPhotoAtIndexPath:indexPath];
    frame.origin.y += frame.size.height;
    frame.size.height = self.titleHeight;
    
    return frame;
}

- (CGRect)frameForAlbumPhotoAtIndexPath:(NSIndexPath*)indexPath{
    NSInteger row = indexPath.section / self.numberOfColumns;
    NSInteger column = indexPath.section % self.numberOfColumns;
    
    CGFloat spacingX = self.collectionView.bounds.size.width -
    self.itemInsets.left -
    self.itemInsets.right -
    (self.numberOfColumns * self.itemSize.width);
    
    if (self.numberOfColumns > 1) spacingX = spacingX / (self.numberOfColumns - 1);
    
    CGFloat originX = floorf(self.itemInsets.left + (self.itemSize.width + spacingX) * column);
    
    CGFloat originY = floor(self.itemInsets.top +
                            (self.itemSize.height  + self.titleHeight + self.interItemSpacingY) * row);
    
    return CGRectMake(originX, originY, self.itemSize.width, self.itemSize.height);
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:self.layoutInfo.count];
    [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSString *elementIdentifier, NSDictionary *elementsInfo, BOOL *stop) {
        [elementsInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attributes, BOOL *innerStop) {
            if(CGRectIntersectsRect(rect, attributes.frame)){
                [allAttributes addObject:attributes];
            }
        }];
    }];
    return allAttributes;
}

- (UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.layoutInfo[PAPhotoAlbumLayoutPhotoCellKind][indexPath];
}

- (CGSize)collectionViewContentSize{
    
    NSInteger rowCount = [self.collectionView numberOfSections]/self.numberOfColumns;
    
    if([self.collectionView numberOfSections]%self.numberOfColumns){
        rowCount++;
    }
    
    CGFloat height = self.itemInsets.top +
    rowCount * self.itemSize.height + (rowCount - 1) * self.interItemSpacingY + rowCount * self.titleHeight +
    self.itemInsets.bottom;
    
    return CGSizeMake(self.collectionView.bounds.size.width, height);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind
                                                                     atIndexPath:(NSIndexPath *)indexPath
{
    return self.layoutInfo[PACollectionViewLayoutTitleKind][indexPath];
}

#pragma mark -
#pragma mark Initialization

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    self.itemInsets = UIEdgeInsetsMake(22.0f, 22.0f, 13.0f, 22.0f);
    self.itemSize = CGSizeMake(125.0f, 125.0f);
    self.interItemSpacingY = 12.0f;
    self.numberOfColumns = 2;
    self.titleHeight = 26.0f;

    // create rotations at load so that they are consistent during prepareLayout
    NSMutableArray *rotations = [NSMutableArray arrayWithCapacity:RotationCount];

    CGFloat percentage = 0.0f;
    for (NSInteger i = 0; i < RotationCount; i++) {
        // Ensure that each angle is different enough to be seen
        CGFloat newPercentage = 0.0f;
        do {
            newPercentage = ((CGFloat)(arc4random() % 220) - 110) * 0.0001f;
        } while (fabsf(percentage - newPercentage) < 0.006);
        percentage = newPercentage;
        
        CGFloat angle = 2 * M_PI * (1.0f + percentage);
        CATransform3D transform = CATransform3DMakeRotation(angle, 0.0f, 0.0f, 1.0f);
        
        [rotations addObject:[NSValue valueWithCATransform3D:transform]];
    }
    
    self.rotations = rotations;
}

- (CATransform3D)transformForAlbumPhotoAtIndex:(NSIndexPath *)indexPath
{
    
    NSInteger offset = (indexPath.section * RotationStride + indexPath.item);
    return [self.rotations[offset % RotationCount] CATransform3DValue];
}

#pragma mark -
@end
