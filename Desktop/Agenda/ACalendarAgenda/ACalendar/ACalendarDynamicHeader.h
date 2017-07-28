#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "ACalendar.h"
#import "ACalendarCell.h"
#import "ACalendarHeaderView.h"
#import "ACalendarStickyHeader.h"
#import "ACalendarCollectionView.h"
#import "ACalendarCollectionViewLayout.h"
#import "ACalendarScopeHandle.h"
#import "ACalendarCalculator.h"
#import "ACalendarTransitionCoordinator.h"
#import "ACalendarDelegationProxy.h"

@interface ACalendar (Dynamic)

@property (readonly, nonatomic) ACalendarCollectionView *collectionView;
@property (readonly, nonatomic) ACalendarScopeHandle *scopeHandle;
@property (readonly, nonatomic) ACalendarCollectionViewLayout *collectionViewLayout;
@property (readonly, nonatomic) ACalendarTransitionCoordinator *transitionCoordinator;
@property (readonly, nonatomic) ACalendarCalculator *calculator;
@property (readonly, nonatomic) BOOL floatingMode;
@property (readonly, nonatomic) NSArray *visibleStickyHeaders;
@property (readonly, nonatomic) CGFloat preferredHeaderHeight;
@property (readonly, nonatomic) CGFloat preferredWeekdayHeight;
@property (readonly, nonatomic) UIView *bottomBorder;

@property (readonly, nonatomic) NSCalendar *gregorian;
@property (readonly, nonatomic) NSDateComponents *components;
@property (readonly, nonatomic) NSDateFormatter *formatter;

@property (readonly, nonatomic) UIView *contentView;
@property (readonly, nonatomic) UIView *daysContainer;

@property (assign, nonatomic) BOOL needsAdjustingViewFrame;

- (void)invalidateHeaders;
- (void)adjustMonthPosition;
- (void)configureAppearance;

- (BOOL)isPageInRange:(NSDate *)page;
- (BOOL)isDateInRange:(NSDate *)date;

- (CGSize)sizeThatFits:(CGSize)size scope:(ACalendarScope)scope;

@end

@interface ACalendarAppearance (Dynamic)

@property (readwrite, nonatomic) ACalendar *calendar;

@property (readonly, nonatomic) NSDictionary *backgroundColors;
@property (readonly, nonatomic) NSDictionary *titleColors;
@property (readonly, nonatomic) NSDictionary *subtitleColors;
@property (readonly, nonatomic) NSDictionary *borderColors;

@end

@interface ACalendarWeekdayView (Dynamic)

@property (readwrite, nonatomic) ACalendar *calendar;

@end

@interface ACalendarCollectionViewLayout (Dynamic)

@property (readonly, nonatomic) CGSize estimatedItemSize;

@end

@interface ACalendarDelegationProxy()<ACalendarDataSource,ACalendarDelegate,ACalendarDelegateAppearance>
@end


