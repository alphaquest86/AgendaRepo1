#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#pragma mark - Constants

CG_EXTERN CGFloat const ACalendarStandardHeaderHeight;
CG_EXTERN CGFloat const ACalendarStandardWeekdayHeight;
CG_EXTERN CGFloat const ACalendarStandardMonthlyPageHeight;
CG_EXTERN CGFloat const ACalendarStandardWeeklyPageHeight;
CG_EXTERN CGFloat const ACalendarStandardCellDiameter;
CG_EXTERN CGFloat const ACalendarStandardSeparatorThickness;
CG_EXTERN CGFloat const ACalendarAutomaticDimension;
CG_EXTERN CGFloat const ACalendarDefaultBounceAnimationDuration;
CG_EXTERN CGFloat const ACalendarStandardRowHeight;
CG_EXTERN CGFloat const ACalendarStandardTitleTextSize;
CG_EXTERN CGFloat const ACalendarStandardSubtitleTextSize;
CG_EXTERN CGFloat const ACalendarStandardWeekdayTextSize;
CG_EXTERN CGFloat const ACalendarStandardHeaderTextSize;
CG_EXTERN CGFloat const ACalendarMaximumEventDotDiameter;
CG_EXTERN CGFloat const ACalendarStandardScopeHandleHeight;

UIKIT_EXTERN NSInteger const ACalendarDefaultHourComponent;

UIKIT_EXTERN NSString * const ACalendarDefaultCellReuseIdentifier;
UIKIT_EXTERN NSString * const ACalendarBlankCellReuseIdentifier;
UIKIT_EXTERN NSString * const ACalendarInvalidArgumentsExceptionName;

CG_EXTERN CGPoint const CGPointInfinity;
CG_EXTERN CGSize const CGSizeAutomatic;

#if TARGET_INTERFACE_BUILDER
#define ACalendarDeviceIsIPad NO
#else
#define ACalendarDeviceIsIPad [[UIDevice currentDevice].model hasPrefix:@"iPad"]
#endif

#define ACalendarStandardSelectionColor   AColorRGBA(31,119,219,1.0)
#define ACalendarStandardTodayColor       AColorRGBA(198,51,42 ,1.0)
#define ACalendarStandardTitleTextColor   AColorRGBA(14,69,221 ,1.0)
#define ACalendarStandardEventDotColor    AColorRGBA(31,119,219,0.75)

#define ACalendarStandardLineColor        [[UIColor lightGrayColor] colorWithAlphaComponent:0.30]
#define ACalendarStandardSeparatorColor   [[UIColor lightGrayColor] colorWithAlphaComponent:0.60]
#define ACalendarStandardScopeHandleColor [[UIColor lightGrayColor] colorWithAlphaComponent:0.50]

#define AColorRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define ACalendarInAppExtension [[[NSBundle mainBundle] bundlePath] hasSuffix:@".appex"]

#if CGFLOAT_IS_DOUBLE
#define ACalendarFloor(c) floor(c)
#define ACalendarRound(c) round(c)
#define ACalendarCeil(c) ceil(c)
#define ACalendarMod(c1,c2) fmod(c1,c2)
#else
#define ACalendarFloor(c) floorf(c)
#define ACalendarRound(c) roundf(c)
#define ACalendarCeil(c) ceilf(c)
#define ACalendarMod(c1,c2) fmodf(c1,c2)
#endif

#define ACalendarHalfRound(c) (ACalendarRound(c*2)*0.5)
#define ACalendarHalfFloor(c) (ACalendarFloor(c*2)*0.5)
#define ACalendarHalfCeil(c) (ACalendarCeil(c*2)*0.5)

#define ACalendarUseWeakSelf __weak __typeof__(self) ACalendarWeakSelf = self;
#define ACalendarUseStrongSelf __strong __typeof__(self) self = ACalendarWeakSelf;


#pragma mark - Deprecated

#define ACalendarDeprecated(instead) DEPRECATED_MSG_ATTRIBUTE(" Use " # instead " instead")

ACalendarDeprecated('borderRadius')
typedef NS_ENUM(NSUInteger, ACalendarCellShape) {
    ACalendarCellShapeCircle    = 0,
    ACalendarCellShapeRectangle = 1
};

typedef NS_ENUM(NSUInteger, ACalendarUnit) {
    ACalendarUnitMonth = NSCalendarUnitMonth,
    ACalendarUnitWeekOfYear = NSCalendarUnitWeekOfYear,
    ACalendarUnitDay = NSCalendarUnitDay
};

static inline void ACalendarSliceCake(CGFloat cake, NSInteger count, CGFloat *pieces) {
    CGFloat total = cake;
    for (int i = 0; i < count; i++) {
        NSInteger remains = count - i;
        CGFloat piece = ACalendarRound(total/remains*2)*0.5;
        total -= piece;
        pieces[i] = piece;
    }
}



