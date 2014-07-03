//
//  UIViewController+statusbar.m
//  Platinum
//
//  Created by Darshit on 01/11/13.
//  Copyright (c) 2013 Tristate. All rights reserved.
//

#warning use in viewWillAppear --->    [self setStatusbar]; &  plist add View controller-based status bar appearance == NO


#import "UIViewController+statusbar.h"

@implementation UIViewController (statusbar)

-(void)setStatusbar{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.view.clipsToBounds = YES;

        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenHeight = screenRect.size.height;
        self.view.frame =  CGRectMake(0, 20, self.view.frame.size.width,screenHeight-20);
        self.view.bounds = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}



@end
