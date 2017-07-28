#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ACalendar;

@interface ACalendarWeekdayView : UIView

/**
 An array of UILabel objects displaying the weekday symbols.
 */
@property (readonly, nonatomic) NSArray<UILabel *> *weekdayLabels;

- (void)configureAppearance;

@end

NS_ASSUME_NONNULL_END
