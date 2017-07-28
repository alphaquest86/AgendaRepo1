#import "ACalendar.h"
#import "ACalendarCollectionView.h"
#import "ACalendarCollectionViewLayout.h"
#import "ACalendarScopeHandle.h"

typedef NS_ENUM(NSUInteger, ACalendarTransition) {
    ACalendarTransitionNone,
    ACalendarTransitionMonthToWeek,
    ACalendarTransitionWeekToMonth
};
typedef NS_ENUM(NSUInteger, ACalendarTransitionState) {
    ACalendarTransitionStateIdle,
    ACalendarTransitionStateChanging,
    ACalendarTransitionStateFinishing,
};

@interface ACalendarTransitionCoordinator : NSObject <UIGestureRecognizerDelegate>

@property (weak, nonatomic) ACalendar *calendar;
@property (weak, nonatomic) ACalendarCollectionView *collectionView;
@property (weak, nonatomic) ACalendarCollectionViewLayout *collectionViewLayout;

@property (assign, nonatomic) ACalendarTransition transition;
@property (assign, nonatomic) ACalendarTransitionState state;

@property (assign, nonatomic) CGSize cachedMonthSize;

@property (readonly, nonatomic) ACalendarScope representingScope;

- (instancetype)initWithCalendar:(ACalendar *)calendar;

- (void)performScopeTransitionFromScope:(ACalendarScope)fromScope toScope:(ACalendarScope)toScope animated:(BOOL)animated;
- (void)performBoundingRectTransitionFromMonth:(NSDate *)fromMonth toMonth:(NSDate *)toMonth duration:(CGFloat)duration;

- (void)handleScopeGesture:(id)sender;

@end


@interface ACalendarTransitionAttributes : NSObject

@property (assign, nonatomic) CGRect sourceBounds;
@property (assign, nonatomic) CGRect targetBounds;
@property (strong, nonatomic) NSDate *sourcePage;
@property (strong, nonatomic) NSDate *targetPage;
@property (assign, nonatomic) NSInteger focusedRowNumber;
@property (assign, nonatomic) NSDate *focusedDate;
@property (strong, nonatomic) NSDate *firstDayOfMonth;

@end

