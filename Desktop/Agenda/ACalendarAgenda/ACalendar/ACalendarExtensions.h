#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ACalendarExtensions)

@property (nonatomic) CGFloat A_width;
@property (nonatomic) CGFloat A_height;

@property (nonatomic) CGFloat A_top;
@property (nonatomic) CGFloat A_left;
@property (nonatomic) CGFloat A_bottom;
@property (nonatomic) CGFloat A_right;

@end


@interface CALayer (ACalendarExtensions)

@property (nonatomic) CGFloat A_width;
@property (nonatomic) CGFloat A_height;

@property (nonatomic) CGFloat A_top;
@property (nonatomic) CGFloat A_left;
@property (nonatomic) CGFloat A_bottom;
@property (nonatomic) CGFloat A_right;

@end


@interface NSCalendar (ACalendarExtensions)

- (nullable NSDate *)A_firstDayOfMonth:(NSDate *)month;
- (nullable NSDate *)A_lastDayOfMonth:(NSDate *)month;
- (nullable NSDate *)A_firstDayOfWeek:(NSDate *)week;
- (nullable NSDate *)A_lastDayOfWeek:(NSDate *)week;
- (nullable NSDate *)A_middleDayOfWeek:(NSDate *)week;
- (NSInteger)A_numberOfDaysInMonth:(NSDate *)month;

@end

@interface NSMapTable (ACalendarExtensions)

- (void)setObject:(nullable id)obj forKeyedSubscript:(id<NSCopying>)key;
- (id)objectForKeyedSubscript:(id<NSCopying>)key;

@end

@interface NSCache (ACalendarExtensions)

- (void)setObject:(nullable id)obj forKeyedSubscript:(id<NSCopying>)key;
- (id)objectForKeyedSubscript:(id<NSCopying>)key;

@end


@interface NSObject (ACalendarExtensions)

#define IVAR_DEF(SET,GET,TYPE) \
- (void)A_set##SET##Variable:(TYPE)value forKey:(NSString *)key; \
- (TYPE)A_##GET##VariableForKey:(NSString *)key;
IVAR_DEF(Bool, bool, BOOL)
IVAR_DEF(Float, float, CGFloat)
IVAR_DEF(Integer, integer, NSInteger)
IVAR_DEF(UnsignedInteger, unsignedInteger, NSUInteger)
#undef IVAR_DEF

- (void)A_setVariable:(id)variable forKey:(NSString *)key;
- (id)A_variableForKey:(NSString *)key;

- (nullable id)A_performSelector:(SEL)selector withObjects:(nullable id)firstObject, ... NS_REQUIRES_NIL_TERMINATION;

@end

NS_ASSUME_NONNULL_END
