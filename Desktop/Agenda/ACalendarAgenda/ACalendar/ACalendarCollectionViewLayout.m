#import "ACalendarCollectionViewLayout.h"
#import "ACalendar.h"
#import "ACalendarDynamicHeader.h"
#import "ACalendarCollectionView.h"
#import "ACalendarExtensions.h"
#import "ACalendarConstants.h"

#define kACalendarSeparatorInterRows @"ACalendarSeparatorInterRows"
#define kACalendarSeparatorInterColumns @"ACalendarSeparatorInterColumns"

@interface ACalendarCollectionViewLayout ()

@property (assign, nonatomic) CGFloat *widths;
@property (assign, nonatomic) CGFloat *heights;
@property (assign, nonatomic) CGFloat *lefts;
@property (assign, nonatomic) CGFloat *tops;

@property (assign, nonatomic) CGFloat *sectionHeights;
@property (assign, nonatomic) CGFloat *sectionTops;
@property (assign, nonatomic) CGFloat *sectionBottoms;
@property (assign, nonatomic) CGFloat *sectionRowCounts;

@property (assign, nonatomic) CGSize estimatedItemSize;

@property (assign, nonatomic) CGSize contentSize;
@property (assign, nonatomic) CGSize collectionViewSize;
@property (assign, nonatomic) NSInteger numberOfSections;

@property (assign, nonatomic) ACalendarSeparators separators;

@property (strong, nonatomic) NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *itemAttributes;
@property (strong, nonatomic) NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *headerAttributes;
@property (strong, nonatomic) NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *rowSeparatorAttributes;

- (void)didReceiveNotifications:(NSNotification *)notification;

@end

@implementation ACalendarCollectionViewLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.estimatedItemSize = CGSizeZero;
        self.widths = NULL;
        self.heights = NULL;
        self.tops = NULL;
        self.lefts = NULL;
        
        self.sectionHeights = NULL;
        self.sectionTops = NULL;
        self.sectionBottoms = NULL;
        self.sectionRowCounts = NULL;
        
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.sectionInsets = UIEdgeInsetsMake(5, 0, 5, 0);
        
        self.itemAttributes = [NSMutableDictionary dictionary];
        self.headerAttributes = [NSMutableDictionary dictionary];
        self.rowSeparatorAttributes = [NSMutableDictionary dictionary];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotifications:) name:UIDeviceOrientationDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotifications:) name:UIScreenDidConnectNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotifications:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        
        [self registerClass:[ACalendarSeparator class] forDecorationViewOfKind:kACalendarSeparatorInterRows];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    
    free(self.widths);
    free(self.heights);
    free(self.tops);
    free(self.lefts);
    
    free(self.sectionHeights);
    free(self.sectionTops);
    free(self.sectionRowCounts);
    free(self.sectionBottoms);
}

