
#import "NSURL+Extension.h"
#include <sys/xattr.h>

@implementation NSURL (Extension)

- (BOOL)addSkipBackupAttribute
{
    const char* filePath = [[self path] fileSystemRepresentation];
    
    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;
    
    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}

@end
