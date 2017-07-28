#import "ACalendarCollectionView.h"
#import "ACalendarExtensions.h"
#import "ACalendarConstants.h"

@interface ACalendarCollectionView ()

- (void)initialize;

@end

@implementation ACalendarCollectionView

@synthesize scrollsToTop = _scrollsToTop, contentInset = _contentInset;

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.scrollsToTop = NO;
    self.contentInset = UIEdgeInsetsZero;
    
#ifdef __IPHONE_9_0
    if ([self respondsToSelector:@selector(setSemanticContentAttribute:)]) {
        self.semanticContentAttribute = UISemanticContentAttributeForceLeftToRight;
    }
#endif
    
#ifdef __IPHONE_10_0
    SEL selector = NSSelectorFromString(@"setPrefetchingEnabled:");
    if (selector && [self respondsToSelector:selector]) {
        [self A_performSelector:selector withObjects:@NO, nil];
    }
#endif
}

- (void)setContentInset:(UIEdgeInsets)contentInset
{
    [super setContentInset:UIEdgeInsetsZero];
    if (contentInset.top) {
        self.contentOffset = CGPointMake(self.contentOffset.x, self.contentOffset.y+contentInset.top);
    }
}

- (void)setScrollsToTop:(BOOL)scrollsToTop
{
    [super setScrollsToTop:NO];
}

@end


@implementation ACalendarSeparator

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = ACalendarStandardSeparatorColor;
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    self.frame = layoutAttributes.frame;
}

@end