- (void)prepareLayout
{
    if (CGSizeEqualToSize(self.collectionViewSize, self.collectionView.frame.size) && self.numberOfSections == self.collectionView.numberOfSections && self.separators == self.calendar.appearance.separators) {
        return;
    }
    self.collectionViewSize = self.collectionView.frame.size;
    self.separators = self.calendar.appearance.separators;
    
    [self.itemAttributes removeAllObjects];
    [self.headerAttributes removeAllObjects];
    [self.rowSeparatorAttributes removeAllObjects];
    
    self.headerReferenceSize = ({
        CGSize headerSize = CGSizeZero;
        if (self.calendar.floatingMode) {
            CGFloat headerHeight = self.calendar.preferredWeekdayHeight*1.5+self.calendar.preferredHeaderHeight;
            headerSize = CGSizeMake(self.collectionView.A_width, headerHeight);
        }
        headerSize;
    });
    self.estimatedItemSize = ({
        CGFloat width = (self.collectionView.A_width-self.sectionInsets.left-self.sectionInsets.right)/7.0;
        CGFloat height = ({
            CGFloat height = ACalendarStandardRowHeight;
            if (!self.calendar.floatingMode) {
                switch (self.calendar.transitionCoordinator.representingScope) {
                    case ACalendarScopeMonth: {
                        height = (self.collectionView.A_height-self.sectionInsets.top-self.sectionInsets.bottom)/6.0;
                        break;
                    }
                    case ACalendarScopeWeek: {
                        height = (self.collectionView.A_height-self.sectionInsets.top-self.sectionInsets.bottom);
                        break;
                    }
                    default:
                        break;
                }
            } else {
                height = self.calendar.rowHeight;
            }
            height;
        });
        CGSize size = CGSizeMake(width, height);
        size;
    });
    
    // Calculate item widths and lefts
    free(self.widths);
    self.widths = ({
        NSInteger columnCount = 7;
        size_t columnSize = sizeof(CGFloat)*columnCount;
        CGFloat *widths = malloc(columnSize);
        CGFloat contentWidth = self.collectionView.A_width - self.sectionInsets.left - self.sectionInsets.right;
        ACalendarSliceCake(contentWidth, columnCount, widths);
        widths;
    });
    
    free(self.lefts);
    self.lefts = ({
        NSInteger columnCount = 7;
        size_t columnSize = sizeof(CGFloat)*columnCount;
        CGFloat *lefts = malloc(columnSize);
        lefts[0] = self.sectionInsets.left;
        for (int i = 1; i < columnCount; i++) {
            lefts[i] = lefts[i-1] + self.widths[i-1];
        }
        lefts;
    });
    
    // Calculate item heights and tops
    free(self.heights);
    self.heights = ({
        NSInteger rowCount = self.calendar.transitionCoordinator.representingScope == ACalendarScopeWeek ? 1 : 6;
        size_t rowSize = sizeof(CGFloat)*rowCount;
        CGFloat *heights = malloc(rowSize);
        if (!self.calendar.floatingMode) {
            CGFloat contentHeight = self.collectionView.A_height - self.sectionInsets.top - self.sectionInsets.bottom;
            ACalendarSliceCake(contentHeight, rowCount, heights);
        } else {
            for (int i = 0; i < rowCount; i++) {
                heights[i] = self.estimatedItemSize.height;
            }
        }
        heights;
    });
    
    free(self.tops);
    self.tops = ({
        NSInteger rowCount = self.calendar.transitionCoordinator.representingScope == ACalendarScopeWeek ? 1 : 6;
        size_t rowSize = sizeof(CGFloat)*rowCount;
        CGFloat *tops = malloc(rowSize);
        tops[0] = self.sectionInsets.top;
        for (int i = 1; i < rowCount; i++) {
            tops[i] = tops[i-1] + self.heights[i-1];
        }
        tops;
    });
    
    // Calculate content size
    self.numberOfSections = self.collectionView.numberOfSections;
    self.contentSize = ({
        CGSize contentSize = CGSizeZero;
        if (!self.calendar.floatingMode) {
            CGFloat width = self.collectionView.A_width;
            CGFloat height = self.collectionView.A_height;
            switch (self.scrollDirection) {
                case UICollectionViewScrollDirectionHorizontal: {
                    width *= self.numberOfSections;
                    break;
                }
                case UICollectionViewScrollDirectionVertical: {
                    height *= self.numberOfSections;
                    break;
                }
                default:
                    break;
            }
            contentSize = CGSizeMake(width, height);
        } else {
            free(self.sectionHeights);
            self.sectionHeights = malloc(sizeof(CGFloat)*self.numberOfSections);
            free(self.sectionRowCounts);
            self.sectionRowCounts = malloc(sizeof(NSInteger)*self.numberOfSections);
            CGFloat width = self.collectionView.A_width;
            CGFloat height = 0;
            for (int i = 0; i < self.numberOfSections; i++) {
                NSInteger rowCount = [self.calendar.calculator numberOfRowsInSection:i];
                self.sectionRowCounts[i] = rowCount;
                CGFloat sectionHeight = self.headerReferenceSize.height;
                for (int j = 0; j < rowCount; j++) {
                    sectionHeight += self.heights[j];
                }
                self.sectionHeights[i] = sectionHeight;
                height += sectionHeight;
            }
            free(self.sectionTops);
            self.sectionTops = malloc(sizeof(CGFloat)*self.numberOfSections);
            free(self.sectionBottoms);
            self.sectionBottoms = malloc(sizeof(CGFloat)*self.numberOfSections);
            self.sectionTops[0] = 0;
            self.sectionBottoms[0] = self.sectionHeights[0];
            for (int i = 1; i < self.numberOfSections; i++) {
                self.sectionTops[i] = self.sectionTops[i-1] + self.sectionHeights[i-1];
                self.sectionBottoms[i] = self.sectionTops[i] + self.sectionHeights[i];
            }
            contentSize = CGSizeMake(width, height);
        }
        contentSize;
    });
    
    [self.calendar adjustMonthPosition];
}

