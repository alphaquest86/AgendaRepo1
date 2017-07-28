#import "ACalendar.h"
#import "ACalendarExtensions.h"
#import "ACalendarHeaderView.h"
#import "ACalendarCollectionView.h"
#import "ACalendarDynamicHeader.h"

@interface ACalendarHeaderView ()<UICollectionViewDataSource,UICollectionViewDelegate>

- (void)scrollToOffset:(CGFloat)scrollOffset animated:(BOOL)animated;
- (void)configureCell:(ACalendarHeaderCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation ACalendarHeaderView

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    _needsAdjustingViewFrame = YES;
    _needsAdjustingMonthPosition = YES;
    _scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _scrollEnabled = YES;
    
    ACalendarHeaderLayout *collectionViewLayout = [[ACalendarHeaderLayout alloc] init];
    self.collectionViewLayout = collectionViewLayout;
    
    ACalendarCollectionView *collectionView = [[ACalendarCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionViewLayout];
    collectionView.scrollEnabled = NO;
    collectionView.userInteractionEnabled = NO;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    [self addSubview:collectionView];
    [collectionView registerClass:[ACalendarHeaderCell class] forCellWithReuseIdentifier:@"cell"];
    self.collectionView = collectionView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_needsAdjustingViewFrame) {
        _needsAdjustingViewFrame = NO;
        _collectionViewLayout.itemSize = CGSizeMake(1, 1);
        [_collectionViewLayout invalidateLayout];
        _collectionView.frame = CGRectMake(0, self.A_height*0.1, self.A_width, self.A_height*0.9);
    }
    
    if (_needsAdjustingMonthPosition) {
        _needsAdjustingMonthPosition = NO;
        [self scrollToOffset:_scrollOffset animated:NO];
    }
    
}

- (void)dealloc
{
    _collectionView.dataSource = nil;
    _collectionView.delegate = nil;
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger numberOfSections = self.calendar.collectionView.numberOfSections;
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        return numberOfSections;
    }
    return numberOfSections + 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ACalendarHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.header = self;
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setNeedsLayout];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_collectionView.visibleCells makeObjectsPerformSelector:@selector(setNeedsLayout)];
}

#pragma mark - Properties

- (void)setCalendar:(ACalendar *)calendar
{
    _calendar = calendar;
    [self configureAppearance];
}

- (void)setScrollOffset:(CGFloat)scrollOffset
{
    [self setScrollOffset:scrollOffset animated:NO];
}

- (void)setScrollOffset:(CGFloat)scrollOffset animated:(BOOL)animated
{
    if (_scrollOffset != scrollOffset) {
        _scrollOffset = scrollOffset;
    }
    [self scrollToOffset:scrollOffset animated:NO];
}

- (void)scrollToOffset:(CGFloat)scrollOffset animated:(BOOL)animated
{
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        CGFloat step = self.collectionView.A_width*((self.scrollDirection==UICollectionViewScrollDirectionHorizontal)?0.5:1);
        [_collectionView setContentOffset:CGPointMake((scrollOffset+0.5)*step, 0) animated:animated];
    } else {
        CGFloat step = self.collectionView.A_height;
        [_collectionView setContentOffset:CGPointMake(0, scrollOffset*step) animated:animated];
    }
}

- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection
{
    if (_scrollDirection != scrollDirection) {
        _scrollDirection = scrollDirection;
        _collectionViewLayout.scrollDirection = scrollDirection;
        _needsAdjustingMonthPosition = YES;
        [self setNeedsLayout];
    }
}

- (void)setScrollEnabled:(BOOL)scrollEnabled
{
    if (_scrollEnabled != scrollEnabled) {
        _scrollEnabled = scrollEnabled;
        [_collectionView.visibleCells makeObjectsPerformSelector:@selector(setNeedsLayout)];
    }
}

#pragma mark - Public

- (void)reloadData
{
    [_collectionView reloadData];
}

