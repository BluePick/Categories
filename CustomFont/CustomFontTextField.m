//
//  CustomFontTextField.m
//  Poetry
//
//  Created by xoom3 on 5/28/14.
//  Copyright (c) 2014 XOOM. All rights reserved.
//

#import "CustomFontTextField.h"

@implementation CustomFontTextField
@synthesize textIndexPath;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.font = [UIFont fontWithName:@"Quadon" size:self.font.pointSize];
 //   [self setValue:[UIColor colorWithRed:0/255.0 green:121.0/255.0 blue:174.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.leftView = paddingView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

@end
