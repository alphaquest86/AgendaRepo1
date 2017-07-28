#import "AgendaInfo.h"

@implementation AgendaInfo

@synthesize uniqueId = _uniqueId;
@synthesize date = _date;
@synthesize time = _time;
@synthesize status = _status;
@synthesize title = _title;
@synthesize location = _location;

- (id)initWithUniqueId:(int)uniqueId
                  date:(NSString *)date
                  time:(NSString *)time
                status:(NSString *)status
                 title:(NSString *)title
                 location:(NSString *)location
{
    if ((self = [super init])) {
        self.uniqueId = uniqueId;
        self.date = date;
        self.time = time;
        self.status = status;
        self.title = title;
        self.location = location;
    }
    return self;
}

- (void) dealloc
{

    self.uniqueId = 0;
    self.date = nil;
    self.status = nil;
    self.title = nil;
    self.location = nil;
}

@end
