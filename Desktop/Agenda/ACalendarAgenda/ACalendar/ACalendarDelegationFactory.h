#import <Foundation/Foundation.h>
#import "ACalendarDelegationProxy.h"

@interface ACalendarDelegationFactory : NSObject

+ (ACalendarDelegationProxy *)dataSourceProxy;
+ (ACalendarDelegationProxy *)delegateProxy;

@end
