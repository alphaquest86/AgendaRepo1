#import <UIKit/UIKit.h>

@class ACalendar,ACalendarAppearance;

@interface ACalendarStickyHeader : UICollectionReusableView

@property (weak, nonatomic) ACalendar *calendar;

@property (weak, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) NSDate *month;

- (void)configureAppearance;

@end
