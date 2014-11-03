

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "DLevAppDelegate.h"
#import "UIAlertView+utils.h"


@interface BaseViewController : UIViewController<UINavigationControllerDelegate>{
    MBProgressHUD *HUD;
    DLevAppDelegate *appDelegate;
    CGRect viewFrame;
    CGFloat intialStatuHeight;
    BOOL isReachable;
}
@property (nonatomic, retain) MBProgressHUD *HUD;
- (BOOL)isNetworkReachable;
- (void)showHud;
- (void)hidHud;
- (void)showNoNetworkError;
- (void)ShowDataFetchError;
@end
