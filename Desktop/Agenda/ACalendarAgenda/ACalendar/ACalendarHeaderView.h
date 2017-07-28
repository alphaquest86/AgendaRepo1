#import <UIKit/UIKit.h>


@class ACalendar, ACalendarAppearance, ACalendarHeaderLayout, ACalendarCollectionView;

@interface ACalendarHeaderView : UIView

@property (weak, nonatomic) ACalendarCollectionView *collectionView;
@property (weak, nonatomic) ACalendarHeaderLayout *collectionViewLayout;
@property (weak, nonatomic) ACalendar *calendar;

@property (assign, nonatomic) CGFloat scrollOffset;
@property (assign, nonatomic) UICollectionViewScrollDirection scrollDirection;
@property (assign, nonatomic) BOOL scrollEnabled;
@property (assign, nonatomic) BOOL needsAdjustingViewFrame;
@property (assign, nonatomic) BOOL needsAdjustingMonthPosition;

- (void)setScrollOffset:(CGFloat)scrollOffset animated:(BOOL)animated;
- (void)reloadData;
- (void)configureAppearance;

@end


@interface ACalendarHeaderCell : UICollectionViewCell

@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) ACalendarHeaderView *header;

@end

@interface ACalendarHeaderLayout : UICollectionViewFlowLayout

@end

@interface ACalendarHeaderTouchDeliver : UIView

@property (weak, nonatomic) ACalendar *calendar;
@property (weak, nonatomic) ACalendarHeaderView *header;

@end