- (CGSize)collectionViewContentSize
{
    return self.contentSize;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    // Clipping
    rect = CGRectIntersection(rect, CGRectMake(0, 0, self.contentSize.width, self.contentSize.height));
    if (CGRectIsEmpty(rect)) return nil;
    
    // Calculating attributes
    NSMutableArray<UICollectionViewLayoutAttributes *> *layoutAttributes = [NSMutableArray array];
    
    if (!self.calendar.floatingMode) {
        
        switch (self.scrollDirection) {
            case UICollectionViewScrollDirectionHorizontal: {
                
                NSInteger startColumn = ({
                    NSInteger startSection = rect.origin.x/self.collectionView.A_width;
                    CGFloat widthDelta = ACalendarMod(CGRectGetMinX(rect), self.collectionView.A_width)-self.sectionInsets.left;
                    widthDelta = MIN(MAX(0, widthDelta), self.collectionView.A_width-self.sectionInsets.left);
                    NSInteger countDelta = ACalendarFloor(widthDelta/self.estimatedItemSize.width);
                    NSInteger startColumn = startSection*7 + countDelta;
                    startColumn;
                });
                
                NSInteger endColumn = ({
                    NSInteger endColumn;
                    CGFloat section = CGRectGetMaxX(rect)/self.collectionView.A_width;
                    CGFloat remainder = ACalendarMod(section, 1);
                    // https://stackoverflow.com/a/10335601/2398107
                    if (remainder <= MAX(100*FLT_EPSILON*ABS(remainder), FLT_MIN)) {
                        endColumn = ACalendarFloor(section)*7 - 1;
                    } else {
                        CGFloat widthDelta = ACalendarMod(CGRectGetMaxX(rect), self.collectionView.A_width)-self.sectionInsets.left;
                        widthDelta = MIN(MAX(0, widthDelta), self.collectionView.A_width - self.sectionInsets.left);
                        NSInteger countDelta = ACalendarCeil(widthDelta/self.estimatedItemSize.width);
                        endColumn = ACalendarFloor(section)*7 + countDelta - 1;
                    }
                    endColumn;
                });
                
                NSInteger numberOfRows = self.calendar.transitionCoordinator.representingScope == ACalendarScopeMonth ? 6 : 1;
                
                for (NSInteger column = startColumn; column <= endColumn; column++) {
                    for (NSInteger row = 0; row < numberOfRows; row++) {
                        NSInteger section = column / 7;
                        NSInteger item = column % 7 + row * 7;
                        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
                        UICollectionViewLayoutAttributes *itemAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
                        [layoutAttributes addObject:itemAttributes];
                        
                        UICollectionViewLayoutAttributes *rowSeparatorAttributes = [self layoutAttributesForDecorationViewOfKind:kACalendarSeparatorInterRows atIndexPath:indexPath];
                        if (rowSeparatorAttributes) {
                            [layoutAttributes addObject:rowSeparatorAttributes];
                        }
                    }
                }
                
                break;
            }
            case UICollectionViewScrollDirectionVertical: {
                
                NSInteger startRow = ({
                    NSInteger startSection = rect.origin.y/self.collectionView.A_height;
                    CGFloat heightDelta = ACalendarMod(CGRectGetMinY(rect), self.collectionView.A_height)-self.sectionInsets.top;
                    heightDelta = MIN(MAX(0, heightDelta), self.collectionView.A_height-self.sectionInsets.top);
                    NSInteger countDelta = ACalendarFloor(heightDelta/self.estimatedItemSize.height);
                    NSInteger startRow = startSection*6 + countDelta;
                    startRow;
                });
                
                NSInteger endRow = ({
                    NSInteger endRow;
                    CGFloat section = CGRectGetMaxY(rect)/self.collectionView.A_height;
                    CGFloat remainder = ACalendarMod(section, 1);
                    // https://stackoverflow.com/a/10335601/2398107
                    if (remainder <= MAX(100*FLT_EPSILON*ABS(remainder), FLT_MIN)) {
                        endRow = ACalendarFloor(section)*6 - 1;
                    } else {
                        CGFloat heightDelta = ACalendarMod(CGRectGetMaxY(rect), self.collectionView.A_height)-self.sectionInsets.top;
                        heightDelta = MIN(MAX(0, heightDelta), self.collectionView.A_height-self.sectionInsets.top);
                        NSInteger countDelta = ACalendarCeil(heightDelta/self.estimatedItemSize.height);
                        endRow = ACalendarFloor(section)*6 + countDelta-1;
                    }
                    endRow;
                });
                
                for (NSInteger row = startRow; row <= endRow; row++) {
                    for (NSInteger column = 0; column < 7; column++) {
                        NSInteger section = row / 6;
                        NSInteger item = column + (row % 6) * 7;
                        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
                        UICollectionViewLayoutAttributes *itemAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
                        [layoutAttributes addObject:itemAttributes];
                        
                        UICollectionViewLayoutAttributes *rowSeparatorAttributes = [self layoutAttributesForDecorationViewOfKind:kACalendarSeparatorInterRows atIndexPath:indexPath];
                        if (rowSeparatorAttributes) {
                            [layoutAttributes addObject:rowSeparatorAttributes];
                        }
                        
                    }
                }
                
                break;
            }
            default:
                break;
        }
        
    } else {
        
        NSInteger startSection = [self searchStartSection:rect :0 :self.numberOfSections-1];
        NSInteger startRowIndex = ({
            CGFloat heightDelta1 = MIN(self.sectionBottoms[startSection]-CGRectGetMinY(rect)-self.sectionInsets.bottom, self.sectionRowCounts[startSection]*self.estimatedItemSize.height);
            NSInteger startRowCount = ACalendarCeil(heightDelta1/self.estimatedItemSize.height);
            NSInteger startRowIndex = self.sectionRowCounts[startSection]-startRowCount;
            startRowIndex;
        });
        
        NSInteger endSection = [self searchEndSection:rect :startSection :self.numberOfSections-1];
        NSInteger endRowIndex = ({
            CGFloat heightDelta2 = MAX(CGRectGetMaxY(rect) - self.sectionTops[endSection]- self.headerReferenceSize.height - self.sectionInsets.top, 0);
            NSInteger endRowCount = ACalendarCeil(heightDelta2/self.estimatedItemSize.height);
            NSInteger endRowIndex = endRowCount - 1;
            endRowIndex;
        });
        for (NSInteger section = startSection; section <= endSection; section++) {
            NSInteger startRow = (section == startSection) ? startRowIndex : 0;
            NSInteger endRow = (section == endSection) ? endRowIndex : self.sectionRowCounts[section]-1;
            UICollectionViewLayoutAttributes *headerAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            [layoutAttributes addObject:headerAttributes];
            for (NSInteger row = startRow; row <= endRow; row++) {
                for (NSInteger column = 0; column < 7; column++) {
                    NSInteger item = row * 7 + column;
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
                    UICollectionViewLayoutAttributes *itemAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
                    [layoutAttributes addObject:itemAttributes];
                    UICollectionViewLayoutAttributes *rowSeparatorAttributes = [self layoutAttributesForDecorationViewOfKind:kACalendarSeparatorInterRows atIndexPath:indexPath];
                    if (rowSeparatorAttributes) {
                        [layoutAttributes addObject:rowSeparatorAttributes];
                    }
                }
            }
        }
        
    }
    return [NSArray arrayWithArray:layoutAttributes];
    
}

