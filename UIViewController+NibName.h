
#import <UIKit/UIKit.h>

@interface UIViewController (NibName)

-(NSString*)getResolutionedNibName:(NSString*)nibName;
+(NSString*)getResolutionedNibName:(NSString*)nibName;

@end
