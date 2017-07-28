#import <Foundation/Foundation.h>

@interface AgendaInfo : NSObject
{
    int _uniqueId;
    NSString *_date;
    NSString *_time;
    NSString *_status;
    NSString *_title;
    NSString *_location;
}

@property (nonatomic, assign) int uniqueId;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *location;


- (id)initWithUniqueId:(int)uniqueId
                  date:(NSString *)date
                  time:(NSString *)time
                status:(NSString *)status
                 title:(NSString *)title
                 location:(NSString *)location;
@end