// Items
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ACalendarCoordinate coordinate = [self.calendar.calculator coordinateForIndexPath:indexPath];
    NSInteger column = coordinate.column;
    NSInteger row = coordinate.row;
    UICollectionViewLayoutAttributes *attributes = self.itemAttributes[indexPath];
    if (!attributes) {
        attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        CGRect frame = ({
            CGFloat x, y;
            switch (self.scrollDirection) {
                case UICollectionViewScrollDirectionHorizontal: {
                    x = self.lefts[column] + indexPath.section * self.collectionView.A_width;
                    y = self.tops[row];
                    break;
                }
                case UICollectionViewScrollDirectionVertical: {
                    x = self.lefts[column];
                    if (!self.calendar.floatingMode) {
                        y = self.tops[row] + indexPath.section * self.collectionView.A_height;
                    } else {
                        y = self.sectionTops[indexPath.section] + self.headerReferenceSize.height + self.tops[row];
                    }
                    break;
                }
                default:
                    break;
            }
            CGFloat width = self.widths[column];
            CGFloat height = self.heights[row];
            CGRect frame = CGRectMake(x, y, width, height);
            frame;
        });
        attributes.frame = frame;
        self.itemAttributes[indexPath] = attributes;
    }
    return attributes;
}

// Section headers
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionViewLayoutAttributes *attributes = self.headerAttributes[indexPath];
        if (!attributes) {
            attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:indexPath];
            attributes.frame = CGRectMake(0, self.sectionTops[indexPath.section], self.collectionView.A_width, self.headerReferenceSize.height);
            self.headerAttributes[indexPath] = attributes;
        }
        return attributes;
    }
    return nil;
}

