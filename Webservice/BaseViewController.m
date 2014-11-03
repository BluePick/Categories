

#import "BaseViewController.h"
#import "NetworkReachability.h"

@implementation BaseViewController
@synthesize HUD;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)isNetworkReachable{
    return isReachable;
}

- (void)ShowDataFetchError{
    [UIAlertView infoAlertWithMessage:@"Data not available or can not connect to server." andTitle:ALERTNAME];
}

- (void)showNoNetworkError{
    [UIAlertView infoAlertWithMessage:@"Please check Internet connection or can not connect to server." andTitle:ALERTNAME];
}

- (void)showHud {
    if (!HUD) {
        self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"Loading";
        [HUD show:YES];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    }
}

- (void)hidHud {
	if (HUD) {
		[HUD show:NO];
		[HUD removeFromSuperview];
        HUD = nil;
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
	}
}

#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
    isReachable = YES;
    appDelegate = (DLevAppDelegate*)[[UIApplication sharedApplication] delegate];
    viewFrame = [self.view bounds];
 //   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarFrameWillChange:) name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
    intialStatuHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    intialStatuHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    NetworkReachability * reach = [NetworkReachability reachabilityWithHostname:@"www.google.com"];
    
    reach.reachableBlock = ^(NetworkReachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            isReachable = YES;
        });
    };
    
    reach.unreachableBlock = ^(NetworkReachability * reachability)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            isReachable = NO;
        });
    };
    [reach startNotifier];
}
- (void)statusBarFrameWillChange:(NSNotification*)notification {
    NSValue* rectValue = [[notification userInfo] valueForKey:UIApplicationStatusBarFrameUserInfoKey];
    CGRect newFrame;
    [rectValue getValue:&newFrame];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.40];
    if(newFrame.size.height == 40){
        if(intialStatuHeight == 40){
            [self.view setFrame:CGRectMake(0.0, 0.0, viewFrame.size.width, viewFrame.size.height)];
        }
        else{
            [self.view setFrame:CGRectMake(0.0, 20.0, viewFrame.size.width, viewFrame.size.height)];
        }
        
    }
    else{
        if(intialStatuHeight == 40){
            [self.view setFrame:CGRectMake(0.0, -20, viewFrame.size.width, viewFrame.size.height)];
        }
        else{
            [self.view setFrame:CGRectMake(0.0, 0.0, viewFrame.size.width, viewFrame.size.height)];
        }
        
    }
    [UIView commitAnimations];
    // Move your view here ...
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController viewWillAppear:animated];
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController viewDidAppear:animated];
}

@end
