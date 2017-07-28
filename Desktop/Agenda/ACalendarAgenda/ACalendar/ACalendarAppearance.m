#import "ACalendarAppearance.h"
#import "ACalendarDynamicHeader.h"
#import "ACalendarExtensions.h"

@interface ACalendarAppearance ()

@property (weak  , nonatomic) ACalendar *calendar;

@property (strong, nonatomic) NSMutableDictionary *backgroundColors;
@property (strong, nonatomic) NSMutableDictionary *titleColors;
@property (strong, nonatomic) NSMutableDictionary *subtitleColors;
@property (strong, nonatomic) NSMutableDictionary *borderColors;

@end

@implementation ACalendarAppearance

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _titleFont = [UIFont systemFontOfSize:ACalendarStandardTitleTextSize];
        _subtitleFont = [UIFont systemFontOfSize:ACalendarStandardSubtitleTextSize];
        _weekdayFont = [UIFont systemFontOfSize:ACalendarStandardWeekdayTextSize];
        _headerTitleFont = [UIFont systemFontOfSize:ACalendarStandardHeaderTextSize];
        
        _headerTitleColor = ACalendarStandardTitleTextColor;
        _headerDateFormat = @"MMMM yyyy";
        _headerMinimumDissolvedAlpha = 0.2;
        _weekdayTextColor = ACalendarStandardTitleTextColor;
        _caseOptions = ACalendarCaseOptionsHeaderUsesDefaultCase|ACalendarCaseOptionsWeekdayUsesDefaultCase;
        
        _backgroundColors = [NSMutableDictionary dictionaryWithCapacity:5];
        _backgroundColors[@(ACalendarCellStateNormal)]      = [UIColor clearColor];
        _backgroundColors[@(ACalendarCellStateSelected)]    = ACalendarStandardSelectionColor;
        _backgroundColors[@(ACalendarCellStateDisabled)]    = [UIColor clearColor];
        _backgroundColors[@(ACalendarCellStatePlaceholder)] = [UIColor clearColor];
        _backgroundColors[@(ACalendarCellStateToday)]       = ACalendarStandardTodayColor;
        
        _titleColors = [NSMutableDictionary dictionaryWithCapacity:5];
        _titleColors[@(ACalendarCellStateNormal)]      = [UIColor blackColor];
        _titleColors[@(ACalendarCellStateSelected)]    = [UIColor whiteColor];
        _titleColors[@(ACalendarCellStateDisabled)]    = [UIColor grayColor];
        _titleColors[@(ACalendarCellStatePlaceholder)] = [UIColor lightGrayColor];
        _titleColors[@(ACalendarCellStateToday)]       = [UIColor whiteColor];
        
        _subtitleColors = [NSMutableDictionary dictionaryWithCapacity:5];
        _subtitleColors[@(ACalendarCellStateNormal)]      = [UIColor darkGrayColor];
        _subtitleColors[@(ACalendarCellStateSelected)]    = [UIColor whiteColor];
        _subtitleColors[@(ACalendarCellStateDisabled)]    = [UIColor lightGrayColor];
        _subtitleColors[@(ACalendarCellStatePlaceholder)] = [UIColor lightGrayColor];
        _subtitleColors[@(ACalendarCellStateToday)]       = [UIColor whiteColor];
        
        _borderColors[@(ACalendarCellStateSelected)] = [UIColor clearColor];
        _borderColors[@(ACalendarCellStateNormal)] = [UIColor clearColor];
        
        _borderRadius = 1.0;
        _eventDefaultColor = ACalendarStandardEventDotColor;
        _eventSelectionColor = ACalendarStandardEventDotColor;
        
        _borderColors = [NSMutableDictionary dictionaryWithCapacity:2];
        
#if TARGET_INTERFACE_BUILDER
        _fakeEventDots = YES;
#endif
        
    }
    return self;
}

- (void)setTitleFont:(UIFont *)titleFont
{
    if (![_titleFont isEqual:titleFont]) {
        _titleFont = titleFont;
        [self.calendar configureAppearance];
    }
}

- (void)setSubtitleFont:(UIFont *)subtitleFont
{
    if (![_subtitleFont isEqual:subtitleFont]) {
        _subtitleFont = subtitleFont;
        [self.calendar configureAppearance];
    }
}

