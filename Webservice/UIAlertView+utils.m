

#import "UIAlertView+utils.h"

@implementation UIAlertView (UIAlertView_utils)

+(void)infoAlertWithMessage:(NSString*)strMessage andTitle:(NSString*)title{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
												message:strMessage
												   delegate:nil 
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
}

@end
