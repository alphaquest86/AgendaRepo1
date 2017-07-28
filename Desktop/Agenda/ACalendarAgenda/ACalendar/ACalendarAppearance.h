#import "ACalendarConstants.h"

@class ACalendar;

typedef NS_ENUM(NSInteger, ACalendarCellState) {
    ACalendarCellStateNormal      = 0,
    ACalendarCellStateSelected    = 1,
    ACalendarCellStatePlaceholder = 1 << 1,
    ACalendarCellStateDisabled    = 1 << 2,
    ACalendarCellStateToday       = 1 << 3,
    ACalendarCellStateWeekend     = 1 << 4,
    ACalendarCellStateTodaySelected = ACalendarCellStateToday|ACalendarCellStateSelected
};

typedef NS_ENUM(NSUInteger, ACalendarSeparators) {
    ACalendarSeparatorNone          = 0,
    ACalendarSeparatorInterRows     = 1
};

typedef NS_OPTIONS(NSUInteger, ACalendarCaseOptions) {
    ACalendarCaseOptionsHeaderUsesDefaultCase      = 0,
    ACalendarCaseOptionsHeaderUsesUpperCase        = 1,
    
    ACalendarCaseOptionsWeekdayUsesDefaultCase     = 0 << 4,
    ACalendarCaseOptionsWeekdayUsesUpperCase       = 1 << 4,
    ACalendarCaseOptionsWeekdayUsesSingleUpperCase = 2 << 4,
};

/**
 * ACalendarAppearance determines the fonts and colors of components in the calendar.
 *
 * @see ACalendarDelegateAppearance
 */
@interface ACalendarAppearance : NSObject

/**
 * The font of the day text.
 */
@property (strong, nonatomic) UIFont   *titleFont;

/**
 * The font of the subtitle text.
 */
@property (strong, nonatomic) UIFont   *subtitleFont;

/**
 * The font of the weekday text.
 */
@property (strong, nonatomic) UIFont   *weekdayFont;

/**
 * The font of the month text.
 */
@property (strong, nonatomic) UIFont   *headerTitleFont;

/**
 * The offset of the day text from default position.
 */
@property (assign, nonatomic) CGPoint  titleOffset;

/**
 * The offset of the day text from default position.
 */
@property (assign, nonatomic) CGPoint  subtitleOffset;

/**
 * The offset of the event dots from default position.
 */
@property (assign, nonatomic) CGPoint eventOffset;

/**
 * The offset of the image from default position.
 */
@property (assign, nonatomic) CGPoint imageOffset;

/**
 * The color of event dots.
 */
@property (strong, nonatomic) UIColor  *eventDefaultColor;

/**
 * The color of event dots.
 */
@property (strong, nonatomic) UIColor  *eventSelectionColor;

/**
 * The color of weekday text.
 */
@property (strong, nonatomic) UIColor  *weekdayTextColor;

/**
 * The color of month header text.
 */
@property (strong, nonatomic) UIColor  *headerTitleColor;

/**
 * The date format of the month header.
 */
@property (strong, nonatomic) NSString *headerDateFormat;

/**
 * The alpha value of month label staying on the fringes.
 */
@property (assign, nonatomic) CGFloat  headerMinimumDissolvedAlpha;

/**
 * The day text color for unselected state.
 */
@property (strong, nonatomic) UIColor  *titleDefaultColor;

/**
 * The day text color for selected state.
 */
@property (strong, nonatomic) UIColor  *titleSelectionColor;

/**
 * The day text color for today in the calendar.
 */
@property (strong, nonatomic) UIColor  *titleTodayColor;

/**
 * The day text color for days out of current month.
 */
@property (strong, nonatomic) UIColor  *titlePlaceholderColor;

/**
 * The day text color for weekend.
 */
@property (strong, nonatomic) UIColor  *titleWeekendColor;

/**
 * The subtitle text color for unselected state.
 */
@property (strong, nonatomic) UIColor  *subtitleDefaultColor;

/**
 * The subtitle text color for selected state.
 */
@property (strong, nonatomic) UIColor  *subtitleSelectionColor;

/**
 * The subtitle text color for today in the calendar.
 */
@property (strong, nonatomic) UIColor  *subtitleTodayColor;

/**
 * The subtitle text color for days out of current month.
 */
@property (strong, nonatomic) UIColor  *subtitlePlaceholderColor;

/**
 * The subtitle text color for weekend.
 */
@property (strong, nonatomic) UIColor  *subtitleWeekendColor;

/**
 * The fill color of the shape for selected state.
 */
@property (strong, nonatomic) UIColor  *selectionColor;

/**
 * The fill color of the shape for today.
 */
@property (strong, nonatomic) UIColor  *todayColor;

/**
 * The fill color of the shape for today and selected state.
 */
@property (strong, nonatomic) UIColor  *todaySelectionColor;

/**
 * The border color of the shape for unselected state.
 */
@property (strong, nonatomic) UIColor  *borderDefaultColor;

/**
 * The border color of the shape for selected state.
 */
@property (strong, nonatomic) UIColor  *borderSelectionColor;

/**
 * The border radius, while 1 means a circle, 0 means a rectangle, and the middle value will give it a corner radius.
 */
@property (assign, nonatomic) CGFloat borderRadius;

/**
 * The case options manage the case of month label and weekday symbols.
 *
 * @see ACalendarCaseOptions
 */
@property (assign, nonatomic) ACalendarCaseOptions caseOptions;

/**
 * The line integrations for calendar.
 *
 */
@property (assign, nonatomic) ACalendarSeparators separators;

#if TARGET_INTERFACE_BUILDER

// For preview only
@property (assign, nonatomic) BOOL      fakeSubtitles;
@property (assign, nonatomic) BOOL      fakeEventDots;
@property (assign, nonatomic) NSInteger fakedSelectedDay;

#endif

@end

/**
 * These functions and attributes are deprecated.
 */
@interface ACalendarAppearance (Deprecated)

@property (assign, nonatomic) BOOL useVeryShortWeekdaySymbols ACalendarDeprecated('caseOptions');
@property (assign, nonatomic) CGFloat titleVerticalOffset ACalendarDeprecated('titleOffset');
@property (assign, nonatomic) CGFloat subtitleVerticalOffset ACalendarDeprecated('subtitleOffset');
@property (strong, nonatomic) UIColor *eventColor ACalendarDeprecated('eventDefaultColor');
@property (assign, nonatomic) ACalendarCellShape cellShape ACalendarDeprecated('borderRadius');
@property (assign, nonatomic) BOOL adjustsFontSizeToFitContentSize DEPRECATED_MSG_ATTRIBUTE("The attribute \'adjustsFontSizeToFitContentSize\' is not neccesary anymore.");
- (void)invalidateAppearance ACalendarDeprecated('ACalendar setNeedsConfigureAppearance');

@end