- (void)setWeekdayFont:(UIFont *)weekdayFont
{
    if (![_weekdayFont isEqual:weekdayFont]) {
        _weekdayFont = weekdayFont;
        [self.calendar configureAppearance];
    }
}

- (void)setHeaderTitleFont:(UIFont *)headerTitleFont
{
    if (![_headerTitleFont isEqual:headerTitleFont]) {
        _headerTitleFont = headerTitleFont;
        [self.calendar configureAppearance];
    }
}

- (void)setTitleOffset:(CGPoint)titleOffset
{
    if (!CGPointEqualToPoint(_titleOffset, titleOffset)) {
        _titleOffset = titleOffset;
        [_calendar.visibleCells makeObjectsPerformSelector:@selector(setNeedsLayout)];
    }
}

- (void)setSubtitleOffset:(CGPoint)subtitleOffset
{
    if (!CGPointEqualToPoint(_subtitleOffset, subtitleOffset)) {
        _subtitleOffset = subtitleOffset;
        [_calendar.visibleCells makeObjectsPerformSelector:@selector(setNeedsLayout)];
    }
}

- (void)setImageOffset:(CGPoint)imageOffset
{
    if (!CGPointEqualToPoint(_imageOffset, imageOffset)) {
        _imageOffset = imageOffset;
        [_calendar.visibleCells makeObjectsPerformSelector:@selector(setNeedsLayout)];
    }
}

- (void)setEventOffset:(CGPoint)eventOffset
{
    if (!CGPointEqualToPoint(_eventOffset, eventOffset)) {
        _eventOffset = eventOffset;
        [_calendar.visibleCells makeObjectsPerformSelector:@selector(setNeedsLayout)];
    }
}

- (void)setTitleDefaultColor:(UIColor *)color
{
    if (color) {
        _titleColors[@(ACalendarCellStateNormal)] = color;
    } else {
        [_titleColors removeObjectForKey:@(ACalendarCellStateNormal)];
    }
    [self.calendar configureAppearance];
}

- (UIColor *)titleDefaultColor
{
    return _titleColors[@(ACalendarCellStateNormal)];
}

- (void)setTitleSelectionColor:(UIColor *)color
{
    if (color) {
        _titleColors[@(ACalendarCellStateSelected)] = color;
    } else {
        [_titleColors removeObjectForKey:@(ACalendarCellStateSelected)];
    }
    [self.calendar configureAppearance];
}

- (UIColor *)titleSelectionColor
{
    return _titleColors[@(ACalendarCellStateSelected)];
}

- (void)setTitleTodayColor:(UIColor *)color
{
    if (color) {
        _titleColors[@(ACalendarCellStateToday)] = color;
    } else {
        [_titleColors removeObjectForKey:@(ACalendarCellStateToday)];
    }
    [self.calendar configureAppearance];
}

- (UIColor *)titleTodayColor
{
    return _titleColors[@(ACalendarCellStateToday)];
}

- (void)setTitlePlaceholderColor:(UIColor *)color
{
    if (color) {
        _titleColors[@(ACalendarCellStatePlaceholder)] = color;
    } else {
        [_titleColors removeObjectForKey:@(ACalendarCellStatePlaceholder)];
    }
    [self.calendar configureAppearance];
}

- (UIColor *)titlePlaceholderColor
{
    return _titleColors[@(ACalendarCellStatePlaceholder)];
}

- (void)setTitleWeekendColor:(UIColor *)color
{
    if (color) {
        _titleColors[@(ACalendarCellStateWeekend)] = color;
    } else {
        [_titleColors removeObjectForKey:@(ACalendarCellStateWeekend)];
    }
    [self.calendar configureAppearance];
}

- (UIColor *)titleWeekendColor
{
    return _titleColors[@(ACalendarCellStateWeekend)];
}

- (void)setSubtitleDefaultColor:(UIColor *)color
{
    if (color) {
        _subtitleColors[@(ACalendarCellStateNormal)] = color;
    } else {
        [_subtitleColors removeObjectForKey:@(ACalendarCellStateNormal)];
    }
    [self.calendar configureAppearance];
}

-(UIColor *)subtitleDefaultColor
{
    return _subtitleColors[@(ACalendarCellStateNormal)];
}

