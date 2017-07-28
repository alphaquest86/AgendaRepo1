#import "AgendaDatabase.h"
#import "AgendaInfo.h"

@implementation AgendaDatabase

static AgendaDatabase *_database;

+ (AgendaDatabase*)database {
    if (_database == nil) {
        _database = [AgendaDatabase new];
    }
    return _database;
}

- (id)init {
    if ((self = [super init])) {
        NSString *sqLiteDb = [[NSBundle mainBundle] pathForResource:@"Agenda"
                                                             ofType:@"sqlite3"];
        
        if (sqlite3_open([sqLiteDb UTF8String], &_database) != SQLITE_OK) {
            NSLog(@"Failed to open database!");
        }
    }
    return self;
}

- (void)dealloc {
    sqlite3_close(_database);
}

- (NSArray *)agendaInfosWithDate:(NSDate *)date {
    
        NSString *sqLiteDb = [[NSBundle mainBundle] pathForResource:@"Agenda"
                                                             ofType:@"sqlite"];
        
        if (sqlite3_open([sqLiteDb UTF8String], &_database) != SQLITE_OK) {
            NSLog(@"Failed to open database!");
        }
    
    NSMutableArray *retval = [NSMutableArray array];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"dd/MM/YYYY";
    NSString *dateStr = [formatter stringFromDate:date];

    NSString *query = [NSString stringWithFormat:@"SELECT id, date, time, status, title, location FROM agenda_table WHERE date = \"%@\"",dateStr];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while ( sqlite3_step(statement)== SQLITE_ROW) {
            int uniqueId = sqlite3_column_int(statement, 0);
            char *dateChars = (char *) sqlite3_column_text(statement, 1);
            char *timeChars = (char *) sqlite3_column_text(statement, 2);
            char *statusChars = (char *) sqlite3_column_text(statement, 3);
            char *titleChars = (char *) sqlite3_column_text(statement, 4);
            char *locationChars = (char *) sqlite3_column_text(statement, 5);
          
            NSString *date = [[NSString alloc] initWithUTF8String:dateChars];
            NSString *time = [[NSString alloc] initWithUTF8String:timeChars];
            NSString *status = [[NSString alloc] initWithUTF8String:statusChars];
            NSString *title = [[NSString alloc] initWithUTF8String:titleChars];
            NSString *location = [[NSString alloc] initWithUTF8String:locationChars];

            AgendaInfo *info = [[AgendaInfo alloc]
                                initWithUniqueId:(int)uniqueId
                                date:date
                                time:time
                                status:status
                                title:title
                                location:location];
            [retval addObject:info];
        }
        sqlite3_finalize(statement);
    }
    return retval;
    
}
@end
