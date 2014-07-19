//
//  CustomFontTextView.m
//  Poetry
//
//  Created by xoom3 on 5/28/14.
//  Copyright (c) 2014 XOOM. All rights reserved.
//

#import "CustomFontTextView.h"

@implementation CustomFontTextView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.font = [UIFont fontWithName:@"Quadon" size:self.font.pointSize];
    CALayer *layer = [self layer];
    [layer setBorderColor:COLOR_BG.CGColor];
    [layer setBorderWidth:2];
    self.placeholderText = self.accessibilityHint;
    self.text = self.text;
    
}

@end
