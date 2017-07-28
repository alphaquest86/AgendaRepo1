#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

struct ACalendarCoordinate {
    NSInteger row;
    NSInteger column;
};
typedef struct ACalendarCoordinate ACalendarCoordinate;

@interface ACalendarCalculator : NSObject

@property (weak  , nonatomic) ACalendar *calendar;

@property (readonly, nonatomic) NSInteger numberOfSections;

- (instancetype)initWithCalendar:(ACalendar *)calendar;

- (NSDate *)safeDateForDate:(NSDate *)date;

- (NSDate *)dateForIndexPath:(NSIndexPath *)indexPath;
- (NSDate *)dateForIndexPath:(NSIndexPath *)indexPath scope:(ACalendarScope)scope;
- (NSIndexPath *)indexPathForDate:(NSDate *)date;
- (NSIndexPath *)indexPathForDate:(NSDate *)date scope:(ACalendarScope)scope;
- (NSIndexPath *)indexPathForDate:(NSDate *)date atMonthPosition:(ACalendarMonthPosition)position;
- (NSIndexPath *)indexPathForDate:(NSDate *)date atMonthPosition:(ACalendarMonthPosition)position scope:(ACalendarScope)scope;

- (NSDate *)pageForSection:(NSInteger)section;
- (NSDate *)weekForSection:(NSInteger)section;
- (NSDate *)monthForSection:(NSInteger)section;
- (NSDate *)monthHeadForSection:(NSInteger)section;

- (NSInteger)numberOfHeadPlaceholdersForMonth:(NSDate *)month;
- (NSInteger)numberOfRowsInMonth:(NSDate *)month;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;

- (ACalendarMonthPosition)monthPositionForIndexPath:(NSIndexPath *)indexPath;
- (ACalendarCoordinate)coordinateForIndexPath:(NSIndexPath *)indexPath;

- (void)reloadSections;

@end
