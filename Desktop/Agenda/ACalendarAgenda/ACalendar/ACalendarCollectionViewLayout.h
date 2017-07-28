#import <UIKit/UIKit.h>

@class ACalendar;

@interface ACalendarCollectionViewLayout : UICollectionViewLayout

@property (weak, nonatomic) ACalendar *calendar;

@property (assign, nonatomic) CGFloat interitemSpacing;
@property (assign, nonatomic) UIEdgeInsets sectionInsets;
@property (assign, nonatomic) UICollectionViewScrollDirection scrollDirection;
@property (assign, nonatomic) CGSize headerReferenceSize;

@end
