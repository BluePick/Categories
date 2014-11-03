//
//  NSString+Extensions.m
//
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSString+Extensions.h"


@implementation NSString (Extensions)

- (NSString *)documentsDirectoryPath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    
	return documentsDirectory;
}

- (NSString *)cacheDirectoryPath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
    
	return documentsDirectory;
}

- (NSString *)privateDirectoryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"Private Documents"];
    
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    
    return documentsDirectory;
    
}

- (NSString *)pathInDocumentDirectory
{
	NSString *documentsDirectory = [self documentsDirectoryPath];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:self];
	
	return path;
}

- (NSString *)pathInCacheDirectory
{
	NSString *documentsDirectory = [self cacheDirectoryPath];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:self];
	
	return path;
}

- (NSString *)pathInPrivateDirectory
{
	NSString *documentsDirectory = [self privateDirectoryPath];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:self];
	
	return path;
}

- (NSString *)pathInDirectory:(NSString *)dir cachedData:(BOOL)yesOrNo
{
	NSString *documentsDirectory = nil;
    if (yesOrNo) {
        documentsDirectory = [self cacheDirectoryPath];
    }
    else {
        documentsDirectory = [self documentsDirectoryPath];
    }
	NSString *dirPath = [documentsDirectory stringByAppendingString:dir];
	NSString *path = [dirPath stringByAppendingString:self];
	
	NSFileManager *manager = [NSFileManager defaultManager];
	[manager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
	
	return path;
}

- (NSString *)pathInDirectory:(NSString *)dir
{
    return [self pathInDirectory:dir cachedData:YES];
}

- (NSString *)removeWhiteSpace
{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)stringByNormalizingCharacterInSet:(NSCharacterSet *)characterSet withString:(NSString *)replacement
{
	NSMutableString* result = [NSMutableString string];
	NSScanner* scanner = [NSScanner scannerWithString:self];
	while (![scanner isAtEnd]) {
		if ([scanner scanCharactersFromSet:characterSet intoString:NULL]) {
			[result appendString:replacement];
		}
		NSString* stringPart = nil;
		if ([scanner scanUpToCharactersFromSet:characterSet intoString:&stringPart]) {
			[result appendString:stringPart];
		}
	}
    
	return [[result copy] autorelease];
}

- (NSString *)bindSQLCharacters
{
	NSString *bindString = self;
    
	bindString = [bindString stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
	
	return bindString;
}

- (NSString *)trimSpaces
{
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\t\n "]];
}

- (NSString *)stringByTrimmingLeadingCharactersInSet:(NSCharacterSet *)characterSet {
    NSRange rangeOfFirstWantedCharacter = [self rangeOfCharacterFromSet:[characterSet invertedSet]];
    if (rangeOfFirstWantedCharacter.location == NSNotFound) {
        return @"";
    }
    return [self substringFromIndex:rangeOfFirstWantedCharacter.location];
}

- (NSString *)stringByTrimmingLeadingWhitespaceAndNewlineCharacters {
    return [self stringByTrimmingLeadingCharactersInSet:
            [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)stringByTrimmingTrailingCharactersInSet:(NSCharacterSet *)characterSet {
    NSRange rangeOfLastWantedCharacter = [self rangeOfCharacterFromSet:[characterSet invertedSet]
                                                               options:NSBackwardsSearch];
    if (rangeOfLastWantedCharacter.location == NSNotFound) {
        return @"";
    }
    return [self substringToIndex:rangeOfLastWantedCharacter.location+1]; // non-inclusive
}

- (NSString *)stringByTrimmingTrailingWhitespaceAndNewlineCharacters {
    return [self stringByTrimmingTrailingCharactersInSet:
            [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


+ (BOOL)validateEmail:(NSString *)candidate
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
	
    return [emailTest evaluateWithObject:candidate];
}

// Range must be in {a,b}. Where a is mimimum length and b is max length
+ (BOOL)validateForNumericAndCharacets:(NSString *)candidate WithLengthRange:(NSString *)strRange
{
	BOOL valid = NO;
	NSCharacterSet *alphaNums = [NSCharacterSet alphanumericCharacterSet];
	NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:candidate];
	BOOL isAlphaNumeric = [alphaNums isSupersetOfSet:inStringSet];
	if(isAlphaNumeric){
		NSString *emailRegex = [NSString stringWithFormat:@"[%@]%@",candidate, strRange]; 
		NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
		valid =[emailTest evaluateWithObject:candidate];
	}
	return valid;
}

- (NSString *)flattenHTML {
    NSScanner *theScanner;
    NSString *text = nil;
    theScanner = [NSScanner scannerWithString:self];
    while ([theScanner isAtEnd] == NO) {
        [theScanner scanUpToString:@"<" intoString:NULL] ; 
        [theScanner scanUpToString:@">" intoString:&text] ;
        self = [self stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
    }
    self = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return self;
}
- (void)saveAsCacheFile:(NSString*)fileName{
    [self writeToFile:[fileName pathInDirectory:@"Response" cachedData:YES] atomically:YES encoding:NSUTF8StringEncoding error:nil];
}
+ (NSString*)readCacheFile:(NSString*)fileName{
    return [NSString stringWithContentsOfFile:[fileName pathInDirectory:@"Response" cachedData:YES] encoding:NSUTF8StringEncoding error:nil];
}

#define SAFESTRING(str) ISVALIDSTRING(str) ? str : @""
#define ISVALIDSTRING(str) (str != nil && [str isKindOfClass:[NSNull class]] == NO)
#define VALIDSTRING_PREDICATE [NSPredicate predicateWithBlock:^(id evaluatedObject, NSDictionary *bindings) {return (BOOL)ISVALIDSTRING(evaluatedObject);}]
@end