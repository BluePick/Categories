
#import "UIView+NIB.h"

@implementation UIView (NIB)

+ (UIView *)loadView {
	NSArray* objects = [[NSBundle mainBundle] loadNibNamed:[self description] owner:self options:nil];
	
	for (id object in objects) {
		if ([object isKindOfClass:self]) {
			return object;
		}
	}
    
	[NSException raise:@"WrongNibFormat" format:@"Nib for '%@' must contain one TableViewCell, and its class must be '%@'", [self description], [self class]];	
	
	return nil;
}


@end
