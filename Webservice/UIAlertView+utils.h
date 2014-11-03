

#import <Foundation/Foundation.h>

#define ALERTNAME @"Alert"

@interface UIAlertView (UIAlertView_utils)
+(void)infoAlertWithMessage:(NSString*)strMessage andTitle:(NSString*)title;
@end
