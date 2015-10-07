

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Database : NSObject {
	
}
+(void)createEditableCopyOfDatabaseIfNeeded;
+(NSString* )getDatabasePath;
+(NSMutableArray *)executeQuery:(NSString*)str;
+(BOOL)executeScalerQuery:(NSString*)str;
+(NSString*)encodedString:(const unsigned char *)ch;
+(void)update:(NSString*)table data:(NSMutableDictionary*)dict;
+(void)insert:(NSString*)table data:(NSMutableDictionary*)dict;
@end
