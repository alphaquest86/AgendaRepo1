#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface AgendaDatabase : NSObject {
    sqlite3 *_database;
}

+ (AgendaDatabase*)database;
- (NSArray *)agendaInfosWithDate:(NSDate *)date;
@end