// Separators
- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    if ([elementKind isEqualToString:kACalendarSeparatorInterRows] && (self.separators & ACalendarSeparatorInterRows)) {
        UICollectionViewLayoutAttributes *attributes = self.rowSeparatorAttributes[indexPath];
        if (!attributes) {
            ACalendarCoordinate coordinate = [self.calendar.calculator coordinateForIndexPath:indexPath];
            if (coordinate.row >= [self.calendar.calculator numberOfRowsInSection:indexPath.section]-1) {
                return nil;
            }
            attributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:kACalendarSeparatorInterRows withIndexPath:indexPath];
            CGFloat x, y;
            if (!self.calendar.floatingMode) {
                switch (self.scrollDirection) {
                    case UICollectionViewScrollDirectionHorizontal: {
                        x = self.lefts[coordinate.column] + indexPath.section * self.collectionView.A_width;
                        y = self.tops[coordinate.row]+self.heights[coordinate.row];
                        break;
                    }
                    case UICollectionViewScrollDirectionVertical: {
                        x = 0;
                        y = self.tops[coordinate.row]+self.heights[coordinate.row] + indexPath.section * self.collectionView.A_height;
                        break;
                    }
                    default:
                        break;
                }
            } else {
                x = 0;
                y = self.sectionTops[indexPath.section] + self.headerReferenceSize.height + self.tops[coordinate.row] + self.heights[coordinate.row];
            }
            CGFloat width = self.collectionView.A_width;
            CGFloat height = ACalendarStandardSeparatorThickness;
            attributes.frame = CGRectMake(x, y, width, height);
            attributes.zIndex = NSIntegerMax;
            self.rowSeparatorAttributes[indexPath] = attributes;
        }
        return attributes;
    }
    return nil;
}

#pragma mark - Notifications

- (void)didReceiveNotifications:(NSNotification *)notification
{
    if ([notification.name isEqualToString:UIDeviceOrientationDidChangeNotification]) {
        [self invalidateLayout];
    }
    if ([notification.name isEqualToString:UIApplicationDidReceiveMemoryWarningNotification]) {
        [self.itemAttributes removeAllObjects];
        [self.headerAttributes removeAllObjects];
        [self.rowSeparatorAttributes removeAllObjects];
    }
}

#pragma mark - Private properties

- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection
{
    if (_scrollDirection != scrollDirection) {
        _scrollDirection = scrollDirection;
        self.collectionViewSize = CGSizeAutomatic;
    }
}

#pragma mark - Private functions

- (NSInteger)searchStartSection:(CGRect)rect :(NSInteger)left :(NSInteger)right
{
    NSInteger mid = left + (right-left)/2;
    CGFloat y = rect.origin.y;
    CGFloat minY = self.sectionTops[mid];
    CGFloat maxY = self.sectionBottoms[mid];
    if (y >= minY && y < maxY) {
        return mid;
    } else if (y < minY) {
        return [self searchStartSection:rect :left :mid];
    } else {
        return [self searchStartSection:rect :mid+1 :right];
    }
}

- (NSInteger)searchEndSection:(CGRect)rect :(NSInteger)left :(NSInteger)right
{
    NSInteger mid = left + (right-left)/2;
    CGFloat y = CGRectGetMaxY(rect);
    CGFloat minY = self.sectionTops[mid];
    CGFloat maxY = self.sectionBottoms[mid];
    if (y > minY && y <= maxY) {
        return mid;
    } else if (y <= minY) {
        return [self searchEndSection:rect :left :mid];
    } else {
        return [self searchEndSection:rect :mid+1 :right];
    }
}

@end


#undef kACalendarSeparatorInterColumns
#undef kACalendarSeparatorInterRows


