#import <UIKit/UIKit.h>

@class ACalendar;

@interface ACalendarScopeHandle : UIView <UIGestureRecognizerDelegate>

@property (weak, nonatomic) UIPanGestureRecognizer *panGesture;
@property (weak, nonatomic) ACalendar *calendar;

- (void)handlePan:(id)sender;

@end
