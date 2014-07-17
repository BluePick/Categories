

#import "UIViewController+NibName.h"
#import "UIDevice+Resolutions.h"

@implementation UIViewController (NibName)

-(NSString*)getResolutionedNibName:(NSString*)nibName{
    UIDevice *currentDevice = [UIDevice currentDevice];
    NSString *name;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        name = [NSString stringWithFormat:@"%@_iPad",nibName];
    }
    else if([currentDevice resolution] == UIDeviceResolution_iPhoneRetina4){
        name = [NSString stringWithFormat:@"%@_iPhone5",nibName];
    }
    else {
        name = nibName;
    }
    return name;
}
+(NSString*)getResolutionedNibName:(NSString*)nibName{
    UIDevice *currentDevice = [UIDevice currentDevice];
    NSString *name;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        name = [NSString stringWithFormat:@"%@_iPad",nibName];
    }
    else if([currentDevice resolution] == UIDeviceResolution_iPhoneRetina4){
        name = [NSString stringWithFormat:@"%@_iPhone5",nibName];
    }
    else {
        name = nibName;
    }
    return name;
}
@end
