#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject
{
    NSString *databasePath;
}

+(DBManager*)getSharedInstance;
-(BOOL)createDB;
-(BOOL)insertData:(NSString*)name;
-(NSArray*) searchStudent:(NSInteger)id;

@end
