

#import "CustomFontTextField.h"

@implementation CustomFontTextField
@synthesize textIndexPath;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.font = [UIFont fontWithName:self.tag?@"Whipsmart":@"Whipsmart-Bold" size:self.font.pointSize];
    [self setValue:!self.tag?[UIColor colorWithRed:0/255.0 green:121.0/255.0 blue:174.0/255.0 alpha:1.0]:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
}

@end
