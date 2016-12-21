#import "DBManager.h"
static DBManager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation DBManager

+(DBManager*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}

-(BOOL)createDB{
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent: @"student.db"]];
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt = "create table if not exists Stud(id integer primary key, name text,phone text)";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }
            sqlite3_close(database);
            return  isSuccess;
        }
        else {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
    }
    return isSuccess;
}

-(BOOL)insertData:(NSString*)name:(NSString*)phone
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into Stud(name,phone) values(\"%@\",\"%@\")",name,phone];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE){
            return YES;
        }else {
            return NO;
        }
    sqlite3_reset(statement);
    }
    return NO;
}

-(BOOL)updateData:(NSInteger)id:(NSString*)name
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"update Stud set name=\"%@\" where id = %d",name,id];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(database, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
             NSLog(@"Success");
            return YES;
        }else
        {
             NSLog(@"Error");
            return NO;
        }
        sqlite3_reset(statement);
    }
    return NO;
}

-(BOOL)deleteData:(NSInteger)id
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
       
        NSString *deleteSQL = [NSString stringWithFormat:@"delete from Stud where id=%d",id];
        const char *delete_stmt = [deleteSQL UTF8String];
        sqlite3_prepare_v2(database, delete_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Success");
            return YES;
        }else
        {
            NSLog(@"Error");
            return NO;
        }
        sqlite3_reset(statement);
    }
    return NO;
}
- (NSArray*) searchStudent:(NSInteger)id
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
       // NSString *querySQL = [NSString stringWithFormat:@"select * from Stud where id=\"%d\"",id];
        NSString *querySQL = [NSString stringWithFormat:@"select * from Stud"];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database,query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
              if (sqlite3_step(statement) == SQLITE_ROW)
              {
                  while(sqlite3_step(statement)== SQLITE_ROW)
                  {
                      NSInteger id = sqlite3_column_int(statement, 0);
                      NSString *name = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 1)];
                      NSString *phone = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 2)];
                      
                      NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
                      [data setValue:[NSString stringWithFormat:@"%d",id] forKey:@"id"];
                      [data setValue:name forKey:@"name"];
                      [data setValue:phone forKey:@"phone"];
                      
                      [resultArray addObject:data];
                  }
                  sqlite3_reset(statement);
                  return resultArray;
              }
              else
              {
                  sqlite3_reset(statement);
                  NSLog(@"Not found");
                  return nil;
              }
              sqlite3_reset(statement);
        }
    }
    return nil;
}
@end
