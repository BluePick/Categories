#import <Foundation/Foundation.h>


@interface NSString (Extensions)

- (NSString *)documentsDirectoryPath;
- (NSString *)cacheDirectoryPath;
- (NSString *)privateDirectoryPath;
- (NSString *)pathInDocumentDirectory;
- (NSString *)pathInCacheDirectory;
- (NSString *)pathInPrivateDirectory;
- (NSString *)pathInDirectory:(NSString *)dir cachedData:(BOOL)yesOrNo;
- (NSString *)pathInDirectory:(NSString *)dir;
- (NSString *)removeWhiteSpace;
- (NSString *)stringByNormalizingCharacterInSet:(NSCharacterSet *)characterSet withString:(NSString *)replacement;
- (NSString *)bindSQLCharacters;
- (NSString *)trimSpaces;
- (NSString *)stringByTrimmingLeadingCharactersInSet:(NSCharacterSet *)characterSet;
- (NSString *)stringByTrimmingLeadingWhitespaceAndNewlineCharacters;
- (NSString *)stringByTrimmingTrailingCharactersInSet:(NSCharacterSet *)characterSet;
- (NSString *)stringByTrimmingTrailingWhitespaceAndNewlineCharacters;
+ (BOOL)validateEmail:(NSString *)candidate;
+ (BOOL)validateForNumericAndCharacets:(NSString *)candidate WithLengthRange:(NSString *)strRange;
- (NSString *)flattenHTML;
- (void)saveAsCacheFile:(NSString*)fileName;
+ (NSString*)readCacheFile:(NSString*)fileName;

#define SAFESTRING(str) ISVALIDSTRING(str) ? str : @""
#define ISVALIDSTRING(str) (str != nil && [str isKindOfClass:[NSNull class]] == NO)
#define VALIDSTRING_PREDICATE [NSPredicate predicateWithBlock:^(id evaluatedObject, NSDictionary *bindings) {return (BOOL)ISVALIDSTRING(evaluatedObject);}]

@end