- (void)configureCell:(ACalendarHeaderCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    ACalendarAppearance *appearance = self.calendar.appearance;
    cell.titleLabel.font = appearance.headerTitleFont;
    cell.titleLabel.textColor = appearance.headerTitleColor;
    _calendar.formatter.dateFormat = appearance.headerDateFormat;
    BOOL usesUpperCase = (appearance.caseOptions & 15) == ACalendarCaseOptionsHeaderUsesUpperCase;
    NSString *text = nil;
    switch (self.calendar.transitionCoordinator.representingScope) {
        case ACalendarScopeMonth: {
            if (_scrollDirection == UICollectionViewScrollDirectionHorizontal) {
                // 多出的两项需要制空
                if ((indexPath.item == 0 || indexPath.item == [self.collectionView numberOfItemsInSection:0] - 1)) {
                    text = nil;
                } else {
                    NSDate *date = [self.calendar.gregorian dateByAddingUnit:NSCalendarUnitMonth value:indexPath.item-1 toDate:self.calendar.minimumDate options:0];
                    text = [_calendar.formatter stringFromDate:date];
                }
            } else {
                NSDate *date = [self.calendar.gregorian dateByAddingUnit:NSCalendarUnitMonth value:indexPath.item toDate:self.calendar.minimumDate options:0];
                text = [_calendar.formatter stringFromDate:date];
            }
            break;
        }
        case ACalendarScopeWeek: {
            if ((indexPath.item == 0 || indexPath.item == [self.collectionView numberOfItemsInSection:0] - 1)) {
                text = nil;
            } else {
                NSDate *firstPage = [self.calendar.gregorian A_middleDayOfWeek:self.calendar.minimumDate];
                NSDate *date = [self.calendar.gregorian dateByAddingUnit:NSCalendarUnitWeekOfYear value:indexPath.item-1 toDate:firstPage options:0];
                text = [_calendar.formatter stringFromDate:date];
            }
            break;
        }
        default: {
            break;
        }
    }
    text = usesUpperCase ? text.uppercaseString : text;
    cell.titleLabel.text = text;
    [cell setNeedsLayout];
}

- (void)configureAppearance
{
    [self.collectionView.visibleCells enumerateObjectsUsingBlock:^(__kindof ACalendarHeaderCell * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
        [self configureCell:cell atIndexPath:[self.collectionView indexPathForCell:cell]];
    }];
}

@end


@implementation ACalendarHeaderCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.numberOfLines = 0;
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
    }
    return self;
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    _titleLabel.frame = bounds;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.frame = self.contentView.bounds;
    
    if (self.header.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        CGFloat position = [self.contentView convertPoint:CGPointMake(CGRectGetMidX(self.contentView.bounds), CGRectGetMidY(self.contentView.bounds)) toView:self.header].x;
        CGFloat center = CGRectGetMidX(self.header.bounds);
        if (self.header.scrollEnabled) {
            self.contentView.alpha = 1.0 - (1.0-self.header.calendar.appearance.headerMinimumDissolvedAlpha)*ABS(center-position)/self.A_width;
        } else {
            self.contentView.alpha = (position > self.header.A_width*0.25 && position < self.header.A_width*0.75);
        }
    } else if (self.header.scrollDirection == UICollectionViewScrollDirectionVertical) {
        CGFloat position = [self.contentView convertPoint:CGPointMake(CGRectGetMidX(self.contentView.bounds), CGRectGetMidY(self.contentView.bounds)) toView:self.header].y;
        CGFloat center = CGRectGetMidY(self.header.bounds);
        self.contentView.alpha = 1.0 - (1.0-self.header.calendar.appearance.headerMinimumDissolvedAlpha)*ABS(center-position)/self.A_height;
    }
    
}

@end


@implementation ACalendarHeaderLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.minimumInteritemSpacing = 0;
        self.minimumLineSpacing = 0;
        self.sectionInset = UIEdgeInsetsZero;
        self.itemSize = CGSizeMake(1, 1);
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    self.itemSize = CGSizeMake(
                               self.collectionView.A_width*((self.scrollDirection==UICollectionViewScrollDirectionHorizontal)?0.5:1),
                               self.collectionView.A_height
                              );
    
}

@end

@implementation ACalendarHeaderTouchDeliver

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self) {
        return _calendar.collectionView ?: hitView;
    }
    return hitView;
}

@end


