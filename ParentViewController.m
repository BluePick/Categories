
#import "ParentViewController.h"
#import "UIDevice+Resolutions.h"
#import "MenuViewController.h"
@interface ParentViewController ()

@end

@implementation ParentViewController

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.view.clipsToBounds = YES;
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenHeight = 0.0;
        if(UIDeviceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
            screenHeight = screenRect.size.height;
        else
            screenHeight = screenRect.size.width;
        CGRect screenFrame = CGRectMake(0, 20, self.view.frame.size.width,screenHeight-20);
        CGRect viewFrame1 = [self.view convertRect:self.view.frame toView:nil];
        if (!CGRectEqualToRect(screenFrame, viewFrame1)) {
            self.view.frame = screenFrame;
            self.view.bounds = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        }
    }
}



-(BOOL)isiOS7{
    return [[[UIDevice currentDevice] systemVersion] floatValue] >= 7?YES:NO;
}

-(BOOL)isForIphone4{
    UIDevice *currentDevice = [UIDevice currentDevice];
    return [currentDevice resolution] == UIDeviceResolution_iPhoneRetina4?YES:NO;
}

@end
