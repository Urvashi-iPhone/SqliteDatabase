#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject
{
    NSString *databasePath;
}

+(DBManager*)getSharedInstance;
-(BOOL)createDB;
-(BOOL)insertData:(NSString*)name:(NSString*)phone;
-(BOOL)updateData:(NSInteger)id:(NSString*)name;
-(BOOL)deleteData:(NSInteger)id;
-(NSArray*) searchStudent:(NSInteger)id;

@end