- (void)setSubtitleSelectionColor:(UIColor *)color
{
    if (color) {
        _subtitleColors[@(ACalendarCellStateSelected)] = color;
    } else {
        [_subtitleColors removeObjectForKey:@(ACalendarCellStateSelected)];
    }
    [self.calendar configureAppearance];
}

- (UIColor *)subtitleSelectionColor
{
    return _subtitleColors[@(ACalendarCellStateSelected)];
}

- (void)setSubtitleTodayColor:(UIColor *)color
{
    if (color) {
        _subtitleColors[@(ACalendarCellStateToday)] = color;
    } else {
        [_subtitleColors removeObjectForKey:@(ACalendarCellStateToday)];
    }
    [self.calendar configureAppearance];
}

- (UIColor *)subtitleTodayColor
{
    return _subtitleColors[@(ACalendarCellStateToday)];
}

- (void)setSubtitlePlaceholderColor:(UIColor *)color
{
    if (color) {
        _subtitleColors[@(ACalendarCellStatePlaceholder)] = color;
    } else {
        [_subtitleColors removeObjectForKey:@(ACalendarCellStatePlaceholder)];
    }
    [self.calendar configureAppearance];
}

- (UIColor *)subtitlePlaceholderColor
{
    return _subtitleColors[@(ACalendarCellStatePlaceholder)];
}

- (void)setSubtitleWeekendColor:(UIColor *)color
{
    if (color) {
        _subtitleColors[@(ACalendarCellStateWeekend)] = color;
    } else {
        [_subtitleColors removeObjectForKey:@(ACalendarCellStateWeekend)];
    }
    [self.calendar configureAppearance];
}

- (UIColor *)subtitleWeekendColor
{
    return _subtitleColors[@(ACalendarCellStateWeekend)];
}

- (void)setSelectionColor:(UIColor *)color
{
    if (color) {
        _backgroundColors[@(ACalendarCellStateSelected)] = color;
    } else {
        [_backgroundColors removeObjectForKey:@(ACalendarCellStateSelected)];
    }
    [self.calendar configureAppearance];
}

- (UIColor *)selectionColor
{
    return _backgroundColors[@(ACalendarCellStateSelected)];
}

- (void)setTodayColor:(UIColor *)todayColor
{
    if (todayColor) {
        _backgroundColors[@(ACalendarCellStateToday)] = todayColor;
    } else {
        [_backgroundColors removeObjectForKey:@(ACalendarCellStateToday)];
    }
    [self.calendar configureAppearance];
}

- (UIColor *)todayColor
{
    return _backgroundColors[@(ACalendarCellStateToday)];
}

- (void)setTodaySelectionColor:(UIColor *)todaySelectionColor
{
    if (todaySelectionColor) {
        _backgroundColors[@(ACalendarCellStateToday|ACalendarCellStateSelected)] = todaySelectionColor;
    } else {
        [_backgroundColors removeObjectForKey:@(ACalendarCellStateToday|ACalendarCellStateSelected)];
    }
    [self.calendar configureAppearance];
}

- (UIColor *)todaySelectionColor
{
    return _backgroundColors[@(ACalendarCellStateToday|ACalendarCellStateSelected)];
}

- (void)setEventDefaultColor:(UIColor *)eventDefaultColor
{
    if (![_eventDefaultColor isEqual:eventDefaultColor]) {
        _eventDefaultColor = eventDefaultColor;
        [self.calendar configureAppearance];
    }
}

- (void)setBorderDefaultColor:(UIColor *)color
{
    if (color) {
        _borderColors[@(ACalendarCellStateNormal)] = color;
    } else {
        [_borderColors removeObjectForKey:@(ACalendarCellStateNormal)];
    }
    [self.calendar configureAppearance];
}

- (UIColor *)borderDefaultColor
{
    return _borderColors[@(ACalendarCellStateNormal)];
}

- (void)setBorderSelectionColor:(UIColor *)color
{
    if (color) {
        _borderColors[@(ACalendarCellStateSelected)] = color;
    } else {
        [_borderColors removeObjectForKey:@(ACalendarCellStateSelected)];
    }
    [self.calendar configureAppearance];
}

- (UIColor *)borderSelectionColor
{
    return _borderColors[@(ACalendarCellStateSelected)];
}

