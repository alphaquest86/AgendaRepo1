#import <UIKit/UIKit.h>

@class ACalendar, ACalendarAppearance, ACalendarEventIndicator;

typedef NS_ENUM(NSUInteger, ACalendarMonthPosition);

@interface ACalendarCell : UICollectionViewCell

#pragma mark - Public properties

/**
 The day text label of the cell
 */
@property (weak, nonatomic) UILabel  *titleLabel;


/**
 The subtitle label of the cell
 */
@property (weak, nonatomic) UILabel  *subtitleLabel;


/**
 The shape layer of the cell
 */
@property (weak, nonatomic) CAShapeLayer *shapeLayer;

/**
 The imageView below shape layer of the cell
 */
@property (weak, nonatomic) UIImageView *imageView;


/**
 The collection of event dots of the cell
 */
@property (weak, nonatomic) ACalendarEventIndicator *eventIndicator;

/**
 A boolean value indicates that whether the cell is "placeholder". Default is NO.
 */
@property (assign, nonatomic, getter=isPlaceholder) BOOL placeholder;

#pragma mark - Private properties

@property (weak, nonatomic) ACalendar *calendar;
@property (weak, nonatomic) ACalendarAppearance *appearance;

@property (strong, nonatomic) NSString *subtitle;
@property (strong, nonatomic) UIImage  *image;
@property (assign, nonatomic) ACalendarMonthPosition monthPosition;

@property (assign, nonatomic) NSInteger numberOfEvents;
@property (assign, nonatomic) BOOL dateIsToday;
@property (assign, nonatomic) BOOL weekend;

@property (strong, nonatomic) UIColor *preferredFillDefaultColor;
@property (strong, nonatomic) UIColor *preferredFillSelectionColor;
@property (strong, nonatomic) UIColor *preferredTitleDefaultColor;
@property (strong, nonatomic) UIColor *preferredTitleSelectionColor;
@property (strong, nonatomic) UIColor *preferredSubtitleDefaultColor;
@property (strong, nonatomic) UIColor *preferredSubtitleSelectionColor;
@property (strong, nonatomic) UIColor *preferredBorderDefaultColor;
@property (strong, nonatomic) UIColor *preferredBorderSelectionColor;
@property (assign, nonatomic) CGPoint preferredTitleOffset;
@property (assign, nonatomic) CGPoint preferredSubtitleOffset;
@property (assign, nonatomic) CGPoint preferredImageOffset;
@property (assign, nonatomic) CGPoint preferredEventOffset;

@property (strong, nonatomic) NSArray<UIColor *> *preferredEventDefaultColors;
@property (strong, nonatomic) NSArray<UIColor *> *preferredEventSelectionColors;
@property (assign, nonatomic) CGFloat preferredBorderRadius;

// Add subviews to self.contentView and set up constraints
- (instancetype)initWithFrame:(CGRect)frame NS_REQUIRES_SUPER;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_REQUIRES_SUPER;

// For DIY overridden
- (void)layoutSubviews NS_REQUIRES_SUPER; // Configure frames of subviews
- (void)configureAppearance NS_REQUIRES_SUPER; // Configure appearance for cell

- (UIColor *)colorForCurrentStateInDictionary:(NSDictionary *)dictionary;
- (void)performSelecting;

@end

@interface ACalendarEventIndicator : UIView

@property (assign, nonatomic) NSInteger numberOfEvents;
@property (strong, nonatomic) id color;

@end

@interface ACalendarBlankCell : UICollectionViewCell

- (void)configureAppearance;

@end

