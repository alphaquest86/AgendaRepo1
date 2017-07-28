#import "ACalendarDelegationFactory.h"

#define ACalendarSelectorEntry(SEL1,SEL2) NSStringFromSelector(@selector(SEL1)):NSStringFromSelector(@selector(SEL2))

@implementation ACalendarDelegationFactory

+ (ACalendarDelegationProxy *)dataSourceProxy
{
    ACalendarDelegationProxy *delegation = [[ACalendarDelegationProxy alloc] init];
    delegation.protocol = @protocol(ACalendarDataSource);
    delegation.deprecations = @{ACalendarSelectorEntry(calendar:numberOfEventsForDate:, calendar:hasEventForDate:)};
    return delegation;
}

+ (ACalendarDelegationProxy *)delegateProxy
{
    ACalendarDelegationProxy *delegation = [[ACalendarDelegationProxy alloc] init];
    delegation.protocol = @protocol(ACalendarDelegateAppearance);
    delegation.deprecations = @{
                                ACalendarSelectorEntry(calendarCurrentPageDidChange:, calendarCurrentMonthDidChange:),
                                ACalendarSelectorEntry(calendar:shouldSelectDate:atMonthPosition:, calendar:shouldSelectDate:),
                                ACalendarSelectorEntry(calendar:didSelectDate:atMonthPosition:, calendar:didSelectDate:),
                                ACalendarSelectorEntry(calendar:shouldDeselectDate:atMonthPosition:, calendar:shouldDeselectDate:),
                                ACalendarSelectorEntry(calendar:didDeselectDate:atMonthPosition:, calendar:didDeselectDate:)
                               };
    return delegation;
}

@end

#undef ACalendarSelectorEntry