- (void)setBorderRadius:(CGFloat)borderRadius
{
    borderRadius = MAX(0.0, borderRadius);
    borderRadius = MIN(1.0, borderRadius);
    if (_borderRadius != borderRadius) {
        _borderRadius = borderRadius;
        [self.calendar configureAppearance];
    }
}

- (void)setWeekdayTextColor:(UIColor *)weekdayTextColor
{
    if (![_weekdayTextColor isEqual:weekdayTextColor]) {
        _weekdayTextColor = weekdayTextColor;
        [self.calendar configureAppearance];
    }
}

- (void)setHeaderTitleColor:(UIColor *)color
{
    if (![_headerTitleColor isEqual:color]) {
        _headerTitleColor = color;
        [self.calendar configureAppearance];
    }
}

- (void)setHeaderMinimumDissolvedAlpha:(CGFloat)headerMinimumDissolvedAlpha
{
    if (_headerMinimumDissolvedAlpha != headerMinimumDissolvedAlpha) {
        _headerMinimumDissolvedAlpha = headerMinimumDissolvedAlpha;
        [self.calendar configureAppearance];
    }
}

- (void)setHeaderDateFormat:(NSString *)headerDateFormat
{
    if (![_headerDateFormat isEqual:headerDateFormat]) {
        _headerDateFormat = headerDateFormat;
        [self.calendar configureAppearance];
    }
}

- (void)setCaseOptions:(ACalendarCaseOptions)caseOptions
{
    if (_caseOptions != caseOptions) {
        _caseOptions = caseOptions;
        [self.calendar configureAppearance];
    }
}

- (void)setSeparators:(ACalendarSeparators)separators
{
    if (_separators != separators) {
        _separators = separators;
        [_calendar.collectionView.collectionViewLayout invalidateLayout];
    }
}

@end


@implementation ACalendarAppearance (Deprecated)

- (void)setUseVeryShortWeekdaySymbols:(BOOL)useVeryShortWeekdaySymbols
{
    _caseOptions &= 15;
    self.caseOptions |= (useVeryShortWeekdaySymbols*ACalendarCaseOptionsWeekdayUsesSingleUpperCase);
}

- (BOOL)useVeryShortWeekdaySymbols
{
    return (_caseOptions & (15<<4) ) == ACalendarCaseOptionsWeekdayUsesSingleUpperCase;
}

- (void)setTitleVerticalOffset:(CGFloat)titleVerticalOffset
{
    self.titleOffset = CGPointMake(0, titleVerticalOffset);
}

- (CGFloat)titleVerticalOffset
{
    return self.titleOffset.y;
}

- (void)setSubtitleVerticalOffset:(CGFloat)subtitleVerticalOffset
{
    self.subtitleOffset = CGPointMake(0, subtitleVerticalOffset);
}

- (CGFloat)subtitleVerticalOffset
{
    return self.subtitleOffset.y;
}

- (void)setEventColor:(UIColor *)eventColor
{
    self.eventDefaultColor = eventColor;
}

- (UIColor *)eventColor
{
    return self.eventDefaultColor;
}

- (void)setCellShape:(ACalendarCellShape)cellShape
{
    self.borderRadius = 1-cellShape;
}

- (ACalendarCellShape)cellShape
{
    return self.borderRadius==1.0?ACalendarCellShapeCircle:ACalendarCellShapeRectangle;
}

- (void)setTitleTextSize:(CGFloat)titleTextSize
{
    self.titleFont = [UIFont fontWithName:self.titleFont.fontName size:titleTextSize];
}

- (void)setSubtitleTextSize:(CGFloat)subtitleTextSize
{
    self.subtitleFont = [UIFont fontWithName:self.subtitleFont.fontName size:subtitleTextSize];
}

- (void)setWeekdayTextSize:(CGFloat)weekdayTextSize
{
    self.weekdayFont = [UIFont fontWithName:self.weekdayFont.fontName size:weekdayTextSize];
}

- (void)setHeaderTitleTextSize:(CGFloat)headerTitleTextSize
{
    self.headerTitleFont = [UIFont fontWithName:self.headerTitleFont.fontName size:headerTitleTextSize];
}

- (void)invalidateAppearance
{
    [self.calendar configureAppearance];
}

- (void)setAdjustsFontSizeToFitContentSize:(BOOL)adjustsFontSizeToFitContentSize {}
- (BOOL)adjustsFontSizeToFitContentSize { return YES; }

@end


