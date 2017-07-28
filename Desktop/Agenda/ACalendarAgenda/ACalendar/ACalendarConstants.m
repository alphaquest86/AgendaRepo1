#import "ACalendarConstants.h"

CGFloat const ACalendarStandardHeaderHeight = 40;
CGFloat const ACalendarStandardWeekdayHeight = 25;
CGFloat const ACalendarStandardMonthlyPageHeight = 300.0;
CGFloat const ACalendarStandardWeeklyPageHeight = 108+1/3.0;
CGFloat const ACalendarStandardCellDiameter = 100/3.0;
CGFloat const ACalendarStandardSeparatorThickness = 0.5;
CGFloat const ACalendarAutomaticDimension = -1;
CGFloat const ACalendarDefaultBounceAnimationDuration = 0.15;
CGFloat const ACalendarStandardRowHeight = 38;
CGFloat const ACalendarStandardTitleTextSize = 13.5;
CGFloat const ACalendarStandardSubtitleTextSize = 10;
CGFloat const ACalendarStandardWeekdayTextSize = 14;
CGFloat const ACalendarStandardHeaderTextSize = 16.5;
CGFloat const ACalendarMaximumEventDotDiameter = 4.8;
CGFloat const ACalendarStandardScopeHandleHeight = 26;

NSInteger const ACalendarDefaultHourComponent = 0;

NSString * const ACalendarDefaultCellReuseIdentifier = @"_ACalendarDefaultCellReuseIdentifier";
NSString * const ACalendarBlankCellReuseIdentifier = @"_ACalendarBlankCellReuseIdentifier";
NSString * const ACalendarInvalidArgumentsExceptionName = @"Invalid argument exception";

CGPoint const CGPointInfinity = {
    .x =  CGFLOAT_MAX,
    .y =  CGFLOAT_MAX
};

CGSize const CGSizeAutomatic = {
    .width =  ACalendarAutomaticDimension,
    .height =  ACalendarAutomaticDimension
};



